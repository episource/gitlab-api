function Get-GitlabConnect {
  param(
    [parameter(Mandatory = $false)]
    [Alias('KeyId')]
    [system.guid]$id
  )
  if($id){
    $Gitlabtoken = (Get-GitLabToken).where({$_.id -eq $id})

    if(-not $Gitlabtoken){
      $errormessage = 'No Token found with Id [$ID]'
      Write-Error -Message $errormessage -Category ResourceUnavailable -ErrorAction Stop
    }
  }else{
    $Gitlabtoken = Get-GitLabToken -active
  }

  return [gitlabconnect]::new($Gitlabtoken.gitlabhost,$Gitlabtoken.gitlabuser)
}