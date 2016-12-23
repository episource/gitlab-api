function Set-GitLabUser
{
  <#
      .SYNOPSIS
      Set properties on specified user.
      .DESCRIPTION
      The Set-GitlabUser function sets properties on the specified user.

      returns modified user when -PassThru is specified
      .EXAMPLE
      Set-GitLabUser -Email 'John.Johnson@contoso.com' -Password 'randompassword' -UserName 'john.johnson' -Name 'John Johnson'
      ---------------------------------------------------------------
      Creates a 
      .EXAMPLE
      New-GitLabProject -Name 'GitLab-API' -PassThru
      ---------------------------------------------------------------
      creates a new project named 'Gitlab-API' and returns the projects object
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
    #ID of yhe user
    [Parameter(HelpMessage = 'User ID',
    Mandatory = $true)]
    [Alias('ID')]
    [int]$UserID,

    #Email of the user
    [Parameter(HelpMessage = 'Email for user')]
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

    #Password of the  user
    [Parameter(HelpMessage = 'password user')]
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
        
    #Username of the user
    [Parameter(HelpMessage = 'users username')]
    [string]$UserName,
        
    #Name of the user
    [Parameter(HelpMessage = 'users name')]
    [string]$Name,

    #Skype ID of the user
    [Parameter(HelpMessage = 'users Skype ID',
    Mandatory = $false)]
    [string]$Skype,

    #LinkedIn of the user
    [Parameter(HelpMessage = 'users LinkedIn ID',
    Mandatory = $false)]
    [string]$LinkedIn,

    #Twitter Accountof the user
    [Parameter(HelpMessage = 'users Twitter Account',
    Mandatory = $false)]
    [string]$Twitter,

    #Website URL of the user
    [Parameter(HelpMessage = 'users Website URL',
    Mandatory = $false)]
    [string]$WebsiteURL,

    #Organisation of the user
    [Parameter(HelpMessage = 'users Organisation',
    Mandatory = $false)]
    [string]$Organization,

    #Number of projects user can create
    [Parameter(HelpMessage = 'Number of projects user can create',
    Mandatory = $false)]
    [int]$ProjectsLimit,

    #External UID of the user
    [Parameter(HelpMessage = 'users External UID',
    Mandatory = $false)]
    [string]$ExternUID,

    #external providers name of the user
    [Parameter(HelpMessage = 'users external provider name',
    Mandatory = $false)]
    [string]$Provider,

    #User's biography
    [Parameter(HelpMessage = "User's biography",
    Mandatory = $false)]
    [ValidateScript({
          if($_ -match "^.{0,250}$") 
          {
            $true
          }
          else 
          {
            Throw 'Bio must contain at most 250 characters'
          }
    })]
    [string]$Bio,

    #Location of the user
    [Parameter(HelpMessage = 'users Location',
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
  $httpmethod = 'put'
  $apiurl = "users/$UserID"
  $parameters = @{}
  #email - Email
  if($Email)
  {
    $parameters.email = $Email
  }
  #password - Password
  if($Password)
  {
    $parameters.password = $Password
  }
  #username - Username
  if($UserName)
  {
    $parameters.username = $UserName
  }
  #name - Name
  if($Name)
  {
    $parameters.name = $Name
  }
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
  if($PSCmdlet.MyInvocation.BoundParameters.keys -contains 'Bio')
  {
    $parameters.'bio' = $Bio.ToString()
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

  $modusr = $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)

  if($PassThru)
  {
    return $modusr
  }
}
