function New-GitLabProject
{
    <#
      .SYNOPSIS
      GCreate a new Project
      .DESCRIPTION
      The New-GitLabProject function creates a new project.
      Defaults namespace to current user's namespace and path on name.

      returns new project when -PassThru is specified
      .EXAMPLE
      New-GitLabProject -Name 'GitLab-API'
      ---------------------------------------------------------------
      creates a new project named 'Gitlab-API'
      .EXAMPLE
      New-GitLabProject -Name 'GitLab-API' -PassThru
      ---------------------------------------------------------------
      creates a new project named 'Gitlab-API' and returns the projects object
      .EXAMPLE
      New-GitLabProject -Name 'GitLab-API' -container_registry_enabled $true
      ---------------------------------------------------------------
      Creates a new project named 'Gitlab-API' with container Registry enabled.
    #>
    [CmdletBinding(DefaultParameterSetName='VisibilityCustom')]
    [Alias()]
    [OutputType()]
    Param
    (
        #The Name of the new project
        [Parameter(HelpMessage='new project name',
                   Mandatory=$true)]
        [string]$Name,

        #custom repository name for new project. By default generated based on name
        [Parameter(HelpMessage='custom repository name for new project. By default generated based on name',
                   Mandatory=$false)]
        [string]$path,

        #namespace for the new project (defaults to user)
        [Parameter(HelpMessage='namespace for the new project (defaults to user)',
                   Mandatory=$false)]
        [int]$namespace_id,

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
        [Alias("builds_enabled")]
        [boolean]$jobs_enabled,

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

        # Sepecify Import URL, used to import a project from an external repository.
        [Parameter(HelpMessage='use an import url to import the project',
                   Mandatory=$false)]
        [string]$import_url,
        
        # Enables pull mirroring in a project
        [Parameter(HelpMessage='Enables pull mirroring in a project',
                   Mandatory=$false)]
        [boolean]$mirror,
        
        # Pull mirroring triggers builds
        [Parameter(HelpMessage='Pull mirroring triggers builds',
                   Mandatory=$false)]
        [boolean]$mirror_trigger_builds,

        # Specify if builds are publicly accessible
        [Parameter(HelpMessage='are build public',
                   Mandatory=$false)]
        [boolean]$public_builds,

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
    $apiurl = 'projects'
    $parameters = @{}
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
        $parameters.description = $description
    }
    #namespace
    if($PSCmdlet.MyInvocation.BoundParameters.keys -contains 'namespace_id'){
        $parameters.namespace_id = $namespace_id
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
    if($PSCmdlet.MyInvocation.BoundParameters.keys -contains 'jobs_enabled'){
      if($builds_enabled){
        $parameters.jobs_enabled = 'true'
      }
      else{
        $parameters.jobs_enabled = 'false'
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
    if ($PSCmdlet.MyInvocation.BoundParameters.keys -contains 'mirror') {
        $parameters.mirror = "$mirror".ToLower()
    }
    if ($PSCmdlet.MyInvocation.BoundParameters.keys -contains 'mirror_trigger_builds') {
        $parameters.mirror_trigger_builds = "$mirror_trigger_builds".ToLower()
    }

    $newproj = $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)

    if($PassThru){
        return $newproj
    }
    
}