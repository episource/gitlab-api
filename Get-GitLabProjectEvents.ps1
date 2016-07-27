function Get-GitLabProjectEvents
{
  <#
      .Synopsis
      Get the events for the specified project.
      .DESCRIPTION
      Get the events for the specified project. Sorted from newest to latest.
  #>
  [CmdletBinding()]
  [Alias()]
  [OutputType()]
  Param
  (
    # Param1 help description
    [Parameter(ParameterSetName = 'The ID of a project',
        HelpMessage = 'ProjectID',
    Mandatory = $true)]
    [Alias('ProjectID')]
    [int]$id,

    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [psobject]$GitlabConnect = (Get-GitlabConnect)
  )

  $httpmethod = 'get'
  $apiurl = "projects/$id/events"
  $parameters = @{}

  $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)
}
