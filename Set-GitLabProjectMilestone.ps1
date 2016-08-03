function Set-GitLabProjectMilestone
{
  <#
      .Synopsis
      Updates an existing project milestone.
      .DESCRIPTION
      Updates an existing project milestone for a given project.
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
    [int]$ID,
    
    [Parameter(HelpMessage = 'MilestonetID',
    Mandatory = $true)]
    [int]$MilestoneID,

    [Parameter(Helpmessage = 'The title of an milestone', mandatory = $false)]
    [string]$Title,

    [Parameter(Helpmessage = 'The description of the milestone',mandatory = $false)]
    [string]$Description,

    [Parameter(Helpmessage = 'the due date of the milestone',mandatory = $false)]
    [datetime]$dueDate,
    
    [Parameter(Helpmessage = 'The description of the milestone',mandatory = $false)]
    [validateSet('close','activate')]
    [Alias('StateEvent')]
    [string]$State,

    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [psobject]$GitlabConnect = (Get-GitlabConnect),

    [Parameter(HelpMessage = 'Passthru the created project',
    Mandatory = $false)]
    [switch]$PassThru
  )
  
  $httpmethod = 'put'
  $apiurl = "projects/$ID/milestones/$MilestoneID"
  $parameters = @{
  }

  if($Title)
  {
    $parameters.title = $Title
  }

  if($Description)
  {
    $parameters.description = $Description
  }

  if($dueDate)
  {
    $parameters.'due_date' = $dueDate.tostring("yyyy'-'MM'-'dd")
  }

  if($State)
  {
    $parameters.'state_event' = $State
  }

  $modmilestone = $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)

  if($PassThru)
  {
    return $modmilestone
  }
}
