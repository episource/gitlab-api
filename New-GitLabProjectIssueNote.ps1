function New-GitLabProjectIssueNote
{
  <#
      .SYNOPSIS
      Adds a single note to an issue
      .DESCRIPTION
      The New-GitLabProjectIssueNote function adds a single note to an issue.
      .EXAMPLE
      New-GitLabProjectIssueNote -ProjectID 20 -IssueID 1 -Body 'Started research'
      ---------------------------------------------------------------
      Adds a new note reading 'Started research' to issue 1 in project 20
      .EXAMPLE
      New-GitLabProjectIssueNote -ProjectID 20 -IssueID 1 -Body 'Started research' -PassThru
      ---------------------------------------------------------------
      Adds a new note reading 'Started research' to issue 1 in project 20 and returns the newly created note.
  #>
  [CmdletBinding()]
  [Alias()]
  [OutputType()]
  Param
  (
    # The ID of the project
    [Parameter(HelpMessage = 'ProjectID',
    Mandatory = $true)]
    [Alias('ProjectID')]
    [string]$ID,

    # The ID of the projects issue
    [Parameter(HelpMessage = 'IssueID',
    Mandatory = $true)]
    [string]$IssueID,

    # The content of the note
    [Parameter(HelpMessage = 'The content of a note',
    Mandatory = $true)]
    [string]$Body,

    # The time the note was created
    [Parameter(HelpMessage = 'time of creation',
    Mandatory = $false)]
    [Alias('created_at')]
    [DateTime]$CreatedAt,

    # Specify Existing GitlabConnector
    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [psobject]$GitlabConnect = (Get-GitlabConnect),

    # Passthru the created label
    [Parameter(HelpMessage = 'Passthru the created label',
    Mandatory = $false)]
    [switch]$PassThru

  )

  $httpmethod = 'post'
  $apiurl = "projects/$ID/issues/$IssueID/notes"
  $parameters = @{
    body = $body
  }

  if($CreatedAt)
  {
    $parameters.'created_at' = $CreatedAt.ToUniversalTime().tostring('s') +'Z'
  }

  $newnote = $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)

  if($PassThru)
  {
    return $newnote
  }
}
