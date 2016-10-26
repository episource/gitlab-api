function Get-GitlabConnect {
  param(
    [CmdletBinding(DefaultParameterSetName = 'ByTokenID')]
    [parameter(Mandatory = $false,
    ParameterSetName='ByTokenID')]
    [Alias('KeyId')]
    [system.guid]$id,

        #Hostname for the Gitlabserver. if url for gitlabserver is https://gitlab.contoso.com, hostname would be gitlab.contoso.com
    [Parameter(Mandatory = $true,
    ParameterSetName='OnTheFly')]
    [string]$GitLabHostName,
    #Token supplied from gitlab. This can be an private and an Access Token.
    [Parameter(Mandatory = $true,
    ParameterSetName='OnTheFly')]
    [string]$Token
  )
  if($PSCmdlet.ParameterSetName -like 'ByTokenID'){
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
  if($PSCmdlet.ParameterSetName -like 'OnTheFly')
  {
    return [gitlabconnect]::new($GitLabHostName,$Token)
  }
}