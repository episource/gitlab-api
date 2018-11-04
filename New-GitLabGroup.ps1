function New-GitLabGroup {
    <#
      .SYNOPSIS
      Adds a new gitlab group
      .DESCRIPTION
      Adds a new gitlab group with given name, path and settings.
      .EXAMPLE
      NewGitLabGroup -Name TestName -Path test
      ---------------------------------------------------------------
      Creates a new group "test" named "TestName".
    #>
    [Alias()]
    [OutputType()]
    Param (
        #The Name of the new group
        [Parameter(HelpMessage='new group name',
                Mandatory=$true)]
        [string]$Name,

        #The path of the new group
        [Parameter(HelpMessage='path of the group',
                Mandatory=$true)]
        [string]$Path,
        
        #The description of the new group
        [Parameter(HelpMessage='description of the group',
                Mandatory=$false)]
        [string]$Description,
        
        #The visibility of the new group
        [Parameter(HelpMessage='visibility of the group',
                Mandatory=$false)]
        [validateset("private","internal","public")]
        [string]$Visibility,
        
        #The lfs settings for the new group
        [Parameter(HelpMessage='enable/disable lfs support',
                Mandatory=$false)]
        [Alias("lfs_enabled")]
        [bool]$LfsEnabled,
        
        #request_access_enabled
        [Parameter(HelpMessage='allow users to request member access',
                Mandatory=$false)]
        [Alias("request_access_enabled")]
        [bool]$RequestAccessEnabled,
        
        #parent id
        [Parameter(HelpMessage='the parent group id for creating nested group',
                Mandatory=$false)]
        [Alias("parent_id")]
        [int]$ParentID,
        
        #shared_runners_minutes_limit
        [Parameter(HelpMessage='(admin-only) Pipeline minutes quota for this group',
                Mandatory=$false)]
        [Alias("shared_runners_minutes_limit")]
        [int]$SharedRunnersLimit,

        # Existing GitlabConnector Object, can be retrieved with Get-GitlabConnect
        [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
                Mandatory = $false,
                DontShow = $true)]
        [psobject]$GitlabConnect = (Get-GitlabConnect),
        
        # Passthru the created project
        [Parameter(HelpMessage='Passthru the created project',
                Mandatory=$false)]
        [switch]$PassThru
    )

    $httpmethod = 'post'
    $apiurl = 'groups'
    $parameters = @{}
    $parameters.name = $name
    $parameters.path = $path

    if($PSCmdlet.MyInvocation.BoundParameters.keys -contains 'Description'){
        $parameters.description=$description
    }
    if($PSCmdlet.MyInvocation.BoundParameters.keys -contains 'Visibility'){
        $parameters.visibility=$visibility
    }
    if($PSCmdlet.MyInvocation.BoundParameters.keys -contains 'LfsEnabled'){
        $parameters.lfs_enabled=$lfsEnabled
    }
    if($PSCmdlet.MyInvocation.BoundParameters.keys -contains 'RequestAccessEnabled'){
        $parameters.request_access_enabled=$requestAccessEnabled
    }
    if($PSCmdlet.MyInvocation.BoundParameters.keys -contains 'ParentID'){
        $parameters.parent_id=$parentID
    }
    if($PSCmdlet.MyInvocation.BoundParameters.keys -contains 'SharedRunnersLimit'){
        $parameters.shared_runners_minutes_limit=$sharedRunnersLimit
    }
    
    $newgroup= $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)
    if($passThru){
        return $newgroup
    }
}
