function Approve-GitLabProjectMergeRequest
{
  <#
      .SYNOPSIS
      Merge changes submitted with MR.
      .DESCRIPTION
      Merge changes submitted with MR.

      If the -sha parameter is passed and does not match the HEAD of the source - you'll get a 409 and the error message 'SHA does not match HEAD of source branch'

      If the -ShouldRemoveSourceBranch parameter is passed the source brances is removed after the merge.
      .EXAMPLE
      Approve-GitLabProjectMergeRequest -ProjectID 20 -MergeRequestID 1
      ---------------------------------------------------------------
      Approves Merge Request 1 for Gitlabproject 20      
      .EXAMPLE
      Approve-GitLabProjectMergeRequest -ProjectID 20 -MergeRequestID 1 -ShouldRemoveSourceBranch
      ---------------------------------------------------------------
      Approves Merge Request 1 for Gitlabproject 20 and removes sourcebranch
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
    [string]$ID,
    
    # The ID of the MergeRequest
    [Parameter(HelpMessage = 'MergeRequestID',
    Mandatory = $true)]
    [Alias('MRID')]
    [string]$MergeRequestID,

    # Add a Custom merge commit message for the Merge
    [Parameter(HelpMessage = 'Custom merge commit message'
    ,mandatory = $false)]
    [alias('merge_commit_message')]
    [string]$MergeCommitMessage,

    # If Specified removes the source branch after Merge
    [Parameter(HelpMessage = 'removes the source branch')]
    [Alias('should_remove_dource_branch')]
    [switch]$ShouldRemoveSourceBranch,

    # If Specified will only merge when build succeeds
    [Parameter(HelpMessage = 'MR is merged when the build succeeds')]
    [Alias('merge_when_build_succeeds')]
    [switch]$MergeWhenBuildSucceeds,

    # this SHA must match the HEAD of the source branch, otherwise the merge will fail
    [Parameter(HelpMessage = 'Merge should match SHA')]
    [String]$sha,

    # Existing GitlabConnector Object, can be retrieved with Get-GitlabConnect
    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [psobject]$GitlabConnect = (Get-GitlabConnect),

    # Returns the modified Merge Request. By default, this cmdlet does not generate any output.
    [Parameter(HelpMessage = 'Passthru the modified Merge Request',
    Mandatory = $false)]
    [switch]$PassThru
  )

  $HTTPMethod = 'put'
  $APIUrl = "projects/$ID/merge_requests/$MergeRequestID/merge"
  $Parameters = @{}

  if($MergeCommitMessage)
  {
    $Parameters.'merge_commit_message' = $MergeCommitMessage
  }

  if($ShouldRemoveSourceBranch)
  {
    $Parameters.'should_remove_source_branch' = 'true'
  }

  if($MergeWhenBuildSucceeds)
  {
    $Parameters.'merge_when_build_succeeds' = 'true'
  }

  if($sha)
  {
    $Parameters.sha = $sha
  }
  
  $updateMergeRequest = $GitlabConnect.callapi($APIUrl,$HTTPMethod,$Parameters)

  if($PassThru)
  {
    return $NupdateMergeRequest
  }
}
