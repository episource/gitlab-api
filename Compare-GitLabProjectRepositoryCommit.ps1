function Compare-GitLabProjectRepositoryCommit
{
  <#
      .Synopsis
      Compares branches, tags or commits
      .DESCRIPTION
      Compares branches, tags or commits
      .Example
  #>
  [CmdletBinding()]
  [Alias()]
  [OutputType()]
  Param
  (
    # The ID of a project
    [Parameter(HelpMessage = 'ProjectID',
    Mandatory = $true)]
    [Alias('ProjectID')]
    [string]$ID,

    #the commit SHA or branch name to compare from
    [Parameter(Helpmessage = 'commit SHA or branch name to compare from',
    Mandatory = $true)]
    [Alias('from')]
    [String]$Reference,

    #the commit SHA or branch name to compare to
    [Parameter(Helpmessage = 'commit SHA or branch name to compare to',
    Mandatory = $true)]
    [Alias('to')]
    [String]$Target,

    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [psobject]$GitlabConnect = (Get-GitlabConnect)
    
  )
  $httpmethod = 'get'
  $apiurl = "projects/$ID/repository/compare"
  $Parameters = @{
    from = $Reference
    to   = $Target
  }

  $GitlabConnect.callapi($apiurl,$httpmethod,$Parameters)
}
