function Update-GitLabProjectMirror
{
  <#
      .Synopsis
      Initiates pulling branches from a mirror's source repo.
      .DESCRIPTION
      Mirror projects periodically pull branches from their source. This cmdlet
      forces an immediate pull.
      .EXAMPLE
      Update-GitLabProjectMirror -ProjectID 20
      ---------------------------------------------------------------
      Unprotect the branch staging.
  #>
  [CmdletBinding()]
  [Alias()]
  Param
  (
    # ID of the project
    [Parameter(HelpMessage = 'The Id of a project',
    Mandatory = $true)]
    [Alias('ID')]
    [int]$ProjectID,

    # Specify Existing GitlabConnector
    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [gitlabconnect]$GitlabConnect = (Get-GitlabConnect)
  )

    
  $httpmethod = 'post'
  $apiurl = "projects/$ProjectID/mirror/pull"
  $parameters = @{}

  $responseNotMandatory = $false
  $GitlabConnect.callapi($apiurl,$httpmethod,$parameters,$responseNotMandatory) | out-null
}
