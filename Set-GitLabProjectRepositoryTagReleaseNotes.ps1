function Set-GitLabProjectRepositoryTagReleaseNotes
{
  <#
      .SYNOPSIS
      Sets release notes on an existing tag
      .DESCRIPTION
      The Set-GitLabProjectRepositoryTagReleaseNotes function updates sets release notes on a current tag.
      If no release notes are set creates a release for the specified branch.

      use -PassThru to return the modified Tag 
      .EXAMPLE
      Set-GitLabProjectRepositoryTagReleaseNotes -ProjectID 20 -TagName 'v1.0.0' -ReleaseDescription 'Release v1.0.0'
      ---------------------------------------------------------------
      Sets a release on tag 'v1.0.0' named 'Release v1.0.0'
      if the release existed beforehand the Release description is overwritten.
  #>
  [CmdletBinding()]
  [Alias('Set-GitLabProjectRepositoryTag')]
  [OutputType()]
  Param
  (
    #The ID of a project
    [Parameter(
        HelpMessage = 'ProjectID',
    Mandatory = $true)]
    [Alias('ID')]
    [int]$ProjectID,

    #The name of the tag
    [Parameter(HelpMessage = 'Tag Name',
    Mandatory = $true)]
    [Alias('Tag','tag_name')]
    [string]$TagName,

    # Set Releas Notes for the tag 
    [Parameter(HelpMessage = 'Release Notes',
    Mandatory = $true)]
    [Alias('release_description','description')]
    [string]$ReleaseDescription,

    # Specify Existing GitlabConnector
    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [psobject]$GitlabConnect = (Get-GitlabConnect),

    # Return the modified tag.
    [Parameter(HelpMessage = 'Passthru the created project',
    Mandatory = $false)]
    [switch]$PassThru
  )

  
  $apiurl = "projects/$ID/repository/tags/$TagName/release"
  $parameters = @{
    description = $ReleaseDescription
  }
  
  try
  {
    $currenttag = Get-GitLabProjectRepositoryTag -id $ID -TagName $TagName -GitlabConnect $GitlabConnect

    if($currenttag.release)
    {
      $httpmethod = 'Put'
    }
    else
    {
      $httpmethod = 'Post'
    }


    $updatedtag = $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)

    if($PassThru)
    {
      return $updatedtag
    }
  }
  catch
  {
    Write-Error $_
  }
}
