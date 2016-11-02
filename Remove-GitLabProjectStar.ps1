function Remove-GitLabProjectStar
{
  <#
      .SYNOPSIS
      Removes starred status from the specified gitlab project.
      .DESCRIPTION
      The Remove-GitlabProjectstar function removes starred status from the specified gitlab project. 
      use Add-GitlabProjectStar to add starred status of project
      .EXAMPLE
      Remove-GitLabProjectStar -ProjectID 20
      ---------------------------------------------------------------
      Removes the Star from project 20
  #>
  [CmdletBinding()]
  [Alias()]
  [OutputType()]
  Param
  (
    # The Project ID
    [Parameter(ParameterSetName = 'The ID of a project',
        HelpMessage = 'ProjectID',
    Mandatory = $true)]
    [Alias('ID')]
    [int]$ProjectID,

    # Specify Existing GitlabConnector
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
