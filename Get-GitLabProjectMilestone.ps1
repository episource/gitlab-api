function Get-GitLabProjectMilestone
{
  <#
      .SYNOPSIS
      Gets Milestone for project.
      .DESCRIPTION
      Gets Milestone for Project. Gets all Milestone for Project by default.
      can be filtered by state using -State.

      Returns single Milestone when -MilestoneID is specified.
      .EXAMPLE
      Get-GitLabProjectMilestone -ProjectID 20
      ---------------------------------------------------------------
      gets all milestones created under project 20
  #>
  [CmdletBinding(DefaultParameterSetName = 'AllMilestones')]
  [Alias()]
  [OutputType()]
  Param
  (
    [Parameter(HelpMessage = 'ProjectID',
    Mandatory = $true)]
    [Alias('ProjectID')]
    [int]$id,

    [Parameter(ParameterSetName = 'AllMilestones', mandatory = $false)]
    [validateset('active','closed')]
    [string]$State,

    [Parameter(HelpMessage = 'MilestoneID',
    ParameterSetName = 'SingleMilestone',mandatory = $true)]
    [int]$MilestoneID,

    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [psobject]$GitlabConnect = (Get-GitlabConnect)
  )
  
  $httpmethod = 'get'
  $apiurl = "projects/$id/milestones"
  $parameters = @{}
  if($State)
  {
    $parameters.state = $State
  }

  if($MilestoneID)
  {
    $apiurl += "/$MilestoneID"
  }

  $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)
}
