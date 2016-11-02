function New-GitLabProjectMergeRequest
{
  <#
      .SYNOPSIS
      Creates a new merge request
      .DESCRIPTION
      The New-GitLabProjectMergeRequest function creates a new merge request.
      By default the source branch, target branch and MR title must be passed.

      By specifying -PassThru the created MR is returned.
      .EXAMPLE
      New-GitLabProjectMergeRequest -ProjectID 20 -SourceBranch FeatureBranch -TargetBranch master -Title 'Implement new feature'
      ---------------------------------------------------------------
      Creates a merge request named 'Implement new feature' from FeatureBranch to master in project 20 
      .EXAMPLE
      New-GitLabProjectMergeRequest -ProjectID 20 -SourceBranch FeatureBranch -TargetBranch master -Title 'Implement new feature' -Passthru
      ---------------------------------------------------------------
      Creates a merge request named 'Implement new feature' from FeatureBranch to master in project 20.
      Returns the created Merge Request
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
    [int]$ProjectID,
    
    # The source branch for the MR
    [Parameter(HelpMessage = 'Source Branch',mandatory = $true)]
    [Alias('source_branch')]
    [string]$SourceBranch,

    # The target branch for the MR
    [Parameter(HelpMessage = 'target Branch',mandatory = $true)]
    [Alias('target_branch')]
    [string]$TargetBranch,

    # The Title for the MR 
    [Parameter(HelpMessage = 'Title of MR',mandatory = $true)]
    [string]$Title,

    # The description for the MR
    [Parameter(HelpMessage = 'description of the MR',mandatory = $false)]
    [string]$Description,

    # The Target Project for the MR
    # By default uses the source project.
    [Parameter(HelpMessage = 'the target projects id',mandatory = $false)]
    [Alias('target_project_id')]
    [string]$TargetProjectID,

    # Assigns this MR to the user specified
    [Parameter(Helpmessage = 'Assignee user ID',mandatory = $false)]
    [Alias('assignee_id')]
    [int]$AssigneeID,
    
    # Assigns this MR to a milestone
    [Parameter(Helpmessage = 'The ID of a milestone to assign MR',mandatory = $false)]
    [Alias('milestone_id')]
    [int]$MilestoneID,
    
    # Assigns the labels to the MR
    [Parameter(HelpMessage = 'label names for an MR',mandatory = $false)]
    [string[]]$Labels,

    # Specify Existing GitlabConnector
    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [psobject]$GitlabConnect = (Get-GitlabConnect),

    # Return the created Merge Request 
    [Parameter(HelpMessage = 'Passthru the created MR',
    Mandatory = $false)]
    [switch]$PassThru
  )

  $HTTPMethod = 'post'
  $APIUrl = "projects/$ProjectID/merge_requests"
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
