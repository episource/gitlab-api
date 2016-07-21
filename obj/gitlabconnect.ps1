enum HTTPMethod {
  Get = 1
  Post = 2
  Put = 3
}

class GitLabConnect {
  [string]$hostname
  [string]$username
  [securestring]$token

  GitLabConnect ([string]$hostname,[string]$token)
  {
    #region check token
      
    $header = @{
      'PRIVATE-TOKEN' = $token
    }
      
    $userurl = "https://$hostname/api/v3/user"
    $errorprop = $null 
    $result = $null   
    try
    {
      $result = Invoke-RestMethod -Uri $userurl -Headers $header
    
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
    $this.hostname = $hostname
    $this.token = convertto-securestring $token -AsPlainText -Force
    $this.username = $result.username
  }

  GitlabConnect ([string]$hostname,[pscredential]$User)
  {
    
    $header = @{
      'PRIVATE-TOKEN' = $user.GetNetworkCredential().Password
    }
      
    $userurl = "https://$hostname/api/v3/user"
    $errorprop = $null 
    $result = $null   
    try
    {
      $result = Invoke-RestMethod -Uri $userurl -Headers $header
    
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
    $this.hostname = $hostname
    $this.token = $user.password
    $this.username = $result.username
  }

  [pscustomobject] callapi ([string]$apiurl,[HTTPMethod]$HTTPmethod){
    $result = $this.callapi($apiurl,$HTTPmethod,[hashtable]::new())
    return $result
  }

  [pscustomobject] callapi ([string]$apiurl,[HTTPMethod]$HTTPmethod,[hashtable]$parameters){
    #create header
    $gitlabuser = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $this.username, $this.token
    $header = $parameters
    $header.'PRIVATE-TOKEN' = $gitlabuser.GetNetworkCredential().Password

    #cleanup url
    $apiurl = $apiurl.TrimStart('/')
    $userurl = "https://$($this.hostname)/api/v3/$apiurl"
    $errorprop = $null 
    $result = $null   
    try
    {
      $result = Invoke-RestMethod -Uri $userurl -Headers $header -Method $httpmethod
    
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
    return $result
  }

}