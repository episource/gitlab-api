function Get-GitLabProjectRepositoryTree
{
  <#
      .Synopsis
      Get a list of repository files and directories in a project.
      .DESCRIPTION
      Get a list of repository files and directories in a project.
  #>
  [CmdletBinding()]
  [Alias('Get-GitLabRepository')]
  [OutputType()]
  Param
  (
    # The ID of a project
    [Parameter(HelpMessage = 'ProjectID',
    Mandatory = $true)]
    [Alias('ProjectID')]
    [string]$ID,

    #The path inside repository. Used to get contend of subdirectories
    [Parameter(Helpmessage = 'path inside repository',
    Mandatory = $false)]
    [String]$Path,

    #The name of a repository branch or tag or if not given the default branch
    [Parameter(Helpmessage = 'Name of a repository branch or tag',
    Mandatory = $false)]
    [Alias('ref_name','RefName')]
    [String]$ReferenceName,

    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [psobject]$GitlabConnect = (Get-GitlabConnect)
  )

  $httpmethod = 'get'
  $apiurl = "projects/$ID/repository/tree"
  $Parameters = @{}

  if($Path)
  {
    $Parameters.path = $Path
  }

  if($ReferenceName)
  {
    $Parameters.'ref_name' = $ReferenceName
  }

  $GitlabConnect.callapi($apiurl,$httpmethod,$Parameters)
}
