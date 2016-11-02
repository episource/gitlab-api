Function Get-GitLabToken 
{
  <#
      .SYNOPSIS
      Get persisted gitlab token
      .DESCRIPTION
      TThe Get-GitLabToken returns all persisted API token objects available for the current user and system.
      When -Active is specified only the active (default) token will be returned.

      Tokens can be set to active using set-gitlabToken
      .EXAMPLE
      Get-GitLabToken
      ---------------------------------------------------------------
      Get all persistant Gitlab tokens.
      .EXAMPLE
      Get-GitLabToken -Active
      ---------------------------------------------------------------
      Gets the active GitLab token.

  #>
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
