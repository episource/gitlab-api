function Get-GitLabProjectLabel
{
  <#
      .SYNOPSIS
      Get all labels for a given project.
      .DESCRIPTION
      Gets all labels for a given project.
      .EXAMPLE
      Get-GitLabProjectlabel -ProjectID 20
      ---------------------------------------------------------------
      get all labels for project 20
  #>
  [CmdletBinding()]
  [Alias()]
  [OutputType()]
  Param
  (
    #The ID of a project
    [Parameter(HelpMessage = 'ProjectID',
        Mandatory = $true)]
    [Alias('ProjectID')]
    [int]$id,

    # Existing GitlabConnector Object, can be retrieved with Get-GitlabConnect
    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
        DontShow = $true)]
    [psobject]$GitlabConnect = (Get-GitlabConnect)
  )
  
  $httpmethod = 'get'
  $apiurl = "projects/$id/labels"
  $parameters = @{}

  $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)
}
