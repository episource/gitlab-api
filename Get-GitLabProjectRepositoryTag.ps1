function Get-GitLabProjectRepositoryTag
{
  <#
      .Synopsis
      Get a list of repository tags from a project
      .DESCRIPTION
      Get a list of repository tags from a project
      .Example
  #>
  [CmdletBinding(defaultParameterSetName = 'AllTags')]
  [Alias()]
  [OutputType()]
  Param
  (
    #The ID of a project
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
