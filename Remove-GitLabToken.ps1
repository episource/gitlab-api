Function Remove-GitLabToken 
{
  <#
      .SYNOPSIS
      Remove Token from local GitLab-API instance.
      .DESCRIPTION
      The Remove-GitLabToken function removes a token from the local GitLab-API instance.
      IDs for tokens can be retrievd via Get-GitLabToken.
      .EXAMPLE
      Remove-GitLabToken -id 30b4bcdb-7094-484d-b537-8e9ff8e58995
      ---------------------------------------------------------------
      Removes the token with id 30b4bcdb-7094-484d-b537-8e9ff8e58995 from teh local gitlab instance
  #>
  [CmdletBinding()]
  [Alias()]
  [OutputType()]
  param(
    # ID of the key, can be retrieved via Get-GitLabToken.
    [Parameter(Mandatory = $true)]
    [string]$ID
  )
  # region check for key  
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
