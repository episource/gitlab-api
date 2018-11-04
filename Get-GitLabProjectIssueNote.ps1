function Get-GitLabProjectIssueNote
{
  <#
      .SYNOPSIS
      Get Issue Note
      .DESCRIPTION
      Get note for specified issue. 
      Returnes all notes by default, Specify -NoteID to return single note.
      .EXAMPLE
      Get-GitLabProjectIssueNote -ProjectID 20 -IssueID 1
      ---------------------------------------------------------------
      get all notes for project 20 and issue 1
      .EXAMPLE
      Get-GitLabProjectIssueNote -ProjectID 20 -IssueID 1 -NoteID 3
      ---------------------------------------------------------------
      gets note 3 for project 20 and issue 1 
  #>
  [CmdletBinding(DefaultParameterSetName = 'AllNotes')]
  [Alias()]
  [OutputType()]
  Param
  (
    #The ID of a project
    [Parameter(HelpMessage = 'ProjectID',
        Mandatory = $true)]
    [Alias('ID')]
    [String]$ProjectID,

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

    # Existing GitlabConnector Object, can be retrieved with Get-GitlabConnect
    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
        DontShow = $true)]
    [psobject]$GitlabConnect = (Get-GitlabConnect)
  )


  $httpmethod = 'get'
  $apiurl = "projects/$([System.Web.HttpUtility]::UrlEncode($projectId))/issues/$IssueID/notes"
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
