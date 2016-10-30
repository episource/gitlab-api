function Get-GitLabProjectMergeRequestCommits
{
  <#
      .SYNOPSIS
      Gets all commits associated with specified Merge Request.
      .DESCRIPTION
      Gets all commits associated with specified Merge Request.
      .EXAMPLE
      Get-GitLabProjectMergeRequestCommits -ProjectID 20 -MergeRequestID 1
      ---------------------------------------------------------------
      Gets all commits associated with Merge Request 1 on porject 20
  #>
  [CmdletBinding()]
  [Alias('Get-GitLabProjectMRCommits')]
  [OutputType()]
  Param
  (
    #The ID of the project
    [Parameter(HelpMessage = 'ProjectID',
        Mandatory = $true)]
    [Alias('ProjectID')]
    [string]$ID,

    # The ID of the MR
    [Parameter(HelpMessage = 'The ID of MR',
        Mandatory = $true)]
    [Alias('merge_request_id')]
    [string]$MergeRequestID,

    # Existing GitlabConnector Object, can be retrieved with Get-GitlabConnect
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
