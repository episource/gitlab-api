function Get-GitLabUser
{
    <#
      .SYNOPSIS
      Gets Gitlab User
      .DESCRIPTION
      The Get-GitlabUser function retruns a list of users

      By default this function returns all available users
      you can filter these users on 'blocked' or 'active'

      returns single user if id is passed

      Admins can retreive a lot mor info conserning users then non-admins:
      they can serach on 'username' and filter on 'external'
      .EXAMPLE
      Get-GitLabUser
      ---------------------------------------------------------------
      Returns all users including blockedUsers
      .EXAMPLE
      Get-GitLabUser -ID 20
      ---------------------------------------------------------------
      Returns the user with ID 20
      .EXAMPLE
      Get-GitLabProject -Blocked
      ---------------------------------------------------------------
      Returns all users that are blocked
    #>
    [CmdletBinding(DefaultparametersetName = 'AllUsers')]
    [Alias()]
    [OutputType()]
    param(
      #filter Users on state: Active
      [Parameter(ParameterSetName='AllUsersActive')]
      [Switch]$Active,

      #Filter users on state: Blocked
      [Parameter(ParameterSetName='AllUsersBlocked')]
      [Switch]$Blocked,
      
      #Retrun only external Users
      [Parameter(ParameterSetNAme='AllUsersActive')]
      [Parameter(ParameterSetName='AllUsersBlocked')]
      [bool]$External,

      #Get single user by ID
      [Parameter(ParameterSetName='SingleUserByID',
                   Mandatory=$true)]
      [Alias('UserID')]
      [int]$ID,

      #get single user by UserName
      [Parameter(ParameterSetNAme='SingleUserByUserName',
                   Mandatory=$true)]
      [string]$UserName,

      # Existing GitlabConnector Object, can be retrieved with Get-GitlabConnect
        [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
                Mandatory = $false,
        DontShow = $true)]
        [psobject]$GitlabConnect = (Get-GitlabConnect)
    )
    
    $httpmethod = 'get'
    $apiurl = 'users'
    $parameters = @{}

    if($PSCmdlet.ParameterSetName -like 'AllProjects*')
    {
      if($active){
        $parameters.'active' = 'true'
      }

      if ($blocked){
        $parameters.'blocked' = 'true' 
      }

      if($PSCmdlet.MyInvocation.BoundParameters.keys -contains 'External'){
      if($External){
        $parameters.'external' = 'true'
      }
      else{
        $parameters.'external' = 'false'
      }
    }
    }

    if($PSCmdlet.ParameterSetName -eq 'SingleUserByID')
    {
        $apiurl += "/$ID"
    }

    if($PSCmdlet.ParameterSetName -eq 'SingleUserByUserName')
    {
        if($UserName){
        $parameters.'username' = $UserName
        }
    }

    $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)
}
