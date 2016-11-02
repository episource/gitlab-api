function New-GitLabProjectRepositoryCommitComment
{
  <#
      .SYNOPSIS
      Add a comment to a commit.
      .DESCRIPTION
      the New-GitLabProjectRepositoryCommitComment function adds a comment to a repositories commit.

      Return the comment with -PassThru 
      .EXAMPLE
      New-GitLabProjectRepositoryCommitComment -ProjectID 20 -SHA 5a411e1 -Note 'has braking changes'
      ---------------------------------------------------------------
      adds the comment 'has braking changes' to commit 5a411e1 in project 20.
      .EXAMPLE
      New-GitLabProjectRepositoryCommitComment -ProjectID 20 -SHA 5a411e1 -Note 'has braking changes' -PassThru
      ---------------------------------------------------------------
      Adds the comment 'has braking changes' to commit 5a411e1 in project 20.
      Returns the created comment.
  #>
  [CmdletBinding(defaultParameterSetName = 'ToFullCommit')]
  [Alias()]
  [OutputType()]
  Param
  (
    #The ID of a project
    [Parameter(HelpMessage = 'The ID of a project',
    Mandatory = $true)]
    [Alias('ProjectID')]
    [int]$ID,

    #The commit hash or name of a repository branch or tag
    [Parameter(HelpMessage = 'Commit Reference(hash|branchname|tagname)',
    Mandatory = $true)]
    [String]$SHA,

    #The text of the comment
    [Parameter(HelpMessage = 'The text of the comment',
    Mandatory = $true)]
    [string]$Note,

    # Specify Existing GitlabConnector
    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [psobject]$GitlabConnect = (Get-GitlabConnect),
    
    # Return the created comment 
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
