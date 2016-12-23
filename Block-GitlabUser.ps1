function Block-GitlabUser
{
  <#
      .SYNOPSIS
      Marks the Users state as blocked.
      .DESCRIPTION
      the Block-GitlabUser marks the given user as blocked
      .EXAMPLE
      Block-GitlabUser -UserID 10
      ---------------------------------------------------------------
      Marks the User with ID 10 as blocked
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
    [psobject]$GitlabConnect = (Get-GitLabConnect)
  )

  $httpmethod = 'put'
  $apiurl = "users/$UserID/block"
  $parameters = @{}

  $null = $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)
}
