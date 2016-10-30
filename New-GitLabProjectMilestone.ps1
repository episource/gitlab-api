function New-GitLabProjectMilestone
{
  <#
      .SYNOPSIS
      Create a new project milestone.
      .DESCRIPTION
      The New-GitLabProjectMilestone function creates a new project milestone for a given project.

      By specifying -PassThru the created MR is returned.
      .EXAMPLE
      New-GitLabProjectMilestone -ProjectId 20 -Title 'v1.0.0'
      ---------------------------------------------------------------
      Creates a new milestone for project 20.
      .EXAMPLE
      New-GitLabProjectMilestone -ProjectId 20 -Title 'v1.0.0' -PassThru
      ---------------------------------------------------------------
      Creates a new milestone for project 20 and returns the Milestone.
  #>
  [CmdletBinding()]
  [Alias()]
  [OutputType()]
  Param
  (
    # The ID of the project
    [Parameter(HelpMessage = 'ProjectID',
    Mandatory = $true)]
    [Alias('ProjectID')]
    [int]$ID,

    # The title of the milestone
    [Parameter(Helpmessage = 'The title of an milestone', mandatory = $true)]
    [string]$Title,

    # Description of the milestone
    [Parameter(Helpmessage = 'The description of the milestone',mandatory = $false)]
    [string]$Description,

    # Due date of the milestone
    [Parameter(Helpmessage = 'the due date of the milestone',mandatory = $false)]
    [datetime]$dueDate,

    # Specify Existing GitlabConnector
    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [psobject]$GitlabConnect = (Get-GitlabConnect),

    # Return the created milestone
    [Parameter(HelpMessage = 'Passthru the created project',
    Mandatory = $false)]
    [switch]$PassThru
  )
  
  $httpmethod = 'post'
  $apiurl = "projects/$ID/milestones"
  $parameters = @{
    title = $Title
  }

  if($Description)
  {
    $parameters.description = $Description
  }

  if($dueDate)
  {
    $parameters.'due_date' = $dueDate.tostring("yyyy'-'MM'-'dd")
  }

  $newmilestone = $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)

  if($PassThru)
  {
    return $newmilestone
  }
}
