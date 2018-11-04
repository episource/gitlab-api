function Get-GitLabProjectRepositoryContributors
{
  <#
      .SYNOPSIS
      Get contributors for project
      .DESCRIPTION
      The Get-GitLabProjectRepositoryContributors function retrieves all contributors for the sepecified project.
      Shows name, emailaddress and the amount of commits made
      .EXAMPLE
      Get-GitLabProjectRepositoryContributors -ProjectID 20
      ---------------------------------------------------------------
      retrieves all the contributors for project 20.
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
    [String]$ProjectID,

    # Existing GitlabConnector Object, can be retrieved with Get-GitlabConnect
    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [psobject]$GitlabConnect = (Get-GitlabConnect)
  )

  $httpmethod = 'get'
  $apiurl = "projects/$([System.Web.HttpUtility]::UrlEncode($projectId))/repository/contributors"
  $Parameters = @{}

  $GitlabConnect.callapi($apiurl,$httpmethod,$Parameters)
}
