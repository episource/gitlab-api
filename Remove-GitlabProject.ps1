function Remove-GitlabProject
{
    <#
    .Synopsis
        Sets a gitlabproject
    #>
    [CmdletBinding(ConfirmImpact='High')]
    [Alias()]
    [OutputType()]
    Param
    (
        [Parameter(HelpMessage='new project name',
                   Mandatory=$true)]
        [string]$id,
        [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
                Mandatory = $false,
        DontShow = $true)]
        [psobject]$GitlabConnect = (Get-GitlabConnect)
    )
    $httpmethod = 'delete'
    $apiurl = "projects/$id"
    $parameters = @{}

    $newproj = $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)
    
}