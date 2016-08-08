function Get-GitLabProjectRepositoryCommitComment
{
  <#
      .Synopsis
      Get the comments of a commit in a project.
      .DESCRIPTION
      Get the comments of a commit in a project.
      .Example
  #>
  [CmdletBinding()]
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

    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [psobject]$GitlabConnect = (Get-GitlabConnect)
  )

  $httpmethod = 'get'
  $apiurl = "projects/$id/repository/commits/$sha/comments"
  $parameters = @{}

  $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)
}