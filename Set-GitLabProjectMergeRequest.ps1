function Set-GitLabProjectMergeRequest
{
  <#
      .Synopsis
      Creates a new merge request
      .DESCRIPTION
      Creates a new merge request between given source and destination branch.
      .Example
  #>
  [CmdletBinding()]
  [Alias()]
  [OutputType()]
  Param
  (
    [Parameter(
        HelpMessage = 'ProjectID',
    Mandatory = $true)]
    [Alias('ProjectID')]
    [string]$ID,
    
    [Parameter(
        HelpMessage = 'MergeRequestID',
    Mandatory = $true)]
    [Alias('MRID')]
    [string]$MergeRequestID,

    [Parameter(HelpMessage = 'target Branch',mandatory = $false)]
    [Alias('target_branch')]
    [string]$TargetBranch,

    [Parameter(HelpMessage = 'Title of MR',mandatory = $false)]
    [string]$Title,

    [Parameter(HelpMessage = 'description of the MR',mandatory = $false)]
    [string]$Description,

    [Parameter(HelpMessage = 'StateEvent (opened|closed)')]
    [validateset('reopen','close','merge')]
    [alias('state_event')]
    [string]$StateEvent,

    [Parameter(Helpmessage = 'Assignee user ID',mandatory = $false)]
    [Alias('assignee_id')]
    [int]$AssigneeID,
    
    [Parameter(Helpmessage = 'The ID of a milestone to assign MR',mandatory = $false)]
    [Alias('milestone_id')]
    [int]$MilestoneID,
    
    [Parameter(HelpMessage = 'label names for an MR',mandatory = $false)]
    [string[]]$Labels,

    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [psobject]$GitlabConnect = (Get-GitlabConnect),

    [Parameter(HelpMessage = 'Passthru the created project',
    Mandatory = $false)]
    [switch]$PassThru
  )

  $HTTPMethod = 'put'
  $APIUrl = "projects/$ID/merge_requests/$MergeRequestID"
  $Parameters = @{}
  
  if($TargetBranch)
  {
    $Parameters.'target_branch' = $TargetBranch
  }

  if($AssigneeID)
  {
    $Parameters.'assignee_id' = $AssigneeID
  }

  if($Title)
  {
    $Parameters.title = $Title
  }

  if($Description)
  {
    $Parameters.description = $Description
  }

  if($StateEvent)
  {
    $Parameters.'state_event' = $StateEvent
  }

  if($Labels)
  {
    $Parameters.labels = @($Labels) -join ','
  }

  if($MilestoneID)
  {
    $Parameters.'milestone_id' = $MilestoneID
  }

  $NewMergeRequest = $GitlabConnect.callapi($APIUrl,$HTTPMethod,$Parameters)

  if($PassThru)
  {
    return $NewMergeRequest
  }
}
