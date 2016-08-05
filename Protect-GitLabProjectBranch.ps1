function Protect-GitLabProjectBranch
{
  <#
      .Synopsis
      Protects a single project repository branch. 
      .DESCRIPTION
      Protects a single project repository branch. 
      .EXAMPLE
  #>
  [CmdletBinding()]
  [Alias()]
  [OutputType()]
  Param
  (
    #The Id of a project
    [Parameter(HelpMessage = 'The Id of a project',
    Mandatory = $true)]
    [Alias('ProjectID')]
    [int]$ID,

    #The name of the branch
    [Parameter(HelpMessage = 'The name of the branch',
    Mandatory = $true)]
    [String]$Branch,

    #Flag if developers can push to the branch
    [Parameter(HelpMessage = 'Flag if developers can push to the branch',
    Mandatory = $false)]
    [Alias('developers_can_push')]
    [switch]$DevelopersCanPush,

    #Flag if developers can merge to the branch
    [Parameter(HelpMessage = 'Flag if developers can merge to the branch',
    Mandatory = $false)]
    [Alias('developers_can_merge')]
    [switch]$DevelopersCanMerge,

    #Specify Existing GitlabConnector
    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [gitlabconnect]$GitlabConnect = (Get-GitlabConnect),

    [Parameter(HelpMessage = 'Passthru the created project',
    Mandatory = $false)]
    [switch]$PassThru
  )

    
  $httpmethod = 'put'
  $apiurl = "projects/$ID/repository/branches/$Branch/protect"
  $parameters = @{}

  if('DevelopersCanPush' -in $PSCmdlet.MyInvocation.BoundParameters.keys)
  {
    $parameters.'developers_can_push' = [string]$PSCmdlet.MyInvocation.BoundParameters.DevelopersCanPush
  }

  if('DevelopersCanMerge' -in $PSCmdlet.MyInvocation.BoundParameters.keys)
  {
    $parameters.'developers_can_merge' = [string]$PSCmdlet.MyInvocation.BoundParameters.DevelopersCanMerge
  }

  $updatebranch = $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)

  if($PassThru)
  {
    return $updatebranch
  }
}
