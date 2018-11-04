function Get-GitLabGroup {
    <#
      .SYNOPSIS
      Gets Gitlab groups.
      .DESCRIPTION
      The Get-GitLabGroup function returns one or more projects specified.
      By default this function returns all groups.
      By passing -Accessable or -Owned only accessable or owned groups are retrieved.
      By passing -OnlyRoot only top level groups are returned.

      if you have the ID of a group you can specify the group ID by passing -GroupId.
      .EXAMPLE
      Get-GitLabGroup
      ---------------------------------------------------------------
      Returns all groups that are available.
      .EXAMPLE
      Get-GitLabGroup -GroupID 20
      ---------------------------------------------------------------
      Return Group with ID 20
    #>
    [CmdletBinding(DefaultparametersetName = 'AllGroups')]
    [Alias()]
    [OutputType()]
    Param (
        # Search for a project.
        [Parameter(ParameterSetName = 'AllGroups',
                HelpMessage = 'Search for a group.',
                Mandatory = $false)]
        [string]$Search,
        
        # Limit the result by Owned status
        [Parameter(ParameterSetName = 'AllGroups',
                HelpMessage = 'limit by accessability; defautls to $false for admins, $true for other users',
                Mandatory = $false)]
        [switch]$Accessable,

        # Limit the result by Owned status
        [Parameter(ParameterSetName = 'AllGroups',
                HelpMessage = 'limit by owned status',
                Mandatory = $false)]
        [switch]$Owned,
        
        # Limit the result to root groups
        [Parameter(ParameterSetName = 'AllGroups',
                HelpMessage = 'limit to root level groups',
                Mandatory = $false)]
        [switch]$OnlyRoot,
        
        # Limit the result to root groups
        [Parameter(ParameterSetName = 'AllGroups',
                HelpMessage = 'also list detailed group information as if querying a single group (slower)',
                Mandatory = $false)]
        [switch]$Details = $false,

        # The ID of the project
        [Parameter(ParameterSetName = 'SingleGroup',
                HelpMessage = 'The ID of a group',
                Mandatory = $true)]
        [Alias('ID')]
        [int]$GroupId,

        # Existing GitlabConnector Object, can be retrieved with Get-GitlabConnect
        [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
                Mandatory = $false,
                DontShow = $true)]
        [psobject]$GitlabConnect = (Get-GitlabConnect)
    )

    $httpmethod = 'get'
    $apiurl = 'groups'
    $parameters = @{}

    if($PSCmdlet.ParameterSetName -like 'AllGroups*') {
        if($PSCmdlet.MyInvocation.BoundParameters.keys -contains 'Accessable'){
            $parameters.all_available = "$(-not $accessable)".ToLower()
        }
        if($PSCmdlet.MyInvocation.BoundParameters.keys -contains 'Owned'){
            $parameters.visibility = "$Owned".ToLower();
        }
        if($PSCmdlet.MyInvocation.BoundParameters.keys -contains 'Search'){
            $parameters.search=$search
        }
    }
    
    if($PSCmdlet.ParameterSetName -eq 'SingleGroup')
    {
        $apiurl += "/$GroupId"
    }

    if ($details) {
        $GitlabConnect.callapi($apiurl,$httpmethod,$parameters) `
            | %{ Get-GitLabGroup -GroupId $_.id }
    } else {
        $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)
    }
}
