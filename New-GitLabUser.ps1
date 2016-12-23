function New-GitLabUser
{
  <#
      .SYNOPSIS
      Creates a new user. Note only administrators can create new users.
      .DESCRIPTION
      The New-GitlabUser function a new user. Note only administrators can create new users.

      returns new user when -PassThru is specified
      .EXAMPLE
      New-GitLabUser -Email 'John.Johnson@contoso.com' -Password 'randompassword' -UserName 'john.johnson' -Name 'John Johnson'
      ---------------------------------------------------------------
      Creates a useraccount for john johnson with appropriate parameters 
      .EXAMPLE
      NNew-GitLabUser -Email 'John.Johnson@contoso.com' -Password 'randompassword' -UserName 'john.johnson' -Name 'John Johnson' -PassThru
      ---------------------------------------------------------------
      Creates a useraccount for john johnson with appropriate parameters 
      returns the newly created user
      .EXAMPLE
      New-GitLabProject -Name 'GitLab-API' -container_registry_enabled $true
      ---------------------------------------------------------------
      Creates a new project named 'Gitlab-API' with container Registry enabled.
  #>
  [CmdletBinding()]
  [Alias()]
  [OutputType()]
  Param
  (
    #Email of the new user
    [Parameter(HelpMessage = 'new users email',
    Mandatory = $true)]
    [ValidateScript({
          if($_ -match "^[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])$") 
          {
            $true
          }
          else 
          {
            Throw "$_ is not a valid email address"
          }
    })]
    [string]$Email,

    #Password of the new user
    [Parameter(HelpMessage = 'new users password',
    Mandatory = $true)]
    [ValidatePattern('(?# Error: Password Must Contain at least 8 characters).{8,}')]
    [ValidateScript({
          if($_ -match "^.{8,}$") 
          {
            $true
          }
          else 
          {
            Throw 'Password Must Contain at least 8 characters'
          }
    })]
    [string]$Password,
        
    #Username of the new user
    [Parameter(HelpMessage = 'new users username',
    Mandatory = $true)]
    [string]$UserName,
        
    #Name of the new user
    [Parameter(HelpMessage = 'new users name',
    Mandatory = $true)]
    [string]$Name,

    #Skype ID of the new user
    [Parameter(HelpMessage = 'new users Skype ID',
    Mandatory = $false)]
    [string]$Skype,

    #LinkedIn of the new user
    [Parameter(HelpMessage = 'new users LinkedIn ID',
    Mandatory = $false)]
    [string]$LinkedIn,

    #Twitter Accountof the new user
    [Parameter(HelpMessage = 'new users Twitter Account',
    Mandatory = $false)]
    [string]$Twitter,

    #Website URL of the new user
    [Parameter(HelpMessage = 'new users Website URL',
    Mandatory = $false)]
    [string]$WebsiteURL,

    #Organisation of the new user
    [Parameter(HelpMessage = 'new users Organisation',
    Mandatory = $false)]
    [string]$Organization,

    #Number of projects user can create
    [Parameter(HelpMessage = 'Number of projects user can create',
    Mandatory = $false)]
    [int]$ProjectsLimit,

    #External UID of the new user
    [Parameter(HelpMessage = 'new users External UID',
    Mandatory = $false)]
    [string]$ExternUID,

    #external providers name of the new user
    [Parameter(HelpMessage = 'new users external provider name',
    Mandatory = $false)]
    [string]$Provider,

    #User's biography
    [Parameter(HelpMessage = "User's biography",
    Mandatory = $false)]
    [string]$Bio,

    #Location of the new user
    [Parameter(HelpMessage = 'new users Location',
    Mandatory = $false)]
    [String]$Location,
        
    #User is admin
    [Parameter(HelpMessage = 'User is admin',
    Mandatory = $false)]
    [Boolean]$Admin,

    #User can create groups
    [Parameter(HelpMessage = 'can create groups',
    Mandatory = $false)]
    [Boolean]$CanCreateGroup,

    #Require confirmation
    [Parameter(HelpMessage = 'Require confirmation',
    Mandatory = $false)]
    [Boolean]$Confirm,

    #Flags the user as external
    [Parameter(HelpMessage = 'Flags the user as external',
    Mandatory = $false)]
    [Boolean]$External,

    # Existing GitlabConnector Object, can be retrieved with Get-GitlabConnect
    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [psobject]$GitlabConnect = (Get-GitLabConnect),

    # Passthru the created project
    [Parameter(HelpMessage = 'Passthru the created project',
    Mandatory = $false)]
    [switch]$PassThru
  )
  $httpmethod = 'post'
  $apiurl = 'users'
  $parameters = @{}
  #email (required) - Email
  $parameters.email = $Email
  #password (required) - Password
  $parameters.password = $Password
  #username (required) - Username
  $parameters.username = $UserName
  #name (required) - Name
  $parameters.name = $Name
  #skype (optional) - Skype ID
  if($Skype)
  {
    $parameters.'skype' = $Skype
  }
  #linkedin (optional) - LinkedIn
  if($LinkedIn)
  {
    $parameters.'linkedin' = $LinkedIn
  }
  #twitter (optional) - Twitter account
  if($Twitter)
  {
    $parameters.'twitter' = $Twitter
  }
  #website_url (optional) - Website URL
  if($WebsiteURL)
  {
    $parameters.'website_url' = $WebsiteURL
  }
  #organization (optional) - Organization name
  if($Organization)
  {
    $parameters.'organisation' = $Organization
  }
  #projects_limit (optional) - Number of projects user can create
  if($ProjectsLimit)
  {
    $parameters.'projects_limit' = $ProjectsLimit
  }
  #extern_uid (optional) - External UID
  if($ExternUID)
  {
    $parameters.'extern_uid' = $ExternUID
  }
  #provider (optional) - External provider name
  if($Provider)
  {
    $parameters.'provider' = $Provider
  }
  #bio (optional) - User's biography
  if($Bio)
  {
    $parameters.'bio' = $Bio
  }
  #location (optional) - User's location
  if($Location)
  {
    $parameters.'location' = $Location
  }
  #admin (optional) - User is admin
  if($PSCmdlet.MyInvocation.BoundParameters.keys -contains 'Admin')
  {
    if($Admin)
    {
      $parameters.admin = 'true'
    }
    else
    {
      $parameters.admin = 'false'
    }
  }
  #can_create_group (optional) - User can create groups
  if($PSCmdlet.MyInvocation.BoundParameters.keys -contains 'CanCreateGroup')
  {
    if($CanCreateGroup)
    {
      $parameters.'can_create_group' = 'true'
    }
    else
    {
      $parameters.'can_create_group' = 'false'
    }
  }
  #confirm (optional) - Require confirmation
  if($PSCmdlet.MyInvocation.BoundParameters.keys -contains 'Confirm')
  {
    if($Confirm)
    {
      $parameters.'confirm' = 'true'
    }
    else
    {
      $parameters.'confirm' = 'false'
    }
  }
  #external (optional) - Flags the user as external
  if($PSCmdlet.MyInvocation.BoundParameters.keys -contains 'External')
  {
    if($External)
    {
      $parameters.'external' = 'true'
    }
    else
    {
      $parameters.'external' = 'false'
    }
  }

  $newusr = $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)

  if($PassThru)
  {
    return $newusr
  }
}
