function New-GitLabProjectIssue
{
  <#
      .Synopsis
      Creates a new project issue.
      .DESCRIPTION
      Creates a new project issue for a given project.
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

    [Parameter(Helpmessage = 'The title of an issue', mandatory = $true)]
    [string]$Title,

    [Parameter(Helpmessage = 'The description of the issue',mandatory = $false)]
    [string]$Description,
    
    [Parameter(Helpmessage = 'The ID of a user to assign issue',mandatory = $false)]
    [Alias('assignee_id')]
    [int]$AssigneeID,
    
    [Parameter(Helpmessage = 'The ID of a milestone to assign issue',mandatory = $false)]
    [Alias('milestone_id')]
    [int]$MilestoneID,
    
    [Parameter(HelpMessage = 'label names for an issue',mandatory = $false)]
    [string[]]$Labels,

    [Parameter(Helpmessage = 'the date the issue was created',mandatory = $false)]
    [alias('created_at')]
    [datetime]$CreatedAt,

    [Parameter(Helpmessage = 'the due date of the issue',mandatory = $false)]
    [alias('due_date')]
    [datetime]$DueDate,

    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [psobject]$GitlabConnect = (Get-GitlabConnect),

    [Parameter(HelpMessage = 'Passthru the created project',
    Mandatory = $false)]
    [switch]$PassThru
  )
  
  $httpmethod = 'post'
  $apiurl = "projects/$ID/issues"
  $parameters = @{
    title = $Title
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

  if($CreatedAt)
  {
    $parameters.'created_at' = $CreatedAt.ToUniversalTime().tostring('s') +'Z'
  }

  if($DueDate)
  {
    $parameters.'due_date' = $DueDate.tostring("yyyy'-'MM'-'dd")
  }

  $newissue = $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)

  if($PassThru)
  {
    return $newissue
  }
}
