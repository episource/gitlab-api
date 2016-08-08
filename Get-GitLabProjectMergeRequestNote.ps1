function Get-GitLabProjectMergeRequestNote
{
  <#
      .Synopsis
      Get Notes for a single Merge Request.
      .DESCRIPTION
      Get Notes for a single Merge Request.
      .Example
  #>
  [CmdletBinding(DefaultParameterSetName = 'AllNotes')]
  [Alias('Get-GitLabProjectMRNote')]
  [OutputType()]
  Param
  (
    #The ID of a project
    [Parameter(
        HelpMessage = 'ProjectID',
    Mandatory = $true)]
    [Alias('ProjectID')]
    [string]$ID,

    #The ID of a projects issue
    [Parameter(HelpMessage = 'MergeRequestID',
    Mandatory = $true)]
    [Alias('merge_request_id','MRID')]
    [string]$MergeRequestID,

    #The ID of a issues note
    [Parameter(ParameterSetName = 'SingleNote',
        HelpMessage = 'NoteID',
    Mandatory = $true)]
    [Alias('note_id')]
    [string]$NoteID,

    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [psobject]$GitlabConnect = (Get-GitlabConnect)
  )


  $httpmethod = 'get'
  $apiurl = "projects/$ID/merge_requests/$MergeRequestID/notes"
  $parameters = @{}

  if($PSCmdlet.ParameterSetName -like 'AllNotes')
  {
    #no further action required
  }

  if($PSCmdlet.ParameterSetName -like 'SingleNote')
  {
    $apiurl += "/$NoteID"
  }

  $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)
}
