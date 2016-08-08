function New-GitLabProjectRepositoryCommitComment
{
  <#
      .Synopsis
      Adds a comment to a commit.
      .DESCRIPTION
      
      .Example
  #>
  [CmdletBinding(defaultParameterSetName = 'ToFullCommit')]
  [Alias()]
  [OutputType()]
  Param
  (
    #The ID of a project
    [Parameter(HelpMessage = 'The ID of a project',
    Mandatory = $true)]
    [int]$ID,

    #The commit hash or name of a repository branch or tag
    [Parameter(HelpMessage = 'Commit Reference(hash|branchname|tagname)',
    Mandatory = $true)]
    [String]$sha,

    #The text of the comment
    [Parameter(HelpMessage = 'The text of the comment',
    Mandatory = $true)]
    [string]$Note,

    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [psobject]$GitlabConnect = (Get-GitlabConnect),

    [Parameter(HelpMessage = 'Passthru the created object',
    Mandatory = $false)]
    [switch]$PassThru
  )

  $httpmethod = 'post'
  $apiurl = "projects/$ID/repository/commits/$sha/comments"
  $parameters = @{}
  $body = @{
    note = $Note
  }

  $NewCommitComment = $GitlabConnect.callapi($apiurl,$httpmethod,$parameters,$body)

  if($PassThru)
  {
    return $NewCommitComment
  }
}
