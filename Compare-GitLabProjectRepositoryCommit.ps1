function Compare-GitLabProjectRepositoryCommit
{
  <#
      .SYNOPSIS
      Compares 2 commits
      .DESCRIPTION
      Compares 2 commits by branch, tag or commits. 
      one is the reference and the other is the target. 
      returns the difference in commits and in files.
      .EXAMPLE
      Compare-GitLabProjectRepositoryCommit -ProjectID 20 -Reference 'master' -target 2484458d2f97c5e0263406065f83be0fa8b75d92
      ---------------------------------------------------------------
      compares the branch master with commit 2484458d2f97c5e0263406065f83be0fa8b75d92
  #>
  [CmdletBinding()]
  [Alias()]
  [OutputType()]
  Param
  (
    # The ID of a project
    [Parameter(HelpMessage = 'ProjectID',
    Mandatory = $true)]
    [Alias('ID')]
    [int]$ProjectID,

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

    #Existing GitlabConnector Object, can be retrieved with Get-GitlabConnect
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
