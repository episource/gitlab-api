function Get-GitLabProjectMergeRequestNote
{
  <#
      .SYNOPSIS
      Get Merge Request Note
      .DESCRIPTION
      Get note for specified Merge Request. 
      Returnes all notes by default, Specify -NoteID to return single note.
      .EXAMPLE
      Get-GitLabProjectMergeRequestNote -ProjectID 20 -MergeRequestID 1
      ---------------------------------------------------------------
      get all notes for project 20 and Merge Request 1
      .EXAMPLE
      Get-GitLabProjectMergeRequestNote -ProjectID 20 -MergeRequestID 1 -NoteID 3
      ---------------------------------------------------------------
      gets note 3 for project 20 and Merge Request 1 
  #>
  [CmdletBinding(DefaultParameterSetName = 'AllNotes')]
  [Alias('Get-GitLabProjectMRNote')]
  [OutputType()]
  Param
  (
    #The ID of a project
    [Parameter(HelpMessage = 'ProjectID',
        Mandatory = $true)]
    [Alias('ID')]
    [int]$ProjectID,

    #The ID of a projects Merge Request
    [Parameter(HelpMessage = 'MergeRequestID',
        Mandatory = $true)]
    [Alias('merge_request_id','MRID')]
    [string]$MergeRequestID,

    #The ID of a MergeRequests note
    [Parameter(ParameterSetName = 'SingleNote',
        HelpMessage = 'NoteID',
        Mandatory = $true)]
    [Alias('note_id')]
    [string]$NoteID,

    # Existing GitlabConnector Object, can be retrieved with Get-GitlabConnect
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
