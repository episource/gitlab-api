function New-GitLabProjectMilestone
{
  <#
      .Synopsis
      Creates a new project milestone.
      .DESCRIPTION
      Creates a new project milestone for a given project.
      .Example
  #>
  [CmdletBinding()]
  [Alias()]
  [OutputType()]
  Param
  (
    [Parameter(HelpMessage = 'ProjectID',
    Mandatory = $true)]
    [Alias('ProjectID')]
    [int]$ID,

    [Parameter(Helpmessage = 'The title of an milestone', mandatory = $true)]
    [string]$Title,

    [Parameter(Helpmessage = 'The description of the milestone',mandatory= $false)]
    [string]$Description,

    [Parameter(Helpmessage = 'the due date of the milestone',mandatory = $false)]
    [datetime]$dueDate,

    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [psobject]$GitlabConnect = (Get-GitlabConnect)
  )
  
  $httpmethod = 'post'
  $apiurl = "projects/$id/milestones"
  $parameters = @{
    title = $Title
  }

  if($description){
    $parameters.description = $State
  }

  if($dueDate){
    $parameters.'due_date' = $duedate.tostring("yyyy'-'MM'-'dd")
  }

  $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)
}
