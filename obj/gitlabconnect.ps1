#requires -Version 5
enum HTTPMethod {
    Get = 1
    Post = 2
    Put = 3
    Delete = 4
}

class GitLabConnect {
    [string]$hostname
    [string]$username
    [securestring]$token

    <#
            Contructor with api-token
    #>
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
        $this.token = ConvertTo-SecureString $token -AsPlainText -Force
        $this.username = $result.username
    }

    <#
            Contructor with credentials with password as api-token
    #>
    GitlabConnect ([string]$hostname,[pscredential]$User)
    {
        $header = @{
            'PRIVATE-TOKEN' = $User.GetNetworkCredential().Password
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
        $this.token = $User.password
        $this.username = $result.username
    }

    <#
            Helper function to resolve webrequest headers
    #>
    Hidden [pscustomobject] resolvelinkheader ([string]$linksString)
    {
        #one string multiple links

        $resultobj = @{}

        $LinkStrings = $linksString -split ',' #multiple strings one string per link
        foreach($linkstring in $LinkStrings)
        {
            $linkrel = $null
            $linkprop = $linkstring -split ';'
            $linkargurl = $linkprop[0].trim(' ','<','>')
            $linkparamsstring = @($linkargurl.Split('?'))[1].split('&')
            $linkparams = @{}
            foreach($paramstring in $linkparamsstring)
            {
                $key = $paramstring.split('=')[0]
                $urlvalue = $paramstring.split('=')[1]
                $value = [uri]::UnescapeDataString($urlvalue)
                $linkparams.$key = $value
            }
            $linkarg = $linkparams
            Invoke-Expression -Command ('$link' + $linkprop[1].trim())
            $resultobj.$linkrel = $linkarg
        }

    
    
        return [pscustomobject]$resultobj
    }

    <#
            Main function overload to resolve API calls withoud parameters
    #>
    [psobject] callapi ([string]$apiurl,[HTTPMethod]$HTTPmethod)
    {
        $result = $this.callapi($apiurl,$HTTPmethod,[hashtable]::new())
        return $result
    }

    <#
            Main function overload to resolve API calls withoud body
    #>
    [psobject] callapi ([string]$apiurl,[HTTPMethod]$HTTPmethod,[hashtable]$parameters){
        $result = $this.callapi($apiurl,$HTTPmethod,$parameters,[hashtable]::new())
        return $result
    }

    <#
            Main function to resolve API call with 
    #>
    Hidden [psobject] callapi ([string]$apiurl,[HTTPMethod]$HTTPmethod,[hashtable]$parameters,[hashtable]$body)
    {
        #create header
        $gitlabuser = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $this.username, $this.token
        $header = @{
            'PRIVATE-TOKEN' = $gitlabuser.GetNetworkCredential().Password
        }
        #create parameter string for url
        $parameteruristring = $null
        if($parameters.count -gt 0)
        {
            $parameteruristrings = @()
            foreach($key in $parameters.keys)
            {
                $encodeparameter = [uri]::EscapeDataString($key)
                $encodeargument = [uri]::EscapeDataString([string]$parameters.$key)
                $parameteruristrings += "$encodeparameter=$encodeargument"
            }
            $parameteruristring = '?' + ($parameteruristrings -join '&')
        }
    
        #cleanup url
        $apiurl = $apiurl.TrimStart('/')
        $userurl = "https://$($this.hostname)/api/v3/$apiurl$parameteruristring"
        $errorprop = $null 
        $resultobj = $null   
        $httpresult = $null
        #send request
        try
        {
            switch($HTTPmethod){ 
                'get' 
                {
                    $httpresult = Invoke-WebRequest -Uri $userurl -Headers $header -Method Get 
                }
                'post' 
                {
                    $httpresult = Invoke-WebRequest -Uri $userurl -Headers $header -Method Post -Body $body
                }
                'put' 
                {
                    $httpresult = Invoke-WebRequest -Uri $userurl -Headers $header -Method Put -Body $body
                }
                'delete' 
                {
                    $httpresult = Invoke-WebRequest -Uri $userurl -Headers $header -Method Delete
                }
                default 
                {
                    Write-Error -Message 'no valid method specified' -ErrorAction Stop
                } 
            }
        }
        catch 
        {
            write-error -message $_.ErrorDetails.Message -Category $_.CategoryInfo.Category -ErrorAction Stop
        }
        finally
        {

        }

        #parse result
        $isResultJson = $httpresult.headers.'Content-Type' -eq 'application/json'
        if (-not $isResultJson)
        {
            Write-Error -Message "Result from api call is not json, check if $($this.hostname) is a gitlab server and supports api v3" -Category InvalidData -ErrorAction Stop
        }
               
        $resultobj = ConvertFrom-Json -InputObject $httpresult.Content
        
        #if passed page is not the last page
        $links = $this.resolvelinkheader($httpresult.Headers.Link)

        if($links.next)
        {
            #get link for next page
            $links = $this.resolvelinkheader($httpresult.Headers.Link)

            foreach($key in $links.next.keys){
                $parameters.$key = $links.next.$key
            }
            #get results from next page
            $resultobj += $this.callapi($apiurl,$HTTPmethod,$parameters)
        }

        return $resultobj
    }
}