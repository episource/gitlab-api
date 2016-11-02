function Get-GitLabProjectRepositoryCommit
{
  <#
      .SYNOPSIS
      Get project commit history.
      .DESCRIPTION
      Get project commit history. returns full history for deafult branch by default.
      using -ReferenceName a different branch, tag or commit can be specified.
      to retrieve commits for a speceific timeframe use -StartTime and -EndTime.

      to retrieve a single commit specify the commit with -SHA
      .EXAMPLE
      Get-GitLabProjectRepositoryCommit -ProjectID 20
      ---------------------------------------------------------------
      retrieves all commits composing the default branch.
      .EXAMPLE
      Get-GitLabProjectRepositoryCommit -StartTime (Get-Date).addDays(-2) -Endtime (Get-Date)
      ---------------------------------------------------------------
      retrieves all commits composing the default branch between now and 2 days ago.
  #>
  [CmdletBinding(defaultParameterSetName = 'AllCommits')]
  [Alias()]
  [OutputType()]
  Param
  (
    # The ID of a project
    [Parameter(HelpMessage = 'The ID of a project',
    Mandatory = $true)]
    [Alias('ProjectID')]
    [int]$ID,

    # The name of a repository branch or tag or if not given the default branch
    [Parameter(ParameterSetName = 'AllCommits',
        HelpMessage = 'name of a repository branch or tag',
    Mandatory = $false)]
    [Alias('ref_name')]
    [String]$ReferenceName,

    #	Only commits after or in this date will be returned
    [Parameter(ParameterSetName = 'AllCommits',
        HelpMessage = 'return commits after:',
    Mandatory = $false)]
    [Alias('since')]
    [datetime]$StartTime,
        
    #	Only commits before or in this date will be returned
    [Parameter(ParameterSetName = 'AllCommits',
        HelpMessage = 'return commits before:',
    Mandatory = $false)]
    [Alias('until')]
    [datetime]$EndTime,

    # The commit hash or name of a repository branch or tag
    [Parameter(ParameterSetName = 'SingleCommit',
        HelpMessage = 'Commit Reference(hash|branchname|tagname)',
    Mandatory = $true)]
    [String]$sha,
    
    # Existing GitlabConnector Object, can be retrieved with Get-GitlabConnect
    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [psobject]$GitlabConnect = (Get-GitlabConnect)
  )

  $httpmethod = 'get'
  $apiurl = "projects/$id/repository/commits"
  $parameters = @{}

  if($PSCmdlet.ParameterSetName -eq 'AllCommits')
  {
    if($ReferenceName)
    {
      $parameters.'ref_name' = $ReferenceName
    }

    if($StartTime)
    {
      $parameters.since = $StartTime.ToUniversalTime().tostring('s') +'Z'
    }

    if($EndTime)
    {
      $parameters.until = $EndTime.ToUniversalTime().tostring('s') +'Z'
    }
  }
  if($PSCmdlet.ParameterSetName -eq 'SingleCommit')
  {
    $apiurl += "/$sha"
  }

  $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)
}
