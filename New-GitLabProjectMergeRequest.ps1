function New-GitLabProjectMergeRequest
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
    
    [Parameter(HelpMessage = 'Source Branch',mandatory = $true)]
    [Alias('source_branch')]
    [string]$SourceBranch,

    [Parameter(HelpMessage = 'target Branch',mandatory = $true)]
    [Alias('target_branch')]
    [string]$TargetBranch,

    [Parameter(HelpMessage = 'Title of MR',mandatory = $true)]
    [string]$Title,

    [Parameter(HelpMessage = 'description of the MR',mandatory = $false)]
    [string]$Description,

    [Parameter(HelpMessage = 'the target projects id',mandatory = $false)]
    [Alias('target_project_id')]
    [string]$TargetProjectID,

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

  $HTTPMethod = 'post'
  $APIUrl = "projects/$ID/merge_requests"
  $Parameters = @{
    title         = $Title
    'source_branch' = $SourceBranch
    'target_branch' = $TargetBranch
  }
   
  if($AssigneeID)
  {
    $Parameters.'assignee_id' = $AssigneeID
  }

  if($Description)
  {
    $Parameters.description = $Description
  }

  if($TargetProjectID)
  {
    $Parameters.'target_project_id' = $TargetProjectID
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
