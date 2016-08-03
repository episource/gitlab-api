function New-GitLabProjectLabel
{
  <#
      .Synopsis
      creates a new label
      .DESCRIPTION
      Creates a new label for the given project with the given name and color.
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
    [int]$id,

    [Parameter(HelpMessage = 'Label Name',
    Mandatory = $true)]
    [Alias()]
    [string]$name,

    [Parameter(HelpMessage = 'Label Color Hex notation (#000000)',
    Mandatory = $false)]
        [Alias('HEXColor')]
    [ValidatePattern('^#[A-Fa-f0-9]{6}$')]
    [string]$Color = '#428bca',

    [Parameter(HelpMessage = 'Label Description',
    Mandatory = $false)]
    [Alias()]
    [string]$description,

    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [psobject]$GitlabConnect = (Get-GitlabConnect),

    

        [Parameter(HelpMessage='Passthru the created project',
                   Mandatory=$false)]
        [switch]$PassThru
  
  )
  
  $httpmethod = 'post'
  $apiurl = "projects/$id/labels"
  $parameters = @{
    id = $id
    name = $name
    color = $color
    }

  if($description){
    $parameters.description = $description
  }

  $newlabel = $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)

  if($PassThru){
    return $newlabel
  }
}