function Get-GitLabProjectBranch
{
  <#
      .Synopsis
      Get a list of repository branches from a project
      .DESCRIPTION
      Get a list of repository branches from a project
      .EXAMPLE
  #>
  [CmdletBinding(DefaultParameterSetName = 'AllBranches')]
  [Alias()]
  [OutputType()]
  Param
  (
    #
    [Parameter(HelpMessage = 'The Id of a project',
    Mandatory = $true)]
    [Alias('ProjectID')]
    [int]$ID,

    #The name of the branch
    [Parameter(ParameterSetName = 'SingleBranch',
        HelpMessage = 'The name of the branch',
    Mandatory = $true)]
    [String]$Branch,

    #Specify Existing GitlabConnector
    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [psobject]$GitlabConnect = (Get-GitlabConnect)
  )

  $httpmethod = 'get'
  $apiurl = "projects/$ID/repository/branches"
  $parameters = @{}

  if($PSCmdlet.ParameterSetName -like 'AllBranches')
  {
    #no extra action required
  }
  if($PSCmdlet.ParameterSetName -like 'SingleBranch')
  {
    $apiurl += "\$Branch"
  }

  $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)
}
