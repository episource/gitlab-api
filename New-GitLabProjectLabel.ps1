function New-GitLabProjectLabel
{
  <#
      .SYNOPSIS
      Create a new label in a project.
      .DESCRIPTION
      The New-GitLabProjectLabel function creates a new label.
      A label color can be passed using -Color #xxxxxx
      .EXAMPLE
      New-GitLabProjectLabel -ProjectID 20 -Name 'To Do'
      ---------------------------------------------------------------
      Creates a New label named 'To Do' in project 20.
      .EXAMPLE
      New-GitLabProjectLabel -ProjectID 20 -Name 'To Do' -PassThru
      ---------------------------------------------------------------
      Creates a New label named 'To Do' in project 20.
      Returns the created Label.
  #>
  [CmdletBinding()]
  [Alias()]
  [OutputType()]
  Param
  (
    # The ID of the project
    [Parameter(HelpMessage = 'ProjectID',
    Mandatory = $true)]
    [Alias('ProjectID')]
    [int]$id,

    # The Label Name
    [Parameter(HelpMessage = 'Label Name',
    Mandatory = $true)]
    [Alias()]
    [string]$Name,

    # The label color HEX Notation
    [Parameter(HelpMessage = 'Label Color Hex notation (#000000)',
    Mandatory = $false)]
    [Alias('HEXColor')]
    [ValidatePattern('^#[A-Fa-f0-9]{6}$')]
    [string]$Color = '#428bca',

    # Description for the label
    [Parameter(HelpMessage = 'Label Description',
    Mandatory = $false)]
    [Alias()]
    [string]$description,

    # Specify Existing GitlabConnector
    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [psobject]$GitlabConnect = (Get-GitlabConnect),

    # Passthru the created label
    [Parameter(HelpMessage = 'Passthru the created label',
    Mandatory = $false)]
    [switch]$PassThru
  
  )
  
  $httpmethod = 'post'
  $apiurl = "projects/$id/labels"
  $parameters = @{
    id    = $id
    name  = $name
    color = $Color
  }

  if($description)
  {
    $parameters.description = $description
  }

  $newlabel = $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)

  if($PassThru)
  {
    return $newlabel
  }
}
