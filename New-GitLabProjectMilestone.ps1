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
    [psobject]$GitlabConnect = (Get-GitlabConnect),

        [Parameter(HelpMessage='Passthru the created project',
                   Mandatory=$false)]
        [switch]$PassThru
  )
  
  $httpmethod = 'post'
  $apiurl = "projects/$id/milestones"
  $parameters = @{
    title = $Title
  }

  if($description){
    $parameters.description = $description
  }

  if($dueDate){
    $parameters.'due_date' = $duedate.tostring("yyyy'-'MM'-'dd")
  }

  $newmilestone = $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)

  if($PassThru){
        return $newmilestone
    }
}
