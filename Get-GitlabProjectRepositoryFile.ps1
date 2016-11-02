function Get-GitLabProjectRepositoryFile
{
  <#
      .SYNOPSIS
      Get a fileobject for specified file, reference and project 
      .DESCRIPTION
      The Get-GitLabProjectRepositoryFile retrieves a file from the repository.
      It returns a object containing all data and metadata of the file.
      content of the file is base64 encoded by default.
      .EXAMPLE
      Get-GitLabProjectRepositoryFile -ProjectID 20 -SHA 5a411e1 -path README.md
      ---------------------------------------------------------------
      gets from project 20 commit 5a411e1 the file README.md  
      .EXAMPLE
      Get-GitLabProjectRepositoryFile -ProjectID 20 -SHA master -path README.md
      ---------------------------------------------------------------
      gets from project 20 branch master the file README.md
      .EXAMPLE
      $FileObj = Get-GitLabProjectRepositoryFile -ProjectID 20 -SHA 5a411e1 -path README.md
      PS C:\>[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($FileObj.content))

      ---------------------------------------------------------------
      gets from project 20 commit 5a411e1 the file README.md and saves it to $FileObj.
      converts the base64 encoded content to UTF8 string.
  #>
  [CmdletBinding(defaultParameterSetName='')]
  [Alias()]
  [OutputType()]
  Param
  (
    # The ID of the project
    [Parameter(HelpMessage = 'ProjectID',
    Mandatory = $true)]
    [Alias('ID')]
    [int]$ProjectID,

    # The commit SHA, Tag or Branch name
    [Parameter(HelpMessage = 'Commit SHA or branch name',
    Mandatory = $true)]
    [Alias('RefName','ref')]
    [string]$ReferenceName,

    # The path of the file inside the projects repository.
    [Parameter(ParameterSetName = 'ByCommit',
        Helpmessage = 'The path of the file',
    Mandatory = $true)]
    [alias('file_path')]
    [String]$FilePath,

    # Existing GitlabConnector Object, can be retrieved with Get-GitlabConnect
    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [psobject]$GitlabConnect = (Get-GitlabConnect)
  )

  $httpmethod = 'get'
  $apiurl = "/projects/$ID/repository/files"
  $Parameters = @{
    'file_path'=$FilePath
    'ref' =$ReferenceName
  }

  $GitlabConnect.callapi($apiurl,$httpmethod,$Parameters)
}