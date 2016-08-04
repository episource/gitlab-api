function Approve-GitLabProjectMergeRequest
{
  <#
      .Synopsis
      Merge changes submitted with MR using this API.
      .DESCRIPTION
      Merge changes submitted with MR using this API.

      If the -sha parameter is passed and does not match the HEAD of the source - you'll get a 409 and the error message 'SHA does not match HEAD of source branch'

      If the -ShouldRemoveSourceBranch parameter is passed teh source brances is removed after the merge.

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

    [Parameter(HelpMessage = 'Custom merge commit message',mandatory = $false)]
    [alias('merge_commit_message')]
    [string]$MergeCommitMessage,

    [Parameter(HelpMessage = 'removes the source branch')]
    [Alias('should_remove_dource_branch')]
    [switch]$ShouldRemoveSourceBranch,

    [Parameter(HelpMessage = 'MR is merged when the build succeeds')]
    [Alias('merge_when_build_succeeds')]
    [switch]$MergeWhenBuildSucceeds,

    [Parameter(HelpMessage = 'this SHA must match the HEAD of the source branch, otherwise the merge will fail')]
    [String]$sha,

    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [psobject]$GitlabConnect = (Get-GitlabConnect),

    [Parameter(HelpMessage = 'Passthru the created project',
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

  
  $GitlabConnect.callapi($APIUrl,$HTTPMethod,$Parameters)

  
  $updateMergeRequest = $GitlabConnect.callapi($APIUrl,$HTTPMethod,$Parameters)

  if($PassThru)
  {
    return $NupdateMergeRequest
  }
}
