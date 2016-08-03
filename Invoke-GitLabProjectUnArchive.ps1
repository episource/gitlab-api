function Invoke-GitLabProjectUnArchive
{
  <#
      .Synopsis
     Restores the specified GitlabProject from archive
      .DESCRIPTION
     Restores the specified GitlabProject from archive. use invoke-gitlabprojectarchive to archive a project.
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
  $apiurl = "projects/$id/unarchive"
  $parameters = @{}

  $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)
}