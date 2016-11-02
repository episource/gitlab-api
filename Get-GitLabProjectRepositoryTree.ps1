function Get-GitLabProjectRepositoryTree
{
  <#
      .SYNOPSIS
      Get a list of Repository files and directories in a project.
      .DESCRIPTION
      Get a list of Repository files and directories in a project. 
      By deafult only shows files and folders in the root of the project for the default branch.
      -Path can be passed to dig down into the directory structure.
      to specify a different branch of commit -ReferenceName can be used.
      .EXAMPLE
      Get-GitLabProjectRepositoryTree -ProjectID 20
      ---------------------------------------------------------------
      retrieves all files for project 20.
      Returns all the files and folders for the default branch in the repository root.
      .EXAMPLE
      Get-GitLabProjectRepositoryTree -ProjectID 20 -Path bin/
      ---------------------------------------------------------------
      retrieves all files for project 20 in folder bin/.
      Returns all the files and folders for the default branch in bin/.
      .EXAMPLE
      Get-GitLabProjectRepositoryTree -ProjectID 20 -ReferenceName staging
      ---------------------------------------------------------------
      retrieves all files for project 20 in branch staging.
      Returns all the files and folders for the branch staging.

  #>
  [CmdletBinding()]
  [Alias('Get-GitLabRepository')]
  [OutputType()]
  Param
  (
    # The ID of the project
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
