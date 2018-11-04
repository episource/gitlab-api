function Get-GitLabProjectRepositoryCommitDiff
{
  <#
      .SYNOPSIS
      Get Diff of a commit of a project
      .DESCRIPTION
      The Get-GitLabProjectRepositoryCommitDiff function retrieves the diffs for a specified commit
      .EXAMPLE
      Get-GitLabProjectRepositoryCommitDiff-ID 20 -SHA 5a411e1
      ---------------------------------------------------------------
      gets the diff on commit 5a411e1 for project 20.
      .EXAMPLE
      Get-GitLabProjectRepositoryCommitDiff-ID 20 -SHA master
      ---------------------------------------------------------------
      gets the diff on branch master for project 20.
  #>
  [CmdletBinding()]
  [Alias()]
  [OutputType()]
  Param
  (
    #The ID of the project
    [Parameter(HelpMessage = 'The ID of a project',
    Mandatory = $true)]
    [Alias('ID')]
    [String]$ProjectID,

    #The commit hash or name of a repository branch or tag
    [Parameter(HelpMessage = 'Commit Reference(hash|branchname|tagname)',
    Mandatory = $true)]
    [String]$sha,

    # Existing GitlabConnector Object, can be retrieved with Get-GitlabConnect
    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [psobject]$GitlabConnect = (Get-GitlabConnect)
  )

  $httpmethod = 'get'
  $apiurl = "projects/$([System.Web.HttpUtility]::UrlEncode($projectId))/repository/commits/$sha/diff"
  $parameters = @{}

  $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)
}