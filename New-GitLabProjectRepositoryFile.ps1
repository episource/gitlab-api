function New-GitLabProjectRepositoryFile
{
  <#
      .SYNOPSIS
      Create a new file in the repository
      .DESCRIPTION
      The New-gitLabProjectRepositoryFile function creates a new file in the repository.
      Content is expected in text but can be pased base 64 encoded using -Encoding base64.
      .EXAMPLE
      New-GitLabProjectRepositoryFile -ProjectID 20 -BranchName '1-FeatureName' -FilePath FeatureFile.ps1 -Content '#filecontent' -CommitMessage 'add FeatureFileMockup'
      ---------------------------------------------------------------
      Adds the FeatureFile.ps1 file to the repository in branch 1-Feature.
  #>
  [CmdletBinding(defaultParameterSetName = '')]
  [Alias()]
  [OutputType()]
  Param
  (
    # The ID of the project
    [Parameter(HelpMessage = 'ProjectID',
    Mandatory = $true)]
    [Alias('ID')]
    [int]$ProjectID,

    # The name of thebranch
    [Parameter(HelpMessage = 'Commit SHA or branch name',
    Mandatory = $true)]
    [Alias('branch_name')]
    [string]$BranchName,

    # The path of the file inside the projects repository.
    [Parameter(Helpmessage = 'The path of the file',
    Mandatory = $true)]
    [alias('file_path')]
    [String]$FilePath,

    # Encoding of supplied content. 'text' or 'base64'. Text is default.
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

  
  $httpmethod = 'post'
  $apiurl = "/projects/$ProjectID/repository/files"
  $parameters = @{
    'file_path'    = $FilePath
    'branch_name'  = $BranchName
    'commit_message' = $CommitMessage
  }
  $body = @{
    'content' = $content
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

  $GitlabConnect.callapi($apiurl,$httpmethod,$parameters,$body)
}
