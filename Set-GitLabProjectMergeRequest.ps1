function Set-GitLabProjectMergeRequest
{
  <#
      .SYNOPSIS
      Modifie a Merge Request
      .DESCRIPTION
      The Set-GitLabProjectMergeRequest function modifies a given Merge Request.
      
      Can be used to merge a merge request using -StateEvent merge
      does not remove source branch.

      returns modified merge request when -PassThru is specified.
      .EXAMPLE
      Set-GitLabProjectMergeRequest -ProjectID 20 -MergeRequestID 2 -Description 'Updated Description'
      ---------------------------------------------------------------
      updates the description of MR 2 in project 20 to 'Updated Description'
      .EXAMPLE
      Set-GitLabProjectMergeRequest -ProjectID 20 -MergeRequestID 2 -StateEvent merge
      ---------------------------------------------------------------
      Merges Merge Request 2 in project 20.
      Does not remove source branch use Approve-GitLabProjectMergeRequest to do a complex merge
  #>
  [CmdletBinding()]
  [Alias()]
  [OutputType()]
  Param
  (
    # The ID of the project
    [Parameter(HelpMessage = 'ProjectID',
    Mandatory = $true)]
    [Alias('ID')]
    [String]$ProjectID,
    
    # The ID of the Merge Request
    [Parameter(HelpMessage = 'MergeRequestID',
    Mandatory = $true)]
    [Alias('MRID')]
    [string]$MergeRequestID,

    # Change the Target Branch.
    [Parameter(HelpMessage = 'target Branch',mandatory = $false)]
    [Alias('target_branch')]
    [string]$TargetBranch,

    # Title for the Merge Request
    [Parameter(HelpMessage = 'Title of MR',mandatory = $false)]
    [string]$Title,

    # Description for the Merge Request
    [Parameter(HelpMessage = 'description of the MR',mandatory = $false)]
    [string]$Description,

    # Modifies state of the Merge Request
    [Parameter(HelpMessage = 'StateEvent (reopen|close|merge)')]
    [validateset('reopen','close','merge')]
    [alias('state_event')]
    [string]$StateEvent,

    # ID of the assignee for the Merge Request
    [Parameter(Helpmessage = 'Assignee user ID',mandatory = $false)]
    [Alias('assignee_id')]
    [int]$AssigneeID,
    
    # ID of the Milestone to assign the Merge Request to
    [Parameter(Helpmessage = 'The ID of a milestone to assign MR',mandatory = $false)]
    [Alias('milestone_id')]
    [int]$MilestoneID,
    
    # the labels to assign to the Merge Request
    # overwrites any labels previously assigned
    [Parameter(HelpMessage = 'label names for an MR',mandatory = $false)]
    [string[]]$Labels,

    # Existing GitlabConnector Object, can be retrieved with Get-GitlabConnect
    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [psobject]$GitlabConnect = (Get-GitlabConnect),

    # Return the modified Merge Request
    [Parameter(HelpMessage = 'Passthru the modified Merge Request',
    Mandatory = $false)]
    [switch]$PassThru
  )

  $HTTPMethod = 'put'
  $APIUrl = "projects/$([System.Web.HttpUtility]::UrlEncode($projectId))/merge_requests/$MergeRequestID"
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
