function Set-GitLabProjectRepositoryFile
{
  <#
      .Synopsis
      Update existing file in repository
      .DESCRIPTION
      Update existing file in repository

      If the commit fails for any reason we return a 400 error with a non-specific error message. Possible causes for a failed commit include:
      - the file_path contained /../ (attempted directory traversal);
      - the new file contents were identical to the current file contents, i.e. the user tried to make an empty commit;
      - the branch was updated by a Git push while the file edit was in progress.
      Currently gitlab-shell has a boolean return code, preventing GitLab from specifying th
      .Example
  #>
  [CmdletBinding(defaultParameterSetName = '')]
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

    #encoding of seplied content. 'text' or 'base64'. Text is default.
    [Parameter(HelpMessage = 'Encoding of content (text|base64)')]
    [validateset('text','base64')]
    [string]$encoding = 'text',

    #File content
    [Parameter(Helpmessage = 'File content',
    Mandatory = $true)]
    [string]$content,

    #Commit message
    [Parameter(HelpMessage = ' Commit message',
    Mandatory = $true)]
    [alias('commit_message')]
    [string]$CommitMessage,

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
