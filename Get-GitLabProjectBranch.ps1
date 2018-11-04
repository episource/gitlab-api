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
    [Parameter(Mandatory = $true, HelpMessage = 'ProjectID')]
    [Alias('ID')]
    [String]$ProjectID,

    # Name of the branch
    [Parameter(ParameterSetName = 'SingleBranch', Mandatory = $true,
            HelpMessage = 'The name of the branch')]
    [String]$Branch,
    
    # Branch protection rules (inlcuding patterns)
    [Parameter(ParameterSetName = 'ProtectedBranch', Mandatory = $true,
            HelpMessage = 'Get branch protection rules (acutal branches and patterns)')]
    [Parameter(ParameterSetName = 'SingleBranch', Mandatory = $false,
            HelpMessage = 'Get branch protection rules (acutal branches and patterns)')]
    [Switch]$ProtectionRules,

    # Existing GitlabConnector Object, can be retrieved with Get-GitlabConnect
    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
            Mandatory = $false, DontShow = $true)]
    [psobject]$GitlabConnect = (Get-GitlabConnect)
  )
  
  $httpmethod = 'get'
  $id = [System.Web.HttpUtility]::UrlEncode($projectId)
  $apiurl = "projects/$id/repository/branches"
  $parameters = @{}
  
  $filterProtectionRules = $false
  if ($PSCmdlet.MyInvocation.BoundParameters.keys -contains "ProtectionRules" -and $ProtectionRules) {
    $apiurl = "projects/$id/protected_branches"
    $filterProtectionRules = $PSCmdlet.ParameterSetName -like 'SingleBranch*'
  } elseif($PSCmdlet.ParameterSetName -like 'SingleBranch*') {
    $apiurl += "\$Branch"
  }

  $res = $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)
  if ($res -eq $null) {
    $res = @()
  }
  
  if($filterProtectionRules) {
    $res | ?{ $Branch -like $_.name } | write-output
  } else {
    @() + $res | write-output  
  }
}
