function Get-GitLabProjectRepositoryFileRaw
{
  <#
      .SYNOPSIS
      Get a file and save the raw content to disk.
      .DESCRIPTION
      The Get-GitLabProjectRepositoryFileRaw retrieves the raw file contents for a file by blob SHA or by commit SHA/branche name and path.
      It saves it to the path specified. Container must exists beforehand.
      .EXAMPLE
      Get-GitLabProjectRepositoryFileRaw -ProjectID 20 -SHA 5a411e1 -path README.md -OutFile README.md
      ---------------------------------------------------------------
      gets from project 20 commit 5a411e1 the file README.md and saves it locally to README.md
      .EXAMPLE
      Get-GitLabProjectRepositoryFileRaw -ProjectID 20 -SHA master -path README.md -Outfile C:\README.md
      ---------------------------------------------------------------
      gets from project 20 branch master the file README.md and saves it locally to README.md

  #>
  [CmdletBinding(DefaultParameterSetName = 'ByCommit')]
  [Alias()]
  [OutputType()]
  Param
  (
    # The ID of a project
    [Parameter(HelpMessage = 'ProjectID',
    Mandatory = $true)]
    [Alias('ID')]
    [int]$ProjectID,

    #the commit SHA or Branch name
    [Parameter(ParameterSetName = 'ByCommit',
        HelpMessage = 'Commit SHA or branch name',
    Mandatory = $true)]
    [Alias('RefName')]
    [string]$ReferenceName,

    #The path of the file inside the projects repository.
    [Parameter( ParameterSetName = 'ByCommit',
        Helpmessage = 'The path of the file',
    Mandatory = $true)]
    [String]$FilePath,

    #The blob SHA for a blob from the projects repository
    [Parameter( ParameterSetName = 'ByBlobSHA',
        Helpmessage = 'Blob SHA',
    Mandatory = $true)]
    [Alias('sha')]
    [String]$BlobSha,
    
    #path for the new created file
    [Parameter(HelpMessage = 'filepath for file',
    Mandatory = $true)]
    [String]$OutFile,

    # Existing GitlabConnector Object, can be retrieved with Get-GitlabConnect
    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [psobject]$GitlabConnect = (Get-GitlabConnect)
  )

  $httpmethod = 'get'
  $apiurl = "/projects/$ID/repository/"
  $Parameters = @{}

    
  if($PSCmdlet.ParameterSetName -eq 'ByCommit')
  {
    $apiurl += "blobs/$ReferenceName"
    $Parameters.filepath = $FilePath
  }
    
  if($PSCmdlet.ParameterSetName -eq 'ByBlobSHA')
  {
    $apiurl += "raw_blobs/$BlobSha"
  }

  $GitlabConnect.callapi($apiurl,$httpmethod,$Parameters,$OutFile)
}
