function Add-GitLabProjectStar
{
  <#
      .SYNOPSIS
      Sets the specified gitlab project as starred.
      .DESCRIPTION
      Sets the specified gitlab project as starred. user Remove-GitlabProjectStar to remove starred status of project
      .EXAMPLE
      Add-GitLabProjectStar -ProjectID 20
      ---------------------------------------------------------------
      Stars Project 20 in GitLab
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
  $apiurl = "projects/$id/star"
  $parameters = @{}

  $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)
}
