function Remove-GitLabProjectRepositoryFile
{
  <#
      .Synopsis
      
      .DESCRIPTION
      
      .Example
  #>
  [CmdletBinding(defaultParameterSetName='')]
  [Alias()]
  [OutputType()]
  Param
  (
    # The ID of a project
    [Parameter(HelpMessage = 'ProjectID',
    Mandatory = $true)]
    [Alias('ProjectID')]
    [string]$ID,

    #The name of branch
    [Parameter(HelpMessage = 'Commit SHA or branch name',
    Mandatory = $true)]
    [Alias('branch_name')]
    [string]$BranchName,

    #The path of the file inside the projects repository.
    [Parameter(Helpmessage = 'The path of the file',
    Mandatory = $true)]
    [alias('file_path')]
    [String]$FilePath,

    #Commit message
    [Parameter(HelpMessage=' Commit message',
    Mandatory = $true)]
    [alias('commit_message')]
    [string]$CommitMessage,

    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [psobject]$GitlabConnect = (Get-GitlabConnect)
  )

  $httpmethod = 'delete'
  $apiurl = "/projects/$ID/repository/files"
  $parameters = @{
    'file_path' = $FilePath
    'branch_name' = $BranchName
    'commit_message' = $CommitMessage
  }

  $GitlabConnect.callapi($apiurl,$httpmethod,$Parameters)
}