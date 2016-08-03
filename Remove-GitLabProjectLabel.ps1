function Remove-GitLabProjectLabel
{
  <#
      .Synopsis
      remove a label
      .DESCRIPTION
      Deletes a label with a given name.
      .Example
  #>
  [CmdletBinding()]
  [Alias()]
  [OutputType()]
  Param
  (
    # Param1 help description
    [Parameter(HelpMessage = 'ProjectID',
    Mandatory = $true)]
    [Alias('ProjectID')]
    [int]$id,

    [Parameter(HelpMessage = 'Label Name',
    Mandatory = $true)]
    [Alias()]
    [string]$name,

    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [psobject]$GitlabConnect = (Get-GitlabConnect)
  )
  
  $httpmethod = 'delete'
  $apiurl = "projects/$id/labels"
  $parameters = @{
    name = $name
  }

  $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)
}