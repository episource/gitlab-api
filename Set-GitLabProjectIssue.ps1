function Set-GitLabProjectIssue
{
  <#
      .SYNOPSIS
      Sets the properties on an issue you specify.
      .DESCRIPTION
      The Set-GitLabProjecctIssue function sets the properties you specify on a issue.
      Returns the modified issue when -PassThru is specified.
      .EXAMPLE
      Set-GitLabProjectIssue -ProjectID 20 -IssueID 1 -Title 'Renamed IssueID'
      ---------------------------------------------------------------
      Renames issue 1 on project 20 to 'Renamed IssueID'
      .EXAMPLE
      Set-GitLabProjectIssue -ProjectID 20 -IssueID 1 -StateEvent close
      ---------------------------------------------------------------
      Closes issue 1 on project 20
      .EXAMPLE
      Set-GitLabProjectIssue -ProjectID 20 -IssueID 1 -StateEvent reopen
      ---------------------------------------------------------------
      Reopens issue 1 on project 20
  #>
  [CmdletBinding()]
  [Alias()]
  [OutputType()]
  Param
  (
    # The Project ID
    [Parameter(HelpMessage = 'ProjectID',
    Mandatory = $true)]
    [Alias('ID')]
    [int]$ProjectID,
    
    # The ID of the issue
    [Parameter(HelpMessage = 'IssueID',
    Mandatory = $true)]
    [alias('issue_id')]
    [int]$IssueID,

    # The title for the issue
    [Parameter(Helpmessage = 'The title of an issue')]
    [string]$Title,

    # The description for the issue
    [Parameter(Helpmessage = 'The description of the issue',mandatory = $false)]
    [string]$Description,
    
    # The assignee ID for the issue
    [Parameter(Helpmessage = 'The ID of a user to assign issue',mandatory = $false)]
    [Alias('assignee_id')]
    [int]$AssigneeID,
    
    # The milestone ID to assign the issue to
    [Parameter(Helpmessage = 'The ID of a milestone to assign issue',mandatory = $false)]
    [Alias('milestone_id')]
    [int]$MilestoneID,
    
    # the labels to assign to the issue
    # overwrites any labels previously assigned
    [Parameter(HelpMessage = 'label names for an issue',mandatory = $false)]
    [string[]]$Labels,

    # Reopens or closes the Issue
    [Parameter(HelpMessage = 'StateEvent (opened|closed)')]
    [validateset('reopen','close')]
    [alias('state_event')]
    [string]$StateEvent,

    # Modify the creationdate the issue was created.
    [Parameter(Helpmessage = 'the date the issue was created',mandatory = $false)]
    [alias('updated_at')]
    [datetime]$UpdatedAt,

    # The Due Date for the issue
    [Parameter(Helpmessage = 'the due date of the issue',mandatory = $false)]
    [alias('due_date')]
    [datetime]$DueDate,

    # Existing GitlabConnector Object, can be retrieved with Get-GitlabConnect
    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [psobject]$GitlabConnect = (Get-GitlabConnect),

    # Return the modified issue
    [Parameter(HelpMessage = 'Passthru the modified issue',
    Mandatory = $false)]
    [switch]$PassThru
  )
  
  $httpmethod = 'put'
  $apiurl = "projects/$ID/issues/$IssueID"
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

  if($AssigneeID)
  {
    $parameters.'assignee_id' = $AssigneeID
  }

  if ($MilestoneID)
  {
    $parameters.'milestone_id' = $MilestoneID
  }

  if($Labels)
  {
    $parameters.labels = @($Labels) -join ','
  }

  if($StateEvent)
  {
    $parameters.'state_event' = $StateEvent
  }

  if($UpdatedAt)
  {
    $parameters.'updated_at' = $UpdatedAt.ToUniversalTime().tostring('s') +'Z'
  }

  if($DueDate)
  {
    $parameters.'due_date' = $DueDate.tostring("yyyy'-'MM'-'dd")
  }

  $modissue = $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)

  if($PassThru)
  {
    return $modissue
  }
}
