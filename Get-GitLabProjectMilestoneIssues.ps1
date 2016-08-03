function Get-GitLabProjectMilestoneIssues
{
  <#
      .Synopsis
      Gets all issues assigned to a single project milestone.
      .DESCRIPTION
      Gets all issues assigned to a single project milestone of a given project.
      .Example
  #>
  [CmdletBinding()]
  [Alias()]
  [OutputType()]
  Param
  (
    [Parameter(HelpMessage = 'ProjectID',
    Mandatory = $true)]
    [Alias('ProjectID')]
    [int]$id,

    [Parameter(HelpMessage = 'MilestoneID',mandatory = $true)]
    [int]$MilestoneID,

    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [psobject]$GitlabConnect = (Get-GitlabConnect)
  )
  
  $httpmethod = 'get'
  $apiurl = "projects/$id/milestones/$MilestoneID/issues"
  $parameters = @{}

  $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)
}
