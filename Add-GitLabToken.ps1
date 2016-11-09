Function Add-GitLabToken 
{
    <#
      .SYNOPSIS
      Adds a access token to the local GitLab-API instance
      .DESCRIPTION
      Adds a access token to the local GitLab-API instance. 
      First checks if the specified token and hostname is valid.
      If valid adds it to the local configuration file.

      If -Active is used the token will be added as the active token.
      .EXAMPLE
      Add-GitLabToken -GitLabURI gitlab.com -Token XXXXXXXXXX
      ---------------------------------------------------------------
      Adds a GitlabToken for gitlab.com to the local instance of the powershell gitlab-api
  #>
  [CmdletBinding()]
  [Alias()]
  [OutputType()]
  param(
    #Gitlab URI, e.a. https://gitab.com
    [Parameter(HelpMessage = 'GitlabServer URI',
    Mandatory = $true)]
    [ValidatePattern("^(?:http|https):\/\/(?:[\w\.\-\+]+:{0,1}[\w\.\-\+]*@)?(?:[a-z0-9\-\.]+)(?::[0-9]+)?(?:\/|\/(?:[\w#!:\.\?\+=&%@!\-\/\(\)]+)|\?(?:[\w#!:\.\?\+=&%@!\-\/\(\)]+))?$")]
    [string]$GitLabURI,

    #Token supplied from gitlab. This can be an private and an Access Token.
    [Parameter(HelpMessage = 'access token GitlabServer',
    Mandatory = $true)]
    [string]$Token,

    #If specified adds the token as the active token
    [Parameter(HelpMessage = 'is token active')]
    [Switch]$active
  )
  #region check token
      
  $header = @{
    'PRIVATE-TOKEN' = $Token
  }
      
  $userurl = "$GitLabURI/api/v3/user"
      
  try
  {
    $result = Invoke-RestMethod -Uri $userurl -Headers $header
    $gitlabusername = $result.username
    $errorprop = $null
  }
  catch [System.Net.WebException] 
  {
    switch -Wildcard ($_.exception.Message)
    {
      '*Could not create SSL/TLS secure channel.*'  
      {
        $errorprop = @{
          message  = "could not reach server at $userurl"
          category = 'ConnectionError'
        }
      }
      '*401*'                                       
      {
        $errorprop = @{
          message  = "(401)token not valid for server $userurl"
          category = 'AuthenticationError'
        }
      }
      '*500*'                                       
      {
        $errorprop = @{
          message  = "(500)Server error at $userurl"
          category = 'AuthenticationError'
        }
      }
    }
  }
  catch 
  {
    {
      $errorprop = @{
        message  = $_.exception.message
        category = $_.categoryinfo.category
      }
    }
  }
  finally
  {
    if($errorprop)
    {
      Write-Error @errorprop -ErrorAction Stop
    }        
  }
  #endregion
  #region check for existing token
      
  $Keyitem = Import-Clixml $script:GitlabKeyfile
  foreach($key in $Keyitem.keys)
  {
    if(
      ($key.gitlabhost -eq $GitLabURI) -and
      ($key.gitlabuser.username -eq $gitlabusername)
    )
    {
      $errormessage = "Combination of $GitLabURI and $gitlabusername (user associated with passed token) already exists. remove token before creation."
      Write-Error $errormessage -Category ResourceExists -ErrorAction Stop
    }
  }
  #endregion
  #region create new tokenobj

  $securekey = ConvertTo-SecureString -String $Token -AsPlainText -Force
  $gitlabuser = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $gitlabusername, $securekey
  $newkey = [pscustomobject]@{
    ID         = [guid]::NewGuid().ToString()
    GitLabHost = $GitLabURI
    GitLabUser = $gitlabuser
  }
  #endregion

  #region save to config
  $Keyitem.keys += $newkey

  if(($Keyitem.keys.count -eq 1)-or $active)
  {
    $Keyitem.Activekey = $newkey.id
  }

  Export-Clixml -InputObject $Keyitem -Path $script:GitlabKeyfile
  #endregion
}
   
