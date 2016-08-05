function New-GitLabProjectBranch
{
    <#
.Synopsis
   Create a Repository Branch
.DESCRIPTION
   Create a Repository branch for specified project from specified reference. Reference can be passed as Sha or BranchName
.EXAMPLE
   Example of how to use this cmdlet
#>[CmdletBinding(DefaultParameterSetName='FromBranch')]
  [Alias()]
  [OutputType()]
  Param
  (
    [Parameter(HelpMessage = 'The Id of a project',
    Mandatory = $true)]
    [Alias('ProjectID')]
    [int]$ID,

    [Parameter(HelpMessage = 'The name of the branch',
    Mandatory = $true)]
    [Alias('branch_name','BranchName')]
    [String]$Name,

    [Parameter(ParameterSetName = 'FromBranch',
      HelpMessage = 'The branch Name to create branch from.',
      Mandatory=$true)]
    [String]$SourceBranch,

    [Parameter(ParameterSetName = 'FromSHA',
      HelpMessage = 'The commit SHA to create branch from.',
      Mandatory=$true)]
    [String]$SourceSHA,

    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [gitlabconnect]$GitlabConnect = (Get-GitlabConnect),

    [Parameter(HelpMessage = 'Passthru the created project',
    Mandatory = $false)]
    [switch]$PassThru
  )

  $httpmethod = 'post'
  $apiurl = "projects/$ID/repository/branches/"
  $parameters = @{
    'branch_name' = $Name
  }

  if($PSCmdlet.ParameterSetName -like 'FromBranch'){
    $parameters.ref = $SourceBranch
  }

  if($PSCmdlet.ParameterSetName -like 'FromSHA'){
    $parameters.ref = $SourceSHA
  }

  $newbranch = $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)

  if($PassThru)
  {
    return $newbranch
  }
}