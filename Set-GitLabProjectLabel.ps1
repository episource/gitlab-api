function Set-GitLabProjectLabel
{
  <#
      .SYNOPSIS
      Updates an existing label
      .DESCRIPTION
      The Set-GitLabProjectLabel function updates an existing label with new name or new color.
      When -PassThru is specified the modified label is returned.
      .EXAMPLE
      Set-GitLabProjectLabel -ProjectID 20 -Name 'Type:Bug' -NewName 'Type:Error'
      ---------------------------------------------------------------
      Renames the label 'Type:Bug' to 'Type:Error'
      .EXAMPLE
      Set-GitLabProjectLabel -ProjectID 20 -Name 'Type:Bug' -Color #FFFFFF
      ---------------------------------------------------------------
      Sets the color of the label 'Type:Bug' to #FFFFFF
  #>
  [CmdletBinding(DefaultParameterSetName = 'NewColor')]
  [Alias()]
  [OutputType()]
  Param
  (
    # The ID of the project
    [Parameter(HelpMessage = 'ProjectID',
    Mandatory = $true)]
    [Alias('ProjectID')]
    [int]$ID,

    # The name of the label
    [Parameter(HelpMessage = 'Label Name',
    Mandatory = $true)]
    [Alias()]
    [string]$Name,

    # The new name of the label
    [Parameter(ParameterSetName = 'NewColor',
        HelpMessage = 'New Label Name',
    Mandatory = $false)]
    [Parameter(ParameterSetName = 'NewName',
        HelpMessage = 'New Label Name',
    Mandatory = $true)]
    [Alias()]
    [string]$NewName,

    # The new color of the label
    [Parameter(ParameterSetName = 'NewColor',
        HelpMessage = 'Label Color Hex notation (#000000)',
    Mandatory = $true)]
    [Parameter(ParameterSetName = 'NewName',
        HelpMessage = 'Label Color Hex notation (#000000)',
    Mandatory = $false)]
    [Alias('HEXColor')]
    [ValidatePattern('^#[A-Fa-f0-9]{6}$')]
    [string]$Color,

    # Set the label description
    [Parameter(HelpMessage = 'Label Description',
    Mandatory = $false)]
    [Alias()]
    [string]$description,

    # Existing GitlabConnector Object, can be retrieved with Get-GitlabConnect
    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [psobject]$GitlabConnect = (Get-GitlabConnect),

    # Passthru the modified label
    [Parameter(HelpMessage = 'Passthru modified Label',
    Mandatory = $false)]
    [switch]$PassThru
  
  )
  
  $httpmethod = 'put'
  $apiurl = "projects/$ID/labels"
  $parameters = @{
    id   = $ID
    name = $Name
  }

  if($NewName)
  {
    $parameters.'new_name' = $NewName
  }

  if($Color)
  {
    $parameters.color = $Color
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
