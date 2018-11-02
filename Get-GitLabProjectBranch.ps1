function Get-GitLabProjectBranch
{
  <#
      .SYNOPSIS
      Gets GitLab Project Branches.
      .DESCRIPTION
      Get branch of specified project.
      By default all branches of the project are retrieved.

      when -Branch is specified only the specified branch is returned.
      If the branch is not found a 404 error is returned. 
      .EXAMPLE
      Get-GitLabProjectBranch -ProjectID 20
      ---------------------------------------------------------------
      Gets all branches for project 20
      .EXAMPLE
      Get-GitLabProjectBranch -ProjectID 20 -Branch 'master'
      ---------------------------------------------------------------
      Gets branch 'master' for project 20
  #>
  [CmdletBinding(DefaultParameterSetName = 'AllBranches')]
  [Alias()]
  [OutputType()]
  Param
  (
    # The ID of the project
    [Parameter(HelpMessage = 'ProjectID',
    Mandatory = $true)]
    [Alias('ID')]
    [int]$ProjectID,

    # Name of the branch
    [Parameter(ParameterSetName = 'SingleBranch',
        HelpMessage = 'The name of the branch',
    Mandatory = $true)]
    [String]$Branch,
    
    # Branch protection rules (inlcuding patterns)
    [Parameter(ParameterSetName = 'ProtectedBranch',
        HelpMessage = 'Get branch protection rules (acutal branches and patterns)',
        Mandatory = $true)]
    [Switch]$ProtectionRules,

    # Existing GitlabConnector Object, can be retrieved with Get-GitlabConnect
    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [psobject]$GitlabConnect = (Get-GitlabConnect)
  )

  $httpmethod = 'get'
  $apiurl = "projects/$ProjectID/repository/branches"
  $parameters = @{}
  
  if($PSCmdlet.ParameterSetName -like 'AllBranches')
  {
    #no extra action required
  }
  if($PSCmdlet.ParameterSetName -like 'SingleBranch')
  {
    $apiurl += "\$Branch"
  } elseif ($PSCmdlet.ParameterSetName -like 'ProtectedBranch')
  {
    $apiurl = "projects/$ProjectID/protected_branches"
  }

  $res = $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)
  if ($res -eq $null) {
    $res = @()
  }
  @() + $res | write-output  
}
