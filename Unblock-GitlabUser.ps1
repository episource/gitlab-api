function Unblock-GitlabUser
{
  <#
      .SYNOPSIS
      Marks the Users state as active
      .DESCRIPTION
      the Block-GitlabUser marks the given user as active
      .EXAMPLE
      Unblock-GitLabUser -UserID 10
      ---------------------------------------------------------------
      Marks the User with ID 10 as active
  #>
  [CmdletBinding()]
  [Alias()]
  [OutputType()]
  Param
  (
    # The ID of the user
    [Parameter(HelpMessage = 'UserID',
    Mandatory = $true)]
    [Alias('ID')]
    [int]$UserID,
    
    # Existing GitlabConnector Object, can be retrieved with Get-GitlabConnect
    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [psobject]$GitlabConnect = (Get-GitlabConnect)
  )

  $httpmethod = 'put'
  $apiurl = "users/$UserID/unblock"
  $parameters = @{}

  $null = $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)
}