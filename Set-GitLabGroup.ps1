function Set-GitLabGroup {
    <#
      .SYNOPSIS
      Update settings of existing gitlab group
      .DESCRIPTION
      Updates the settings of an existing gitlab group with given id.
      .EXAMPLE
      Set-GitLabGroup -GroupId 10 -Name "NewName"
      ---------------------------------------------------------------
      Changes the name of group with id 10 to "NewName".
    #>
    [Alias()]
    [OutputType()]
    Param (
        #Group id
        [Parameter(HelpMessage='id of the group',
                Mandatory=$true)]
        [Alias("ID")]
        [String]$GroupId,
    
        #The Name of the new group
        [Parameter(HelpMessage='new group name',
                Mandatory=$false)]
        [string]$Name,

        #The path of the new group
        [Parameter(HelpMessage='path of the group',
                Mandatory=$false)]
        [string]$Path,
        
        #The description of the new group
        [Parameter(HelpMessage='description of the group',
                Mandatory=$false)]
        [string]$Description,
        
        #Membership lock
        [Parameter(HelpMessage='prevent adding new members to project membership within this group',
                Mandatory=$false)]
        [Alias("membership_lock")]
        [bool]$MembershipLock,
        
        #Membership lock
        [Parameter(HelpMessage='prevent sharing a project with another group within this group',
                Mandatory=$false)]
        [Alias("share_with_group_lock")]
        [bool]$ShareWithGroupLock,
        
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
        [Parameter(HelpMessage='(premium) The ID of a project to load custom file templates from',
                Mandatory=$false)]
        [Alias("file_template_project_id")]
        [int]$FileTemplateProjectId,
        
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

    $httpmethod = "put"
    $apiurl = "groups/$([System.Web.HttpUtility]::UrlEncode($groupId))"
    $parameters = @{}

    if($PSCmdlet.MyInvocation.BoundParameters.keys -contains 'Name'){
        $parameters.name=$name
    }
    if($PSCmdlet.MyInvocation.BoundParameters.keys -contains 'Path'){
        $parameters.path=$path
    }
    if($PSCmdlet.MyInvocation.BoundParameters.keys -contains 'Description'){
        $parameters.description=$description
    }
    if($PSCmdlet.MyInvocation.BoundParameters.keys -contains 'MembershipLock'){
        $parameters.membership_lock=$membershipLock
    }
    if($PSCmdlet.MyInvocation.BoundParameters.keys -contains 'ShareWithGroupLock'){
        $parameters.share_with_group_lock=$shareWithGroupLock
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
    if($PSCmdlet.MyInvocation.BoundParameters.keys -contains 'FileTemplateProjectId'){
        $parameters.file_template_project_id=$fileTemplateProjectId
    }
    if($PSCmdlet.MyInvocation.BoundParameters.keys -contains 'ParentID'){
        $parameters.parent_id=$parentID
    }
    if($PSCmdlet.MyInvocation.BoundParameters.keys -contains 'SharedRunnersLimit'){
        $parameters.shared_runners_minutes_limit=$sharedRunnersLimit
    }
    
    $group= $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)
    if($passThru){
        return $group
    }
}
