function Get-GitLabProject
{
    <#
      .SYNOPSIS
      Gets Gitlab projects
      .DESCRIPTION
      The Get-GitlabProject function returns one or more projects specified.
      By default this function returns all projects that the authenticated user is authorized for.
      By passing -Starred or -Owned only starred or owned projects are returned.
      By passing -Archived or -Visibility ('public','internal','private') results can be further narrowed.

      if you have the ID of a project you can specify the projectID by passing $ProjectID
      .EXAMPLE
      Get-GitLabProject
      ---------------------------------------------------------------
      Returns all projects that the authenticated user is authorized for.
      .EXAMPLE
      Get-GitLabProject -ProjectID 20
      ---------------------------------------------------------------
      Return Project with ID 20
      .EXAMPLE
      Get-GitLabProject -archived
      ---------------------------------------------------------------
      Only Return Archived Projects
    #>
    [CmdletBinding(DefaultparametersetName = 'AllProjects')]
    [Alias()]
    [OutputType()]
    Param
    (
        # Limit the result by Archived status
        [Parameter(ParameterSetName = 'AllProjects',
                HelpMessage = 'limit by archived status',
        Mandatory = $false)]
        [Parameter(ParameterSetName = 'AllProjectsOwned',
                HelpMessage = 'limit by archived status',
        Mandatory = $false)]
        [Parameter(ParameterSetName = 'AllProjectsStarred',
                HelpMessage = 'limit by archived status',
        Mandatory = $false)]
        [switch]$Archived,

        # Search for a project.
        [Parameter(ParameterSetName = 'AllProjects',
                HelpMessage = 'Search for a project.',
        Mandatory = $false)]
        [Parameter(ParameterSetName = 'AllProjectsOwned',
                HelpMessage = 'Search for a project.',
        Mandatory = $false)]
        [Parameter(ParameterSetName = 'AllProjectsStarred',
                HelpMessage = 'Search for a project.',
        Mandatory = $false)]
        [string]$Search,

        # Limit the result by visibility
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
        [switch]$Visibility,

        # Limit the result by Starred status
        [Parameter(ParameterSetName = 'AllProjectsStarred',
                HelpMessage = 'limit by starred status',
        Mandatory = $true)]
        [switch]$Starred,

        # Limit the result by Owned status
        [Parameter(ParameterSetName = 'AllProjectsOwned',
                HelpMessage = 'limit by owned status',
        Mandatory = $true)]
        [switch]$Owned,

        # The ID of the project
        [Parameter(ParameterSetName = 'SingleProject',
                HelpMessage = 'The ID of a project',
        Mandatory = $true)]
    [Alias('ID')]
    [int]$ProjectID,

        # Existing GitlabConnector Object, can be retrieved with Get-GitlabConnect
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
        if($search){
            $parameters.search=$search
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
        $apiurl += "/$ProjectID"
    }

    $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)
}
