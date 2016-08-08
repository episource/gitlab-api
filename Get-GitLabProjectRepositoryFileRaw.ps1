function Get-GitLabProjectRepositoryFileRaw
{
  <#
      .Synopsis
      Get the raw file contents for a file.
      .DESCRIPTION
      Get the raw file contents for a file by blob SHA or by commit SHA/branche name and path.
  #>
  [CmdletBinding(DefaultParameterSetName = 'ByCommit')]
  [Alias()]
  [OutputType()]
  Param
  (
    # The ID of a project
    [Parameter(HelpMessage = 'ProjectID',
    Mandatory = $true)]
    [Alias('ProjectID')]
    [string]$ID,

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
