function New-GitLabProjectMergeRequestNote
{
  <#
      .Synopsis
      Creates a new note to a single project merge request.
      .DESCRIPTION
      Creates a new note to a single project merge request.
      .Example
  #>
  [CmdletBinding()]
  [Alias('New-GitLabProjectMRNote')]
  [OutputType()]
  Param
  (
    #The ID of a project
    [Parameter(
        HelpMessage = 'ProjectID',
    Mandatory = $true)]
    [Alias('ProjectID')]
    [string]$ID,
    
    #The ID of a projects MergeRequest
    [Parameter(HelpMessage = 'MergeRequestID',
    Mandatory = $true)]
    [Alias('merge_request_id','MRID')]
    [string]$MergeRequestID,

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

    [Parameter(HelpMessage = 'Passthru the created object',
    Mandatory = $false)]
    [switch]$PassThru

  )

  $httpmethod = 'post'
  $apiurl = "projects/$ID/merge_requests/$MergeRequestID/notes"
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
