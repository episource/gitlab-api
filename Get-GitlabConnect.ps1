function Get-GitLabConnect 
{
  <#
      .SYNOPSIS
      Composes and Returns a GitlabConnect object.
      .DESCRIPTION
      Composes and Returns a GitlabConnect object.
      Uses active token from stored config by default. you can add tokens with Add-GitlabToken.
      Passing -ID of a token forces gitlabconnect to use that token to create a connect object.

      Gitlabconnect objects can be passed to all functions to specify a connection to use for interaction with gitlab.

      A gitlabconnectobject can also be generated on the fly by passing -GitlabHostname and -Token 
      .EXAMPLE
      Get-GitLabConnect
      ---------------------------------------------------------------
      returns a Connect object based of the current active gitlabtoken
      .EXAMPLE
      Get-GitLabConnect -id 695c6eea-1fc3-4f78-886e-6b7c0f27102e
      ---------------------------------------------------------------
      returns a Connect object based of token 695c6eea-1fc3-4f78-886e-6b7c0f27102e
      tokenid can be retrieved with Get-GitlabToken
      .EXAMPLE
      Get-GitLabConnect -GitLabHostName gitlab.com -Token XXXXXXXXXX
      ---------------------------------------------------------------
      Returns a Connect object based on passed hostname and token.
      These connect settings are not persistent
      .EXAMPLE
      $GitLabConnectObj = Get-GitLabConnect -GitLabHostName gitlab.com -Token XXXXXXXXXX
      Get-GitLabProject -GitLabConnect $GitLabConnectObj

      ---------------------------------------------------------------
      Creates a connect object on the fly.
      Returns all the projects that the token has access to. 
  #>
  [CmdletBinding(DefaultParameterSetName = 'ByTokenID')]
  [Alias()]
  [OutputType()]
  param(
    #Specifies token to be used to create a connectobject, tokenid can be retrieved with Get-GitlabToken.
    [parameter(Mandatory = $false,
    ParameterSetName='ByTokenID')]
    [Alias('KeyId')]
    [system.guid]$id,

    # Hostname for the Gitlabserver. if url for gitlabserver is https://gitlab.contoso.com, hostname would be gitlab.contoso.com
    [Parameter(Mandatory = $true,
    ParameterSetName='OnTheFly')]
    [string]$GitLabHostName,

    # Token supplied from gitlab. This can be an private and an Access Token.
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