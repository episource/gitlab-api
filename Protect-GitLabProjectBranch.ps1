function Protect-GitLabProjectBranch
{
  <#
      .Synopsis
      Protects a project repository branch. 
      .DESCRIPTION
      The Protect-GitLabProjectBranch function protects the specified branch.
      If developers are allowed to merge or push specify -DevelopersCanMerge or -DevelopersCanPush
      .EXAMPLE
      Protect-GitLabProjectBranch -ProjectID 20 -Branch staging
      ---------------------------------------------------------------
      Protect the branch staging from deletion or pushing.
      .EXAMPLE
      Protect-GitLabProjectBranch -ProjectID 20 -Branch staging -DevelopersCanMerge
      ---------------------------------------------------------------
      Protect the branch staging from deletion or pushing. Developers are allowed to merge.
      .EXAMPLE
      Protect-GitLabProjectBranch -ProjectID 20 -Branch staging -Passthru
      ---------------------------------------------------------------
      Protect the branch staging from deletion or pushing.
      Returns the updated branch.
  #>
  [CmdletBinding(DefaultParameterSetName='AccessLevel')]
  [Alias()]
  [OutputType()]
  Param
  (
    # The ID of the project
    [Parameter(HelpMessage = 'The Id of a project',
    Mandatory = $true)]
    [Alias('ID')]
    [int]$ProjectID,

    # The name of the branch
    [Parameter(HelpMessage = 'The name of the branch or pattern',
        Mandatory = $true)]
    [Alias('Pattern')]
    [String]$Branch,

    # Flag if developers can push to the branch
    [Parameter(HelpMessage = 'Flag if developers can push to the branch',
        Mandatory = $false,
        ParameterSetName='Legacy')]
    [Alias('developers_can_push')]
    [switch]$DevelopersCanPush,

    # Flag if developers can merge to the branch
    [Parameter(HelpMessage = 'Flag if developers can merge to the branch',
        Mandatory = $false,
        ParameterSetName='Legacy')]
    [Alias('developers_can_merge')]
    [switch]$DevelopersCanMerge,
    
    # Who can push
    [Parameter(HelpMessage = 'Required access level for push operations',
        Mandatory = $false,
        ParameterSetName='AccessLevel')]
    [AccessLevel]$AccessLevelPush = [AccessLevel]::Maintainers,
    
    # Who can merge
    [Parameter(HelpMessage = 'Required access level for merging',
        Mandatory = $false,
        ParameterSetName='AccessLevel')]
    [AccessLevel]$AccessLevelMerge = [AccessLevel]::Maintainers,
    
    # Who can unprotect
    [Parameter(HelpMessage = 'Required access level to unprotect the branch',
        Mandatory = $false,
        ParameterSetName='AccessLevel')]
    [AccessLevel]$AccessLevelUnprotect = [AccessLevel]::Maintainers,

    #Specify Existing GitlabConnector
    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [gitlabconnect]$GitlabConnect = (Get-GitlabConnect),

    # Return the updated Branch
    [Parameter(HelpMessage = 'Passthru the updated branch',
    Mandatory = $false)]
    [switch]$PassThru
  )

    
  $httpmethod = 'post'
  $apiurl = "projects/$ProjectID/protected_branches"
  $parameters = @{}
  $parameters.name = $branch
  $parameters.push_access_level = [int][AccessLevel]::Maintainers
  $parameters.merge_access_level = [int][AccessLevel]::Maintainers
  $parameters.unprotect_access_level = [int][AccessLevel]::Maintainers

  if ($PSCmdlet.ParameterSetName -like 'Legacy') {
      if('DevelopersCanPush' -in $PSCmdlet.MyInvocation.BoundParameters.keys)
      {
        if ($DevelopersCanPush) {
          $parameters.push_access_level = [int][AccessLevel]::Developers
        }
      }

      if('DevelopersCanMerge' -in $PSCmdlet.MyInvocation.BoundParameters.keys)
      {
        if ($DevelopersCanMerge) {
          $parameters.merge_access_level = [int][AccessLevel]::Developers
        }
      }
  } elseif ($PSCmdlet.ParameterSetName -like 'AccessLevel') {
    $parameters.push_access_level = [int]$AccessLevelPush
    $parameters.merge_access_level = [int]$AccessLevelMerge
    $parameters.unprotect_access_level = [int]$AccessLevelUnprotect
  }

  $responseNotMandatory = $false
  $updatebranch = $GitlabConnect.callapi($apiurl,$httpmethod,$parameters,$responseNotMandatory)

  if($PassThru)
  {
    Get-GitlabProjectBranch -ProjectId $projectId -ProtectionRules | write-output
  }
}
