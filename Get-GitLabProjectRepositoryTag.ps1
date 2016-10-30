function Get-GitLabProjectRepositoryTag
{
  <#
      .SYNOPSIS
      Get tags on repository.
      .DESCRIPTION
      Get a list of repository tags from a project
      only specified tag is returned when -TagName is passed.
      .EXAMPLE
      Get-GitLabProjectRepositoryTag -ProjectID 20 
      ---------------------------------------------------------------
      gets all tags for the repository in project 20
      .EXAMPLE
      Get-GitLabProjectRepositoryTag -ProjectID 20 -TagName 'v1.0.0' 
      ---------------------------------------------------------------
      gets tag 'v1.0.0' for the repository in project 20
  #>
  [CmdletBinding(defaultParameterSetName = 'AllTags')]
  [Alias()]
  [OutputType()]
  Param
  (
    #The ID of the project
    [Parameter(
        HelpMessage = 'ProjectID',
    Mandatory = $true)]
    [Alias('ProjectID')]
    [string]$ID,

    #The name of the tag
    [Parameter(ParameterSetName = 'SingleTag',
        HelpMessage = 'Tag Name',
    Mandatory = $true)]
    [Alias('Tag','tag_name')]
    [string]$TagName,

    # Existing GitlabConnector Object, can be retrieved with Get-GitlabConnect
    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [psobject]$GitlabConnect = (Get-GitlabConnect)
  )

  $httpmethod = 'get'
  $apiurl = "projects/$ID/repository/tags"
  $parameters = @{}

  if($PSCmdlet.ParameterSetName -like 'SingleTag')
  {
    $apiurl += "/$TagName"
  }

  $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)
}
