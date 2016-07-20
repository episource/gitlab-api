Function Add-GitLabToken 
{
  param(
    #Hostname for the Gitlabserver. if url for gitlabserver is https://gitlab.contoso.com, hostname would be gitlab.contoso.com
    [Parameter(Mandatory = $true)]
    [string]$GitLabHostName,
    #Token supplied from gitlab. This can be an private and an Access Token.
    [Parameter(Mandatory = $true)]
    [string]$Token,
    [Switch]$active
  )
  #region check token
      
  $header = @{
    'PRIVATE-TOKEN' = $Token
  }
      
  $userurl = "https://$GitLabHostName/api/v3/user"
      
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
      ($key.gitlabhost -eq $GitLabHostName) -and
      ($key.gitlabuser.username -eq $gitlabusername)
    )
    {
      $errormessage = "Combination of $GitLabHostName and $gitlabusername (user associated with passed token) already exists. remove token before creation."
      Write-Error $errormessage -Category ResourceExists -ErrorAction Stop
    }
  }
  #endregion
  #region create new tokenobj

  $securekey = ConvertTo-SecureString -String $Token -AsPlainText -Force
  $gitlabuser = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $gitlabusername, $securekey
  $newkey = [pscustomobject]@{
    ID         = [guid]::NewGuid().ToString()
    GitLabHost = $GitLabHostName
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
   
