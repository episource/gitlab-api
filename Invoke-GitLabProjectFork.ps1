function Invoke-GitLabProjectFork
{
  <#
      .SYNOPSIS
      Forks a gitlab project.
      .DESCRIPTION
      Forks a gitlab project to the namespace of the authenticated user.
      .EXAMPLE
      Invoke-GitLabProjectFork -ProjectID 1
      --------------------------------------------------------------
      Forks project 1
  #>
  [CmdletBinding(ConfirmImpact='High')]
  [Alias()]
  [OutputType()]
  Param
  (
    # The ID of the project
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

  $httpmethod = 'post'
  $apiurl = "projects/fork/$id"
  $parameters = @{}

  $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)
}