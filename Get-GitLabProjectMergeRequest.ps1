function Get-GitLabProjectMergeRequest
{
  <#
      .SYNOPSIS
      Gets Merge Request for project.
      .DESCRIPTION
      Get Merge Request for Project. Gets all Merge Requests for Project by default.
      can be filtered by state using -State.

      Returns single Merge Request when -MergeRequestID is specified.

      Retrieves changes associated with merge request when -IncludeChanges is specified.
      .EXAMPLE
      Get-GitLabProjectMergeRequest -ProjectID 20 
      ---------------------------------------------------------------
      gets all merge request created under project 20
      .EXAMPLE
      Get-GitLabProjectMergeRequest -ProjectID 20 -MergeRequestID 8 
      ---------------------------------------------------------------
      gets merge request 8 project 20
      .EXAMPLE
      Get-GitLabProjectMergeRequest -ProjectID 20 -MergeRequestID 8 -IncludeChanges 
      ---------------------------------------------------------------
      gets merge request 8 project 20 and includes all changes.
  #>
  [CmdletBinding(defaultParameterSetName = 'AllMergeRequests')]
  [Alias()]
  [OutputType()]
  Param
  (
    #The ID of a project
    [Parameter(HelpMessage = 'ProjectID',
        Mandatory = $true)]
    [Alias('ID')]
    [String]$ProjectID,

    # When specified returns only Merge Request that are merged, opened or closed
    [Parameter(ParameterSetName = 'AllMergeRequests',
        HelpMessage = 'State (merged|opened|closed)')]
    [ValidateSet('merged','opened','closed')]
    [string]$State,

    # Only return the Merge Rquest with specified ID.
    [Parameter(ParameterSetName = 'SingleMergeRequest',
        HelpMessage = 'The ID of MR',
        Mandatory = $true)]
    [Alias('merge_request_id')]
    [string]$MergeRequestID,

    # Adds Changes merged with Merge Request to returned object. 
    [Parameter(ParameterSetName = 'SingleMergeRequest',
        HelpMessage = 'Include changes')]
    [switch]$IncludeChanges,

    # Existing GitlabConnector Object, can be retrieved with Get-GitlabConnect
    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
        DontShow = $true)]
    [psobject]$GitlabConnect = (Get-GitlabConnect)
  )

  $httpmethod = 'get'
  $apiurl = "projects/$([System.Web.HttpUtility]::UrlEncode($projectId))/merge_requests"
  $parameters = @{
    id = $ProjectID
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
