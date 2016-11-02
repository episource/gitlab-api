function Invoke-GitLabProjectUnArchive
{
  <#
      .SYNOPSIS
      Unarchives the a project
      .DESCRIPTION
      The function unarchives the specified GitlabProject. 
      To archive a project use Invoke-GitLabProjectArchive to archive it.
      .EXAMPLE
      Invoke-GitLabProjectUnArchive -ProjectID 20
      ---------------------------------------------------------------
      Unarchives project with ID 20
  #>
  [CmdletBinding()]
  [Alias()]
  [OutputType()]
  Param
  (
    # The ID of the project
    [Parameter(HelpMessage = 'ProjectID',
    Mandatory = $true)]
    [Alias('ID')]
    [int]$ProjectID,

    # Existing GitlabConnector Object, can be retrieved with Get-GitlabConnect
    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [psobject]$GitlabConnect = (Get-GitlabConnect)
  )

  $httpmethod = 'post'
  $apiurl = "projects/$id/unarchive"
  $parameters = @{}

  $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)
}