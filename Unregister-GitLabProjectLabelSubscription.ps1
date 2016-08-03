function Unregister-GitLabProjectLabelSubscription
{
  <#
      .Synopsis
      Unsubscribes the authenticated user to a label
      .DESCRIPTION
      Unsubscribes the authenticated user from a label to not receive notifications from it.
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
    [psobject]$GitlabConnect = (Get-GitlabConnect),

    [Parameter(HelpMessage = 'Passthru the label',
    Mandatory = $false)]
    [switch]$PassThru
  )

  $httpmethod = 'delete'
  $apiurl = "projects/$id/labels/$name/subscription"

  $newlabel = $GitlabConnect.callapi($apiurl,$httpmethod)

  if($PassThru)
  {
    return $newlabel
  }
}
