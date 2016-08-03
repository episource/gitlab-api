function Add-GitLabProjectStar
{
  <#
      .Synopsis
      Sets the specified gitlab project as starred.
      .DESCRIPTION
      Sets the specified gitlab project as starred. user Remove-GitlabProjectStar to remove starred status of project
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

  $httpmethod = 'post'
  $apiurl = "projects/$id/star"
  $parameters = @{}

  $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)
}
