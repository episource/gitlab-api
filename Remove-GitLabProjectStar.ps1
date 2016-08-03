function Remove-GitLabProjectStar
{
  <#
      .Synopsis
      Removes starred status from the specified gitlab project.
      .DESCRIPTION
      Removes starred status from the specified gitlab project. user Add-GitlabProjectStar to add starred status of project
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

  $httpmethod = 'delete'
  $apiurl = "projects/$id/star"
  $parameters = @{}

  $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)
}
