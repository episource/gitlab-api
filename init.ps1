# use this file to define global variables on module scope
# or perform other initialization procedures.
# this file will not be touched when new functions are exported to
# this module.

#region check data file

$GitlabdataFolder = Join-Path -Path $env:programdata -ChildPath '/GitLab-API'
$keyfilename = "${env:USERDOMAIN}_${env:username}_${env:computername}_APIs.key"
$GitlabKeyfile = Join-Path -Path $Script:GitlabdataFolder -ChildPath $keyfilename
    
if(-not (Test-Path $GitlabdataFolder -PathType Container))
{
  New-Item $GitlabdataFolder -ItemType Directory -Force
}
     
if(-not (Test-Path $GitlabKeyfile -PathType Leaf))
{
  $KeyItem = [pscustomobject]@{
    DecryptUserDomain = ${env:USERDOMAIN}
    DecryptUserName   = ${env:username}
    DecryptComputer   = ${env:computername}
    Keys              = @()
    ActiveKey         = $null
  }
      
  Export-Clixml -InputObject $KeyItem -Path $GitlabKeyfile
}
    
#check for existing key file
$KeyItem = Import-Clixml $GitlabKeyfile
    
if( -not $KeyItem.activekey)
{
  Write-Warning -Message "No gitlab api token is defined for ${env:USERDOMAIN}\${env:username} on computer ${env:computername}. Fix with add-GitLabToken" -WarningAction Continue
}

#import object definitions

. $PSScriptRoot/obj/objinit.ps1


    


  


  



