function Set-GitLabProjectLabel
{
  <#
      .Synopsis
      Updates an existing label
      .DESCRIPTION
      Updates an existing label with new name or new color. At least one parameter is required, to update the label.
      .Example
  #>
  [CmdletBinding(DefaultParameterSetName='NewColor')]
  [Alias()]
  [OutputType()]
  Param
  (
    [Parameter(HelpMessage = 'ProjectID',
    Mandatory = $true)]
    [Alias('ProjectID')]
    [int]$ID,

    [Parameter(HelpMessage = 'Label Name',
    Mandatory = $true)]
    [Alias()]
    [string]$Name,

    [Parameter(ParameterSetName='NewColor',
    HelpMessage = 'New Label Name',
    Mandatory = $false)]
    [Parameter(ParameterSetName='NewName',
    HelpMessage = 'New Label Name',
    Mandatory = $true)]
    [Alias()]
    [string]$NewName,

    [Parameter(ParameterSetName='NewColor',
    HelpMessage = 'Label Color Hex notation (#000000)',
    Mandatory = $true)]
    [Parameter(ParameterSetName='NewName',
    HelpMessage = 'Label Color Hex notation (#000000)',
    Mandatory = $false)]
        [Alias('HEXColor')]
    [ValidatePattern('^#[A-Fa-f0-9]{6}$')]
    [string]$Color,

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
  
  $httpmethod = 'put'
  $apiurl = "projects/$id/labels"
  $parameters = @{
    id = $id
    name = $name
    }

  if($NewName){
    $parameters.'new_name' = $NewName
  }

  if($color){
    $parameters.color = $color
  }

  if($description){
    $parameters.description = $description
  }

  $newlabel = $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)

  if($PassThru){
    return $newlabel
  }
}