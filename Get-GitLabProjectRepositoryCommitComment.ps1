function Get-GitLabProjectRepositoryCommitComment
{
  <#
      .SYNOPSIS
      Get comments on a commit of a project
      .DESCRIPTION
      The Get-GitLabProjectRepositoryCommitComment function gets all comments on a specified commit
      .EXAMPLE
      Get-GitLabProjectRepositoryCommitComment -ID 20 -SHA 5a411e1
      ---------------------------------------------------------------
      gets all comments for project 20 on commit 5a411e1.
  #>
  [CmdletBinding()]
  [Alias()]
  [OutputType()]
  Param
  (
    # The ID of The project
    [Parameter(HelpMessage = 'The ID of a project',
    Mandatory = $true)]
    [Alias('ID')]
    [int]$ProjectID,

    # The commit hash or name of a repository branch or tag
    [Parameter(HelpMessage = 'Commit Reference(hash|branchname|tagname)',
    Mandatory = $true)]
    [Alias('RefName','ReferenceName')]
    [string]$SHA,

    # Existing GitlabConnector Object, can be retrieved with Get-GitlabConnect
    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [psobject]$GitlabConnect = (Get-GitlabConnect)
  )

  $httpmethod = 'get'
  $apiurl = "projects/$ID/repository/commits/$sha/comments"
  $parameters = @{}

  $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)
}
