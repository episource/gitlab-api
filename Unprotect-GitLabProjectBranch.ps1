function Unprotect-GitLabProjectBranch
{
  <#
      .Synopsis
      Unprotects a single project repository branch. 
      .DESCRIPTION
      Unprotects a single project repository branch. 
      .EXAMPLE
  #>
  [CmdletBinding()]
  [Alias()]
  [OutputType()]
  Param
  (
    [Parameter(HelpMessage = 'The Id of a project',
    Mandatory = $true)]
    [Alias('ProjectID')]
    [int]$ID,

    [Parameter(HelpMessage = 'The name of the branch',
    Mandatory = $true)]
    [String]$Branch,

    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [gitlabconnect]$GitlabConnect = (Get-GitlabConnect),

    [Parameter(HelpMessage = 'Passthru the created project',
    Mandatory = $false)]
    [switch]$PassThru
  )

    
  $httpmethod = 'put'
  $apiurl = "projects/$ID/repository/branches/$Branch/unprotect"
  $parameters = @{}

  $updatebranch = $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)

  if($PassThru)
  {
    return $updatebranch
  }
}
