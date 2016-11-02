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

    
  $httpmethod = 'put'
  $apiurl = "projects/$ProjectID/repository/branches/$Branch/unprotect"
  $parameters = @{}

  $updatebranch = $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)

  if($PassThru)
  {
    return $updatebranch
  }
}
