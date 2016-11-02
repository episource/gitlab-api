function Unregister-GitLabProjectLabelSubscription
{
  <#
      .SYNOPSIS
      Unsubscribes the authenticated user from a label.
      .DESCRIPTION
      the UnRegister-GitLabProjectLabelSubscription function unsubscribes the authenticated user from a label.

      Use -PassThru to return the updated label.
      .EXAMPLE
      unregister-GitLabProjectLabelSubscription -ProjectID 20 -Name 'Type:Bug'
      ---------------------------------------------------------------
      Removes the subscription to label 'Type:Bug' for the authenticated user.
  #>
  [CmdletBinding()]
  [Alias()]
  [OutputType()]
  Param
  (
    # ID of the project
    [Parameter(HelpMessage = 'ProjectID',
    Mandatory = $true)]
    [Alias('ID')]
    [int]$ProjectID,

    # The name of the label
    [Parameter(HelpMessage = 'Label Name',
    Mandatory = $true)]
    [Alias()]
    [string]$name,

    # Specify Existing GitlabConnector
    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [psobject]$GitlabConnect = (Get-GitlabConnect),

    # PassThru the modified label.
    [Parameter(HelpMessage = 'Passthru the modified label',
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
