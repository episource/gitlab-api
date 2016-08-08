function Set-GitLabProjectIssueNote
{
  <#
      .Synopsis
      Modify existing note of an issue.
      .DESCRIPTION
      Modify existing note of an issue.
      .Example
  #>
  [CmdletBinding()]
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

    #The ID of the issues Note
    [Parameter(HelpMessage = 'NoteID',
    Mandatory = $true)]
    [Alias('note_id')]
    [string]$NoteID,

    #The content of a note
    [Parameter(HelpMessage = 'The content of a note',
    Mandatory = $true)]
    [string]$body,

    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [psobject]$GitlabConnect = (Get-GitlabConnect),

    [Parameter(HelpMessage = 'Passthru the created label',
    Mandatory = $false)]
    [switch]$PassThru

  )

  $httpmethod = 'put'
  $apiurl = "projects/$ID/issues/$IssueID/notes/$NoteID"
  $parameters = @{
    body = $body
  }


  $newnote = $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)

  if($PassThru)
  {
    return $newnote
  }
}
