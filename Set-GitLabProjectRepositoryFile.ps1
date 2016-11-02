function Set-GitLabProjectRepositoryFile
{
  <#
      .SYNOPSIS
      Update file in repository
      .DESCRIPTION
      The Set-GitLabProjectRepositoryFile function edits an existing file in the repository.
      Content is expected in text but can be pased base 64 encoded using -Encoding base64.

      If the commit fails for any reason we return a 400 error with a non-specific error message. Possible causes for a failed commit include:
      - the file_path contained /../ (attempted directory traversal);
      - the new file contents were identical to the current file contents, i.e. the user tried to make an empty commit;
      - the branch was updated by a Git push while the file edit was in progress.
      Currently gitlab-shell has a boolean return code, preventing GitLab from specifying the error.
      .EXAMPLE
      Set-GitLabProjectRepositoryFile -ProjectID 20 -BranchName Develop -FilePath README.md -Content 'New Readme Content' -CommitMessage 'Update readme'
      ---------------------------------------------------------------
      updates the content of README.md to 'New Readme Content' with the message 'Update readme'
  #>
  [CmdletBinding()]
  [Alias()]
  [OutputType()]
  Param
  (
    # The ID of the project
    [Parameter(HelpMessage = 'ProjectID',
    Mandatory = $true)]
    [Alias('ProjectID')]
    [string]$ID,

    # The name of the branch
    [Parameter(HelpMessage = 'Commit SHA or branch name',
    Mandatory = $true)]
    [Alias('branch_name')]
    [string]$BranchName,

    # The path of the file inside the projects repository.
    [Parameter(Helpmessage = 'The path of the file',
    Mandatory = $true)]
    [alias('file_path')]
    [String]$FilePath,

    # Encoding of seplied content. 'text' or 'base64'. Text is default.
    [Parameter(HelpMessage = 'Encoding of content (text|base64)')]
    [validateset('text','base64')]
    [string]$Encoding = 'text',

    # File content
    [Parameter(Helpmessage = 'File content',
    Mandatory = $true)]
    [string]$Content,

    # Commit message
    [Parameter(HelpMessage = ' Commit message',
    Mandatory = $true)]
    [alias('commit_message')]
    [string]$CommitMessage,

    # Specify Existing GitlabConnector
    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [psobject]$GitlabConnect = (Get-GitlabConnect)
  )

  
  $httpmethod = 'put'
  $apiurl = "/projects/$ID/repository/files"
  $parameters = @{
    'file_path'    = $FilePath
    'branch_name'  = $BranchName
    'commit_message' = $CommitMessage
    'content'      = $content
  }

  switch($encoding){
    'text' 
    {
      $parameters.encoding = 'text' 
      break
    }
    'base64' 
    {
      $parameters.encoding = 'base64' 
      break
    }
  }

  $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)
}
