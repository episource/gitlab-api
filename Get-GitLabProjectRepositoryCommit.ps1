function Get-GitLabProjectRepositoryCommit
{
  <#
      .Synopsis
      Get a list of repository commits in a project.
      .DESCRIPTION
      Get a list of repository commits in a project.
      .Example
  #>
  [CmdletBinding(defaultParameterSetName = 'AllCommits')]
  [Alias()]
  [OutputType()]
  Param
  (
    [Parameter(HelpMessage = 'The ID of a project',
    Mandatory = $true)]
    [int]$id,

    #The name of a repository branch or tag or if not given the default branch
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

    #The commit hash or name of a repository branch or tag
    [Parameter(ParameterSetName = 'SingleCommit',
        HelpMessage = 'Commit Reference(hash|branchname|tagname)',
    Mandatory = $true)]
    [String]$sha,

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
