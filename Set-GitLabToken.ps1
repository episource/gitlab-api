Function Set-GitLabToken 
{
  <#
      .SYNOPSIS
      Modify specified token in local GitLab-API instance.
      .DESCRIPTION
      The Set-GitLabToken function modifies a token from the local GitLab-API instance.
      IDs for tokens can be retrievd via Get-GitLabToken.
      .EXAMPLE
      Set-GitLabToken -id 30b4bcdb-7094-484d-b537-8e9ff8e58995 -active
      ---------------------------------------------------------------
      Sets the gitlab token with id 30b4bcdb-7094-484d-b537-8e9ff8e58995 to active.
      This sets the token to be the default for all connections.
  #>
  param(
    # The Id of The token
    # Can be retrieved using Get-GitLabToken
    [Parameter(Mandatory = $true)]
    [string]$ID,

    # sets the token to active
    [switch]$active
  )
  #region getkey
  $Keyitem = Import-Clixml $script:GitlabKeyfile 
  $setkey  = $Keyitem.keys.where({
      $_.id -eq $ID
  })
  if(-not $setkey)
  {
    $errormessage = "could not fiund GitlabToken with ID [$ID]."
    Write-Error -Message $errormessage -Category ResourceUnavailable -ErrorAction Stop
  }
  #endregion
  #region set active
  if($active)
  {
    $Keyitem.activekey = $setkey.id
  }
  #endregion
  #region save config
  Export-Clixml -InputObject $Keyitem -Path $script:GitlabKeyfile 
  #endregion
}
