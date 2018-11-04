function Get-GitLabNamespace {
    <#
      .SYNOPSIS
      Gets Gitlab namespaces.
      .DESCRIPTION
      The Get-GitLabNamespace function returns one or more namespaces.
      By default this function returns all namespaces.

      if you have the ID of a namespace you can also query a single namespace.
      .EXAMPLE
      Get-GitLabGroup
      ---------------------------------------------------------------
      Returns all groups that are available.
      .EXAMPLE
      Get-GitLabGroup -GroupID 20
      ---------------------------------------------------------------
      Return Group with ID 20
    #>
    [CmdletBinding(DefaultparametersetName = 'AllNamespaces')]
    [Alias()]
    [OutputType()]
    Param (
        # Search for a project.
        [Parameter(ParameterSetName = 'AllNamespaces',
                HelpMessage = 'Search for a namespace.',
                Mandatory = $false)]
        [string]$Search,        

        # The ID of the project
        [Parameter(ParameterSetName = 'SingleNamespace',
                HelpMessage = 'The ID of a namespace',
                Mandatory = $true)]
        [Alias('ID')]
        [String]$NamespaceId,

        # Existing GitlabConnector Object, can be retrieved with Get-GitlabConnect
        [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
                Mandatory = $false,
                DontShow = $true)]
        [psobject]$GitlabConnect = (Get-GitlabConnect)
    )
    
    $httpmethod = 'get'
    $apiurl = 'namespaces'
    $parameters = @{}

    if($PSCmdlet.ParameterSetName -like 'AllNamespaces*') {
        if($PSCmdlet.MyInvocation.BoundParameters.keys -contains 'Search'){
            $parameters.search=$search
        }
    }
    
    if($PSCmdlet.ParameterSetName -like 'SingleNamespace*')
    {
        $apiurl += "/$([System.Web.HttpUtility]::UrlEncode($namespaceId))"
    }

    $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)
}
