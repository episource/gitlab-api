function Get-GitLabProjectRepositoryContributors
{
  <#
      .Synopsis
      Get repository contributors list
      .DESCRIPTION
      Get repository contributors list
      .Example
  #>
  [CmdletBinding()]
  [Alias()]
  [OutputType()]
  Param
  (
    # The ID of a project
    [Parameter(HelpMessage = 'ProjectID',
    Mandatory = $true)]
    [Alias('ProjectID')]
    [string]$ID,

    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [psobject]$GitlabConnect = (Get-GitlabConnect)
  )

  $httpmethod = 'get'
  $apiurl = "projects/$ID/repository/contributors"
  $Parameters = @{}

  $GitlabConnect.callapi($apiurl,$httpmethod,$Parameters)
}
