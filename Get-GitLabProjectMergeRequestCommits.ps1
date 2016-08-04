function Get-GitLabProjectMergeRequestCommits
{
  <#
      .Synopsis
      Get a list of merge request commits.
      .DESCRIPTION
      Get a list of merge request commits. for teh specified project and merge request.
      .Example
  #>
  [CmdletBinding()]
  [Alias('Get-GitLabProjectMRCommits')]
  [OutputType()]
  Param
  (
    # Param1 help description
    [Parameter(HelpMessage = 'ProjectID',
    Mandatory = $true)]
    [Alias('')]
    [string]$ID,

    # The ID of MR
    [Parameter(HelpMessage = 'The ID of MR',
    Mandatory = $true)]
    [Alias('merge_request_id')]
    [string]$MergeRequestID,

    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [psobject]$GitlabConnect = (Get-GitlabConnect)
  )

  $httpmethod = 'get'
  $apiurl = "projects/$ID/merge_requests/$MergeRequestID/commits"
  $parameters = @{}

  $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)
}
