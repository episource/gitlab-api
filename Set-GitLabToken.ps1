Function Set-GitLabToken 
{
  param(
    #Hostname 
    [Parameter(Mandatory = $true)]
    [string]$ID,
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
