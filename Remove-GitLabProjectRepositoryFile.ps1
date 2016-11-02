function Remove-GitLabProjectRepositoryFile
{
  <#
      .SYNOPSIS
      Delete existing file in repository
      .DESCRIPTION
      The Remove-GitLabProjectRepositoryFile function removes the specified file from the branch.
      a commit message needs to be passed.
      .EXAMPLE
      Remove-GitLabProjectRepositoryFile -ProjectID 20 -BranchName master -FilePath 'Readme.md' -commit 'no readme needed'
      ---------------------------------------------------------------
      Removes readme.md from branch master with commit 'no readme needed'
  #>
  [CmdletBinding(
     SupportsShouldProcess=$true,
    ConfirmImpact="High")]
  [Alias()]
  [OutputType()]
  Param
  (
    # The ID of a project
    [Parameter(HelpMessage = 'ProjectID',
    Mandatory = $true)]
    [Alias('ID')]
    [int]$ProjectID,

    # The name of branch
    [Parameter(HelpMessage = 'Commit SHA or branch name',
    Mandatory = $true)]
    [Alias('branch_name')]
    [string]$BranchName,

    # The path of the file inside the projects repository.
    [Parameter(Helpmessage = 'The path of the file',
    Mandatory = $true)]
    [alias('file_path')]
    [String]$FilePath,

    # Commit message
    [Parameter(HelpMessage = 'Commit message',
    Mandatory = $true)]
    [alias('commit_message')]
    [string]$CommitMessage,

    # Specify Existing GitlabConnector
    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [psobject]$GitlabConnect = (Get-GitlabConnect)
  )

  $httpmethod = 'delete'
  $apiurl = "/projects/$ID/repository/files"
  $parameters = @{
    'file_path'    = $FilePath
    'branch_name'  = $BranchName
    'commit_message' = $CommitMessage
  }
  if($pscmdlet.ShouldProcess("$($BranchName):$FilePath","Remove")){
    $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)
  }
}
