function New-GitLabProjectBranch
{
  <#
      .SYNOPSIS
      Create a new branch in a projects repository.
      .DESCRIPTION
      The New-GitLabProjectBranch function creates a new branch in the repository.
      The source branch can be specified via sha or commit.
      .EXAMPLE
      New-GitLabProjectBranch -ProjectID 20 -Name staging -SourceBranch master
      ---------------------------------------------------------------
      Creates a new branch named staging from master in project 20
      .EXAMPLE
      New-GitLabProjectBranch -ProjectID 20 -Name staging -SourceSHA 5a411e1
      ---------------------------------------------------------------
      Creates a new branch named staging from commit 5a411e1 in project 20
  #>
  [CmdletBinding(DefaultParameterSetName = 'FromBranch')]
  [Alias()]
  [OutputType()]
  Param
  (
    # The Id of the project
    [Parameter(HelpMessage = 'The Id of a project',
    Mandatory = $true)]
    [Alias('ID')]
    [int]$ProjectID,

    # The name of the branch new branch
    [Parameter(HelpMessage = 'The name of the branch',
    Mandatory = $true)]
    [Alias('branch_name','BranchName')]
    [String]$Name,

    # The branch Name to create branch from.
    [Parameter(ParameterSetName = 'FromBranch',
        HelpMessage = 'The branch Name to create branch from.',
    Mandatory = $true)]
    [String]$SourceBranch,

    # The commit SHA to create branch from.
    [Parameter(ParameterSetName = 'FromSHA',
        HelpMessage = 'The commit SHA to create branch from.',
    Mandatory = $true)]
    [String]$SourceSHA,

    # Specify Existing GitlabConnector
    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [gitlabconnect]$GitlabConnect = (Get-GitlabConnect),

    # Passthru the created Branch
    [Parameter(HelpMessage = 'Passthru the created project',
    Mandatory = $false)]
    [switch]$PassThru
  )

  $httpmethod = 'post'
  $apiurl = "projects/$ProjectID/repository/branches/"
  $parameters = @{
    'branch_name' = $Name
  }

  if($PSCmdlet.ParameterSetName -like 'FromBranch')
  {
    $parameters.ref = $SourceBranch
  }

  if($PSCmdlet.ParameterSetName -like 'FromSHA')
  {
    $parameters.ref = $SourceSHA
  }

  $newbranch = $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)

  if($PassThru)
  {
    return $newbranch
  }
}
