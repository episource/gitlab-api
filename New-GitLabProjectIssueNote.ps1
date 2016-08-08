function New-GitLabProjectIssueNote
{
  <#
      .Synopsis
      Creates a new note to a single project issue.
      .DESCRIPTION
      Creates a new note to a single project issue.
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

    #The content of a note
    [Parameter(HelpMessage = 'The content of a note',
    Mandatory = $true)]
    [string]$body,

    #the time the note was created
    [Parameter(HelpMessage = 'time of creation',
    Mandatory = $false)]
    [Alias('created_at')]
    [DateTime]$CreatedAt,

    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [psobject]$GitlabConnect = (Get-GitlabConnect),

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
