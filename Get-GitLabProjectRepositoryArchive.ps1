function Get-GitLabProjectRepositoryArchive
{
  <#
      .SYNOPSIS
      Get an archive of the repository of the specified project.
      .DESCRIPTION
      Get an archive of the repository of the specified project. Can be retrieved as [zip], [tar], [tar.gz] & [tar.bz2]
      .EXAMPLE
      Get-GitLabProjectRepositoryArchive -ProjectID 20 -SHA 5a411e1 -OutFile 5a411e1.zip 
      ---------------------------------------------------------------
      Saves the commit 5a411e1 to the file 5a411e1.zip
      .EXAMPLE
      Get-GitLabProjectRepositoryArchive -ProjectID 20 -SHA master -OutFile msater.zip 
      ---------------------------------------------------------------
      Saves the commit master to the file master.zip
      
  #>
  [CmdletBinding()]
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
    [Parameter(HelpMessage = 'Commit SHA or branch name',
    Mandatory=$false)]
    [Alias('RefName','ReferenceName')]
    [string]$SHA,

    #type of archive to download defaults to [zip]
    [Parameter(HelpMessage='type of archive to download (zip|tar|tar.gz|tar.bz2)',
    Mandatory = $false)]
    [ValidateSet('zip','tar','tar.gz','tar.bz2')]
    [string]$ArchiveType='zip',

    #path for the new created file
    [Parameter(HelpMessage = 'filepath for file',
    Mandatory=$true)]
    [String]$OutFile,

    # Existing GitlabConnector Object, can be retrieved with Get-GitlabConnect
    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [psobject]$GitlabConnect = (Get-GitlabConnect)
    )

    #warn if outfile has different extention then archiveType

    $regexExtention = $ArchiveType -replace '\.','\.'
    $regexfilter = "^.*\.$regexExtention$"
    $extentionmatches = $OutFile -match $regexfilter
    if(-not $extentionmatches){
      $warningmessage = "OutFile [$OutFile] does not match ArchiveType [$ArchiveType]. Archive downloaded as specified but content does not match extention."
      Write-Warning -Message $warningmessage 
    }

    $httpmethod = 'get'
    $apiurl = "/projects/$ID/repository/archive.$ArchiveType"
    $Parameters = @{}

    if($sha){
      $Parameters.sha = $sha
    }

    $GitlabConnect.callapi($apiurl,$httpmethod,$parameters,$OutFile) 
}