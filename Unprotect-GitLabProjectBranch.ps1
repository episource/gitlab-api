function Unprotect-GitLabProjectBranch
{
  <#
      .Synopsis
      Unprotects a project repository branch. 
      .DESCRIPTION
      The Unprotect-GitLabProjectBranch function unprotects the specified branch.
      .EXAMPLE
      Unprotect-GitLabProjectBranch -ProjectID 20 -Branch staging
      ---------------------------------------------------------------
      Unprotect the branch staging.
  #>
  [CmdletBinding()]
  [Alias()]
  [OutputType()]
  Param
  (
    # ID of the project
    [Parameter(HelpMessage = 'The Id of a project',
    Mandatory = $true)]
    [Alias('ID')]
    [int]$ProjectID,

    # Name of the branch
    [Parameter(HelpMessage = 'The name of the branch',
    Mandatory = $true)]
    [Alias('Pattern')]
    [String]$Branch,

    # Specify Existing GitlabConnector
    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [gitlabconnect]$GitlabConnect = (Get-GitlabConnect),

    # Passthru the modified branch
    [Parameter(HelpMessage = 'Passthru the modified branch',
    Mandatory = $false)]
    [switch]$PassThru
  )

    
  $httpmethod = 'delete'
  $apiurl = "projects/$ProjectID/protected_branches/$Branch"
  $parameters = @{}

  $responseNotMandatory = $false
  $updatebranch = $GitlabConnect.callapi($apiurl,$httpmethod,$parameters,$responseNotMandatory)

  if($PassThru)
  {
    return Get-GitlabProjectBranch -ProjectId $projectId -ProtectionRules
  }
}
