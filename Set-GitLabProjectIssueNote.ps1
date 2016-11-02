function Set-GitLabProjectIssueNote
{
  <#
      .SYNOPSIS
      Modify an Existing Note on an issue.
      .DESCRIPTION
      The Set-GitLabProjectIssueNote function modifies an existing note on an issue.
      You can retrieve note ids using Get-GitLabProjectIssueNote.
      when -PassThru is specified the modified note is returned.
      .EXAMPLE
      Set-GitLabProjectIssueNote -ProjectID 20 -IssueID 15 -NoteID 1 -Body 'Interresting Comment'
      ---------------------------------------------------------------
      Sets the content of note 1 on issue 15 for project 20 to 'Interresting Comment'
      .EXAMPLE
      Set-GitLabProjectIssueNote -ProjectID 20 -IssueID 15 -NoteID 1 -Body 'Interresting Comment' -PassThru
      ---------------------------------------------------------------
      Sets the content of note 1 on issue 15 for project 20 to 'Interresting Comment'
      Returns the modified Note.
  #>
  [CmdletBinding()]
  [Alias()]
  [OutputType()]
  Param
  (
    #The ID of the project
    [Parameter(HelpMessage = 'ProjectID',
    Mandatory = $true)]
    [Alias('ID')]
    [int]$ProjectID,

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
    [string]$Body,

    # Existing GitlabConnector Object, can be retrieved with Get-GitlabConnect
    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [psobject]$GitlabConnect = (Get-GitlabConnect),

    # Return the modified issue note
    [Parameter(HelpMessage = 'Passthru the modified issue note',
    Mandatory = $false)]
    [switch]$PassThru

  )

  $httpmethod = 'put'
  $apiurl = "projects/$ProjectID/issues/$IssueID/notes/$NoteID"
  $parameters = @{
    body = $body
  }


  $newnote = $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)

  if($PassThru)
  {
    return $newnote
  }
}
