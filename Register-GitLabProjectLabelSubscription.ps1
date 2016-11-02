function Register-GitLabProjectLabelSubscription
{
  <#
      .SYNOPSIS
      Subscribes the authenticated user to a label.
      .DESCRIPTION
      the Register-GitLabProjectLabelSubscription function subscribes the authenticated user to a label to receive notifications.

      Use -PassThru to return the updated label.
      .EXAMPLE
      Register-GitLabProjectLabelSubscription -ProjectID 20 -Name 'Type:Bug'
      ---------------------------------------------------------------
      Sets up a subscription to label 'Type:Bug' for the authenticated user.
  #>
  [CmdletBinding()]
  [Alias()]
  [OutputType()]
  Param
  (
    # The ID of the project
    [Parameter(HelpMessage = 'ProjectID',
    Mandatory = $true)]
    [Alias('ID')]
    [int]$ProjectID,

    # The Name of the Label
    [Parameter(HelpMessage = 'Label Name',
    Mandatory = $true)]
    [Alias()]
    [string]$Name,

    #Specify Existing GitlabConnector
    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [psobject]$GitlabConnect = (Get-GitlabConnect),

    #Return the updated Label
    [Parameter(HelpMessage = 'Passthru the label',
    Mandatory = $false)]
    [switch]$PassThru
  )
  
  $httpmethod = 'post'
  $apiurl = "projects/$id/labels/$name/subscription"

  $newlabel = $GitlabConnect.callapi($apiurl,$httpmethod)

  if($PassThru)
  {
    return $newlabel
  }
}
