function New-GitlabProject
{
    <#
    .Synopsis
        Creates new project in gitlab
    #>
    [CmdletBinding(DefaultParameterSetName='VisibilityCustom')]
    [Alias()]
    [OutputType()]
    Param
    (
        [Parameter(HelpMessage='new project name',
                   Mandatory=$true)]
        [string]$name,

        [Parameter(HelpMessage='custom repository name for new project. By default generated based on name',
                   Mandatory=$false)]
        [string]$path,

        [Parameter(HelpMessage='namespace for the new project (defaults to user)',
                   Mandatory=$false)]
        [int]$namespace_id,

        [Parameter(HelpMessage='short project description',
                   Mandatory=$false)]
        [string]$description,

        [Parameter(HelpMessage='Are issues enabled for this project',
                   Mandatory=$false)]
        [boolean]$issues_enabled,

        [Parameter(HelpMessage='Are Merge Requests enabled for this project',
                   Mandatory=$false)]
        [boolean]$merge_requests_enabled,

        [Parameter(HelpMessage='Are Builds enabled for this project',
                   Mandatory=$false)]
        [boolean]$builds_enabled,

        [Parameter(HelpMessage='is the wiki enabled for this project',
                   Mandatory=$false)]
        [boolean]$wiki_enabled,

        [Parameter(HelpMessage='are snippets enabled for this project',
                   Mandatory=$false)]
        [boolean]$snippets_enabled,

        [Parameter(HelpMessage='are issues enabled for this project',
                   Mandatory=$false)]
        [boolean]$container_registry_enabled,

        [Parameter(HelpMessage='are shared runners enabled for this project',
                   Mandatory=$false)]
        [boolean]$shared_runners_enabled,

        [Parameter(ParameterSetName = 'VisibilityCustom',
                    HelpMessage = "Private. visibility_level is 0. Project access must be granted explicitly for each user. `r`n Internal. visibility_level is 10. The project can be cloned by any logged in user. `r`n Public. visibility_level is 20. The project can be cloned without any authentication.",
                    Mandatory = $false)]
        [validateset(0,10,20)]
        [int]$visibility_level,

        [Parameter(ParameterSetName = 'VisibilityPublic',
                    HelpMessage='if true same as setting visibility_level = 20',
                   Mandatory=$false)]
        [switch]$public,

        [Parameter(HelpMessage='use an import url to import the project',
                   Mandatory=$false)]
        [string]$import_url,

        [Parameter(HelpMessage='are build public',
                   Mandatory=$false)]
        [boolean]$public_builds,

        [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
                Mandatory = $false,
        DontShow = $true)]
        [psobject]$GitlabConnect = (Get-GitlabConnect),

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

    $newproj = $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)

    if($PassThru){
        return $newproj
    }
    
}