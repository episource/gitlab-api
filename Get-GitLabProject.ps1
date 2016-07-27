function Get-GitLabProject
{
    <#
            .Synopsis
            gets gitlabprojects. to select single object use -id
    #>
    [CmdletBinding(DefaultparametersetName = 'AllProjects')]
    [Alias()]
    [OutputType()]
    Param
    (
        [Parameter(ParameterSetName = 'AllProjects',
                HelpMessage = 'limit by archived status',
        Mandatory = $false)]
        [Parameter(ParameterSetName = 'AllProjectsOwned',
                HelpMessage = 'limit by archived status',
        Mandatory = $false)]
        [Parameter(ParameterSetName = 'AllProjectsStarred',
                HelpMessage = 'limit by archived status',
        Mandatory = $false)]
        [switch]$archived,

        [Parameter(ParameterSetName = 'AllProjects',
                HelpMessage = 'limit by visibility public, internal, private',
        Mandatory = $false)]
        [Parameter(ParameterSetName = 'AllProjectsOwned',
                HelpMessage = 'limit by visibility public, internal, private',
        Mandatory = $false)]
        [Parameter(ParameterSetName = 'AllProjectsStarred',
                HelpMessage = 'limit by visibility public, internal, private',
        Mandatory = $false)]
        [validateset('public','internal','private')]
        [switch]$visibility,

        [Parameter(ParameterSetName = 'AllProjectsStarred',
                HelpMessage = 'limit by archived status',
        Mandatory = $true)]
        [switch]$starred,

        [Parameter(ParameterSetName = 'AllProjectsOwned',
                HelpMessage = 'limit by archived status',
        Mandatory = $true)]
        [switch]$owned,

        [Parameter(ParameterSetName = 'SingleProject',
                HelpMessage = 'The ID or NAMESPACE/PROJECT_NAME of a project',
        Mandatory = $true)]
        [int]$id,

        [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
                Mandatory = $false,
        DontShow = $true)]
        [psobject]$GitlabConnect = (Get-GitlabConnect)
    )

    $httpmethod = 'get'
    $apiurl = 'projects'
    $parameters = @{}

    if($PSCmdlet.ParameterSetName -like 'AllProjects*')
    {
        if($archived)
        {
            $parameters.archived = 'true'
        }
        if($visibility)
        {
            $parameters.visibility = $visibility
        }
        if($starred)
        {
            $apiurl += '/starred'
        }
        if($owned)
        {
            $apiurl += '/owned'
        }
    }
    
    if($PSCmdlet.ParameterSetName -eq 'SingleProject')
    {
        $apiurl += "/$id"
    }

    $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)
}
