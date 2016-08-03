function Invoke-GitLabProjectFork
{
  <#
      .Synopsis
      Archives the specified GitlabProject
      .DESCRIPTION
      Archives the specified GitlabProject. use invoke-gitlabprojectunarchive to make it available again
  #>
  [CmdletBinding(ConfirmImpact='High')]
  [Alias()]
  [OutputType()]
  Param
  (
    # Param1 help description
    [Parameter(ParameterSetName = 'The ID of a project',
        HelpMessage = 'ProjectID',
    Mandatory = $true)]
    [Alias('ProjectID')]
    [int]$id,

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