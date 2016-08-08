function New-GitLabProjectRepositoryTag
{
  <#
      .Synopsis
      Creates a new tag in the repository.
      .DESCRIPTION
      Creates a new tag in the repository that points to the supplied ref.
      .Example
  #>
  [CmdletBinding()]
  [Alias()]
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

    #Create tag using commit SHA, another tag name, or branch name
    [Parameter(HelpMessage = 'Source (Commit SHa|tag name|branch name)',
    Mandatory = $true)]
    [alias('ref')]
    [String]$Reference,

    #Specified message for an annotated tag.
    [Parameter(HelpMessage = 'Tag Message',
    Mandatory = $false)]
    [string]$message,

    #Add release notes to the git tag and store it in the GitLab database.
    [Parameter(HelpMessage = 'Release Notes',
    Mandatory = $false)]
    [Alias('release_description')]
    [string]$ReleaseDescription,

    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [psobject]$GitlabConnect = (Get-GitlabConnect),

    [Parameter(HelpMessage = 'Passthru the created project',
    Mandatory = $false)]
    [switch]$PassThru
  )

  $httpmethod = 'post'
  $apiurl = "projects/$ID/repository/tags"
  $parameters = @{
    'tag_name' = $TagName
    'ref'    = $Reference
  }

  if($message)
  {
    $parameters.message = $message
  }

  if($ReleaseDescription)
  {
    $parameters.'release_description' = $ReleaseDescription
  }


  $newtag = $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)

  if($PassThru)
  {
    return $newtag
  }
}
