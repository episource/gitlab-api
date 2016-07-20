Function Get-GitLabToken 
{
  param(
    #returns only the active gitlabtoken
    [switch]$active
  )
  #region get all keys
  $Keyitem = Import-Clixml $script:GitlabKeyfile
  #endregion
  #region return only active key
  if($active)
  {
    $Keyitem.keys.where({
        $_.id -eq $Keyitem.activekey
    })
    #region return all keys
  }
  else
  {
    foreach($key in $Keyitem.keys)
    {
      #add value to show active key
      $value = ($key.id -eq $Keyitem.activekey)
      Add-Member -InputObject $key -MemberType NoteProperty -Name Active -Value $value
      $key
    }
  }
  #endregion
}
