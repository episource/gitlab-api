function Get-GitLabProjectIssueNote
{
  <#
      .Synopsis
      Get Notes for a single issue.
      .DESCRIPTION
      Get Notes for a single issue.
      .Example
  #>
  [CmdletBinding(DefaultParameterSetName = 'AllNotes')]
  [Alias()]
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
    [Parameter(HelpMessage = 'IssueID',
    Mandatory = $true)]
    [string]$IssueID,

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
  $apiurl = "projects/$ID/issues/$IssueID/notes"
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
