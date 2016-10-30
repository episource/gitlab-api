function Invoke-GitLabProjectArchive
{
  <#
      .SYNOPSIS
      Archives the a project
      .DESCRIPTION
      the function Archives the specified GitlabProject. 
      To unarchive a project use Invoke-GitLabProjectUnArchive to make it available again.
      .EXAMPLE
      Invoke-GitLabProjectArchive -ProjectID 20
      ---------------------------------------------------------------
      Archives project with ID 20
  #>
  [CmdletBinding()]
  [Alias()]
  [OutputType()]
  Param
  (
    # The ID of the project
    [Parameter(HelpMessage = 'ProjectID',
    Mandatory = $true)]
    [Alias('ProjectID')]
    [int]$id,

    # Existing GitlabConnector Object, can be retrieved with Get-GitlabConnect
    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [psobject]$GitlabConnect = (Get-GitlabConnect)
  )

  $httpmethod = 'post'
  $apiurl = "projects/$id/archive"
  $parameters = @{}

  $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)
}