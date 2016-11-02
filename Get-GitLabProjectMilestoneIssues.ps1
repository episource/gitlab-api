function Get-GitLabProjectMilestoneIssues
{
  <#
      .SYNOPSIS
      Gets all issues assigned to a single project milestone.
      .DESCRIPTION
      Gets all issues assigned to a single project milestone of a given project.
      .EXAMPLE
      Get-GitLabProjectMilestoneIssues -ProjectID 20 -MilestoneID 1
      ---------------------------------------------------------------
      Get all  issues associated with mileston 1 project 20
  #>
  [CmdletBinding()]
  [Alias()]
  [OutputType()]
  Param
  (
    #The ID of a project
    [Parameter(HelpMessage = 'ProjectID',
    Mandatory = $true)]
    [Alias('ID')]
    [int]$ProjectID,

    #The ID of a projects Merge Request
    [Parameter(HelpMessage = 'MilestoneID',mandatory = $true)]
    [int]$MilestoneID,

    #The ID of a MergeRequests note
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
