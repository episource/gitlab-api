function Get-GitLabProjectMilestone
{
  <#
      .Synopsis
      get Milestones
      .DESCRIPTION
      Get all labels for a given project.
      .Example
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
