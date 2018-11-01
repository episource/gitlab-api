function Set-GitlabProject
{
    <#
      .SYNOPSIS
      Sets the properties you specify on a project.
      .DESCRIPTION
      The Set-GitLabProject function sets the properties of the project you specify.
      returns modified project when -PassThru is specified
      .EXAMPLE
      Set-GitLabProject -ProjectID 20 -Name 'New Project Name'
      ---------------------------------------------------------------
      Sets the name for project 20 to 'New Project Name'
      .EXAMPLE
      Set-GitLabProject -ProjectID 20 -visibility_level 10
      ---------------------------------------------------------------
      Sets the visibility level of project 20 to 10
    #> 
    [CmdletBinding(DefaultParameterSetName='VisibilityCustom')]
    [Alias()]
    [OutputType()]
    Param
    (
        # The Project ID
        [Parameter(HelpMessage='The Project ID',
                   Mandatory=$true)]
    [Alias('ID')]
    [int]$ProjectID,

        # The Name of the project.
        [Parameter(HelpMessage='new project name',
                   Mandatory=$false)]
        [string]$name,

        # Custom repository name for the project.
        [Parameter(HelpMessage='Custom repository name for the project.',
                   Mandatory=$false)]
        [string]$path,

        # Change default branch to specified branch
        [Parameter(HelpMessage='default branch for the project',
                   Mandatory=$false)]
        [string]$default_branch,

        # Short project description
        [Parameter(HelpMessage='short project description',
                   Mandatory=$false)]
        [string]$description,

        # Specify if issues are enabled for this project
        [Parameter(HelpMessage='Are issues enabled for this project',
                   Mandatory=$false)]
        [boolean]$issues_enabled,

        # Specify if Merge Requests are enabled for this project
        [Parameter(HelpMessage='Are Merge Requests enabled for this project',
                   Mandatory=$false)]
        [boolean]$merge_requests_enabled,

        # Specify if builds are enabled for this project
        [Parameter(HelpMessage='Are Builds enabled for this project',
                   Mandatory=$false)]
        [boolean]$builds_enabled,

        # Specify if a wiki is enabled for this project
        [Parameter(HelpMessage='is the wiki enabled for this project',
                   Mandatory=$false)]
        [boolean]$wiki_enabled,

        # Specify if snippets are enabled for this project
        [Parameter(HelpMessage='are snippets enabled for this project',
                   Mandatory=$false)]
        [boolean]$snippets_enabled,

        # Specify if Issues are enabled for this project
        [Parameter(HelpMessage='are issues enabled for this project',
                   Mandatory=$false)]
        [boolean]$container_registry_enabled,

        # Specify if Shared runners are enabled for this project
        [Parameter(HelpMessage='are shared runners enabled for this project',
                   Mandatory=$false)]
        [boolean]$shared_runners_enabled,

        # Specify Project Visibility
        # Private. visibility_level is 0. Project access must be granted explicitly for each user. 
        # Internal. visibility_level is 10. The project can be cloned by any logged in user. 
        # Public. visibility_level is 20. The project can be cloned without any authentication.
        [Parameter(ParameterSetName = 'VisibilityCustom',
                    HelpMessage = "Private. visibility_level is 0. Project access must be granted explicitly for each user. `r`n Internal. visibility_level is 10. The project can be cloned by any logged in user. `r`n Public. visibility_level is 20. The project can be cloned without any authentication.",
                    Mandatory = $false)]
        [validateset(0,10,20)]
        [int]$visibility_level,

        # Is Visibility Public, if true same as setting visibility_level = 20
        [Parameter(ParameterSetName = 'VisibilityPublic',
                    HelpMessage='if true same as setting visibility_level = 20',
                   Mandatory=$false)]
        [switch]$public,

        # Specify if builds are publicly accessible
        [Parameter(HelpMessage='are build public',
                   Mandatory=$false)]
        [boolean]$public_builds,
        
        # URL to import repository from
        [Parameter(HelpMessage='URL to import repository from',
                   Mandatory=$false)]
        [String]$import_url,
        
        # Enables pull mirroring in a project
        [Parameter(HelpMessage='Enables pull mirroring in a project',
                   Mandatory=$false)]
        [boolean]$mirror,
        
        # User responsible for all the activity surrounding a pull mirror event
        [Parameter(HelpMessage='User responsible for all the activity surrounding a pull mirror event',
                   Mandatory=$false)]
        [int]$mirror_user_id,
        
        # Pull mirroring triggers builds
        [Parameter(HelpMessage='Pull mirroring triggers builds',
                   Mandatory=$false)]
        [boolean]$mirror_trigger_builds,
        
        # Only mirror protected branches
        [Parameter(HelpMessage='Only mirror protected branches',
                   Mandatory=$false)]
        [boolean]$only_mirror_protected_branches,
        
        # Pull mirror overwrites diverged branches
        [Parameter(HelpMessage='Pull mirror overwrites diverged branches; note: depending on server version you may need to set this to $null instead of $false!',
                   Mandatory=$false)]
        [boolean]$mirror_overwrites_diverged_branches,

        # Existing GitlabConnector Object, can be retrieved with Get-GitlabConnect
        [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
                Mandatory = $false,
        DontShow = $true)]
        [psobject]$GitlabConnect = (Get-GitlabConnect),

        # Passthru the modified project
        [Parameter(HelpMessage='Passthru the modified project',
                   Mandatory=$false)]
        [switch]$PassThru
    )
    $httpmethod = 'put'
    $apiurl = "projects/$ProjectID"
    $parameters =@{}
    #name
    if($name){
      $parameters.'name' = $name
    }
    #path
    if($path){
      $parameters.path = $path
    }
    #default_branch
    if($default_branch){
      $parameters.'default_branch' = $default_branch
    }
    #description
    if($PSCmdlet.MyInvocation.BoundParameters.keys -contains 'description'){
      if($description){
        $parameters.description = 'true'
      }
      else{
        $parameters.description = 'false'
      }
    }
    #issues_enabled
    if($PSCmdlet.MyInvocation.BoundParameters.keys -contains 'issues_enabled'){
      if($issues_enabled){
        $parameters.issues_enabled = 'true'
      }
      else{
        $parameters.issues_enabled = 'false'
      }
    }
    #merge_requests_enabled
    if($PSCmdlet.MyInvocation.BoundParameters.keys -contains 'merge_requests_enabled'){
      if($merge_requests_enabled){
        $parameters.merge_requests_enabled = 'true'
      }
      else{
        $parameters.merge_requests_enabled = 'false'
      }
    }
    #builds_enabled
    if($PSCmdlet.MyInvocation.BoundParameters.keys -contains 'builds_enabled'){
      if($builds_enabled){
        $parameters.builds_enabled = 'true'
      }
      else{
        $parameters.builds_enabled = 'false'
      }
    }
    #wiki_enabled
    if($PSCmdlet.MyInvocation.BoundParameters.keys -contains 'wiki_enabled'){
      if($wiki_enabled){
        $parameters.wiki_enabled = 'true'
      }
      else{
        $parameters.wiki_enabled = 'false'
      }
    }
    #snippets_enabled
    if($PSCmdlet.MyInvocation.BoundParameters.keys -contains 'snippets_enabled'){
      if($snippets_enabled){
        $parameters.snippets_enabled = 'true'
      }
      else{
        $parameters.snippets_enabled = 'false'
      }
    }
    #container_registry_enabled
    if($PSCmdlet.MyInvocation.BoundParameters.keys -contains 'container_registry_enabled'){
      if($container_registry_enabled){
        $parameters.container_registry_enabled = 'true'
      }
      else{
        $parameters.container_registry_enabled = 'false'
      }
    }
    #shared_runners_enabled
    if($PSCmdlet.MyInvocation.BoundParameters.keys -contains 'shared_runners_enabled'){
      if($shared_runners_enabled){
        $parameters.shared_runners_enabled = 'true'
      }
      else{
        $parameters.shared_runners_enabled = 'false'
      }
    }
    #visibility_level
    if($visibility_level){
      $parameters.'visibility_level' = $visibility_level
    }
    #public
    if($PSCmdlet.MyInvocation.BoundParameters.keys -contains 'public'){
      if($public){
        $parameters.public = 'true'
      }
      else{
        $parameters.public = 'false'
      }
    }
    #public_builds
    if($PSCmdlet.MyInvocation.BoundParameters.keys -contains 'public_builds'){
      if($public_builds){
        $parameters.public_builds = 'true'
      }
      else{
        $parameters.public_builds = 'false'
      }
    }
    
    # import_url
    if ($PSCmdlet.MyInvocation.BoundParameters.keys -contains 'import_url') {
      $parameters.import_url = $import_url
    }
    
    # mirror
    if ($PSCmdlet.MyInvocation.BoundParameters.keys -contains 'mirror') {
      if($mirror){
        $parameters.mirror = 'true'
      }
      else{
        $parameters.mirror = 'false'
      }
    }
    
    # mirror_user_id
    if ($PSCmdlet.MyInvocation.BoundParameters.keys -contains 'mirror_user_id') {
      $parameters.mirror_user_id = $mirror_user_id
    }
    
    # mirror_trigger_builds
    if ($PSCmdlet.MyInvocation.BoundParameters.keys -contains 'mirror_trigger_builds') {
      if($mirror_trigger_builds){
        $parameters.mirror_trigger_builds = 'true'
      }
      else{
        $parameters.mirror_trigger_builds = 'false'
      }
    }
    
    # only_mirror_protected_branches
    if ($PSCmdlet.MyInvocation.BoundParameters.keys -contains 'only_mirror_protected_branches') {
      if($only_mirror_protected_branches){
        $parameters.only_mirror_protected_branches = 'true'
      }
      else{
        $parameters.only_mirror_protected_branches = 'false'
      }
    }

    # mirror_overwrites_diverged_branches
    if ($PSCmdlet.MyInvocation.BoundParameters.keys -contains 'mirror_overwrites_diverged_branches') {
      if($mirror_overwrites_diverged_branches){
        $parameters.mirror_overwrites_diverged_branches = 'true'
      }
      else{
        $parameters.mirror_overwrites_diverged_branches = 'false'
      }
    }


    $newproj = $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)

    if($PassThru){
        return $newproj
    }
    
}