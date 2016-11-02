function New-GitLabProjectMergeRequestNote
{
  <#
      .SYNOPSIS
      Adds a singel note to a Merge Request
      .DESCRIPTION
      The New-GitLabProjectIssueNote function adds a single note to a Merge Request.

      By specifying -PassThru the created MR Note is returned.
      .EXAMPLE
      New-GitLabProjectMergeRequestNote -ProjectID 20 -MergeRequestID 1 -Body 'Elaborate on readme.md'
      ---------------------------------------------------------------
      Creates a new note 'Elaborate on readme.md' on merge request 1 in project 20.
  #>
  [CmdletBinding()]
  [Alias('New-GitLabProjectMRNote')]
  [OutputType()]
  Param
  (
    #The ID of the project
    [Parameter(
        HelpMessage = 'ProjectID',
    Mandatory = $true)]
    [Alias('ID')]
    [int]$ProjectID,
    
    #The ID of a projects MergeRequest
    [Parameter(HelpMessage = 'MergeRequestID',
    Mandatory = $true)]
    [Alias('merge_request_id','MRID')]
    [string]$MergeRequestID,

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

    # Return the created Merge Request Note 
    [Parameter(HelpMessage = 'Passthru the created object',
    Mandatory = $false)]
    [switch]$PassThru

  )

  $httpmethod = 'post'
  $apiurl = "projects/$ProjectID/merge_requests/$MergeRequestID/notes"
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
