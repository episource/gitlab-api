function Set-GitLabProjectRepositoryTagReleaseNotes
{
  <#
      .Synopsis
      Sets release notes of the existing git tag
      .DESCRIPTION
      Sets release notes of the existing git tag
      .Example
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
    [Alias('ProjectID')]
    [string]$ID,

    #The name of the tag
    [Parameter(HelpMessage = 'Tag Name',
    Mandatory = $true)]
    [Alias('Tag','tag_name')]
    [string]$TagName,

    #Add release notes to the git tag and store it in the GitLab database.
    [Parameter(HelpMessage='Release Notes',
    Mandatory=$true)]
    [Alias('release_description','description')]
    [string]$ReleaseDescription,

    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [psobject]$GitlabConnect = (Get-GitlabConnect),

    [Parameter(HelpMessage = 'Passthru the created project',
    Mandatory = $false)]
    [switch]$PassThru
    
  )

  
  $apiurl = "projects/$ID/repository/tags/$TagName/release"
  $parameters = @{
    description = $ReleaseDescription
  }
  
  try{
    $currenttag = Get-GitLabProjectRepositoryTag -id $id -TagName $TagName -GitlabConnect $GitlabConnect

    if($currenttag.release){
      $httpmethod = 'Put'
    }else{
      $httpmethod = 'Post'
    }


    $updatedtag = $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)

    if($PassThru)
    {
    
      return $updatedtag
    }
    }
  catch{
    write-error $_
  }
}