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
  [CmdletBinding()]
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
    [Parameter(HelpMessage = 'The name of the branch',
    Mandatory = $true)]
    [String]$Branch,

    # Flag if developers can push to the branch
    [Parameter(HelpMessage = 'Flag if developers can push to the branch',
    Mandatory = $false)]
    [Alias('developers_can_push')]
    [switch]$DevelopersCanPush,

    # Flag if developers can merge to the branch
    [Parameter(HelpMessage = 'Flag if developers can merge to the branch',
    Mandatory = $false)]
    [Alias('developers_can_merge')]
    [switch]$DevelopersCanMerge,

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

    
  $httpmethod = 'put'
  $apiurl = "projects/$ProjectID/repository/branches/$Branch/protect"
  $parameters = @{}

  if('DevelopersCanPush' -in $PSCmdlet.MyInvocation.BoundParameters.keys)
  {
    $parameters.'developers_can_push' = [string]$PSCmdlet.MyInvocation.BoundParameters.DevelopersCanPush
  }

  if('DevelopersCanMerge' -in $PSCmdlet.MyInvocation.BoundParameters.keys)
  {
    $parameters.'developers_can_merge' = [string]$PSCmdlet.MyInvocation.BoundParameters.DevelopersCanMerge
  }

  $updatebranch = $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)

  if($PassThru)
  {
    return $updatebranch
  }
}
