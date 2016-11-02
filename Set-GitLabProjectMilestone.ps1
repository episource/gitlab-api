function Set-GitLabProjectMilestone
{
  <#
      .SYNOPSIS
      modifie a milestone
      .DESCRIPTION
      The Set-GitLabProjectMilestone function edits an existing Milestone in gitlab.

      Use -PassThru to return the modified Milestone
      .EXAMPLE
      Set-GitLabProjectMilestone -ProjectID 20 -MilestoneID 1 -Description 'Release v1.0.0'
      ---------------------------------------------------------------
      Sets the description of milestone 1 in project 20 to 'Release v1.0.0' 
  #>
  [CmdletBinding()]
  [Alias()]
  [OutputType()]
  Param
  (
    # ID of the porject
    [Parameter(HelpMessage = 'ProjectID',
    Mandatory = $true)]
    [Alias('ID')]
    [int]$ProjectID,
    
    # ID of th milestone
    [Parameter(HelpMessage = 'MilestoneID',
    Mandatory = $true)]
    [int]$MilestoneID,

    # Title for the Milestone
    [Parameter(Helpmessage = 'The title of an milestone', mandatory = $false)]
    [string]$Title,

    # Description for the milestone
    [Parameter(Helpmessage = 'The description of the milestone',mandatory = $false)]
    [string]$Description,

    # Due Date for the milestone
    [Parameter(Helpmessage = 'the due date of the milestone',mandatory = $false)]
    [datetime]$dueDate,
    
    # Set a state=-event for the milestone.
    # the Milestone event can be 'close' or 'activate'
    [Parameter(Helpmessage = 'stateevent for the milestone',mandatory = $false)]
    [validateSet('close','activate')]
    [Alias('StateEvent')]
    [string]$State,


    # Existing GitlabConnector Object, can be retrieved with Get-GitlabConnect
    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [psobject]$GitlabConnect = (Get-GitlabConnect),

    # Return the modified Merge Request
    [Parameter(HelpMessage = 'Passthru the created project',
    Mandatory = $false)]
    [switch]$PassThru
  )
  
  $httpmethod = 'put'
  $apiurl = "projects/$ProjectID/milestones/$MilestoneID"
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
