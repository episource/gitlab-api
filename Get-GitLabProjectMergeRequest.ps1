function Get-GitLabProjectMergeRequest
{
  <#
      .Synopsis
      Shows information about merge requests for this project.
      .DESCRIPTION
      Shows information about merge requests for this project.
      .Example
  #>
  [CmdletBinding(defaultParameterSetName = 'AllMergeRequests')]
  [Alias()]
  [OutputType()]
  Param
  (
    # Param1 help description
    [Parameter(HelpMessage = 'ProjectID',
    Mandatory = $true)]
    [Alias('ProjectID')]
    [string]$ID,

    # Return all requests or just those that are merged, opened or closed
    [Parameter(ParameterSetName = 'AllMergeRequests',
    HelpMessage = 'state (merged|opened|closed)')]
    [ValidateSet('merged','opened','closed')]
    [string]$state,

    # The ID of MR
    [Parameter(ParameterSetName = 'SingleMergeRequest',
        HelpMessage = 'The ID of MR',
    Mandatory = $true)]
    [Alias('merge_request_id')]
    [string]$MergeRequestID,

    [Parameter(ParameterSetName = 'SingleMergeRequest',
    HelpMessage = 'Include changes')]
    [switch]$IncludeChanges,

    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [psobject]$GitlabConnect = (Get-GitlabConnect)
  )

  $httpmethod = 'get'
  $apiurl = "projects/$ID/merge_requests"
  $parameters = @{
    id = $ID
  }

  if($PSCmdlet.ParameterSetName -like 'AllMergeRequests')
  {
    if($state)
    {
      $parameters.state = $state
    }
  }

  if($PSCmdlet.ParameterSetName -like 'SingleMergeRequest')
  {
    $apiurl += "/$MergeRequestID"

    if($IncludeChanges)
    {
      $apiurl += '/changes'
    }
  }

  $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)
}
