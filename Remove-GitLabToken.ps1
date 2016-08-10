Function Remove-GitLabToken 
{
  param(
    #Hostname 
    [Parameter(Mandatory = $true)]
    [string]$ID
  )
  #region check for key  
  $Keyitem = Import-Clixml $script:GitlabKeyfile 
  $removekey  = $Keyitem.keys.where({
      $_.id -eq $ID
  })
  if(-not $removekey)
  {
    $errormessage = "could not find GitlabToken with ID [$ID]."
    Write-Error -Message $errormessage -Category ResourceUnavailable -ErrorAction Stop
  }
  #endregion
  #region new-keyarray
  $newarray = @()
  
  foreach($key in $Keyitem.keys)
  {
    if(-not ($key.id -eq $removekey.id))
    {
      $newarray += $key
    }
  }
  
  $Keyitem.Keys = $newarray
  #endregion
  #region check for activekey
  if($Keyitem.activekey -eq $removekey.id)
  {
    $Keyitem.activekey = $Keyitem.keys[0].id
  }
  #endregion  
  #region save config
  Export-Clixml -InputObject $keyitem -Path $script:GitlabKeyfile 
  #endregion
}
