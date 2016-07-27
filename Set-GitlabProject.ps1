function Set-GitlabProject
{
    <#
    .Synopsis
        Sets a gitlabproject
    #>
    [CmdletBinding(DefaultParameterSetName='VisibilityCustom')]
    [Alias()]
    [OutputType()]
    Param
    (
        [Parameter(HelpMessage='new project name',
                   Mandatory=$true)]
        [string]$id,
        [Parameter(HelpMessage='new project name',
                   Mandatory=$false)]
        [string]$name,

        [Parameter(HelpMessage='custom repository name for new project. By default generated based on name',
                   Mandatory=$false)]
        [string]$path,

        [Parameter(HelpMessage='default branch for teh project',
                   Mandatory=$false)]
        [int]$default_branch,

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
    $httpmethod = 'put'
    $apiurl = "projects/$id"
    $parameters = @{}
    $boundparameters = $PSCmdlet.MyInvocation.BoundParameters.keys.where({-not ($_ -in 'GitLabConnect','PassThru')})
    foreach($boundparameter in $boundparameters){
        $parameters.$boundparameter = [string]$PSCmdlet.MyInvocation.BoundParameters.$boundparameter
    }

    $newproj = $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)

    if($PassThru){
        return $newproj
    }
    
}