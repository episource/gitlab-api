function Get-GitLabProjectRepositoryFile
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

    #the commit SHA, Tag or Branch name
    [Parameter(HelpMessage = 'Commit SHA or branch name',
    Mandatory = $true)]
    [Alias('RefName','ref')]
    [string]$ReferenceName,

    #The path of the file inside the projects repository.
    [Parameter(ParameterSetName = 'ByCommit',
        Helpmessage = 'The path of the file',
    Mandatory = $true)]
    [alias('file_path')]
    [String]$FilePath,

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