function New-GitLabProjectRepositoryTag
{
  <#
      .SYNOPSIS
      Create a new tag for the repository.
      .DESCRIPTION
      The New-GitLabProjectRepositoryTag function adds a new tag to a repository.
      Creates a annotated tag if -Message is passed.

      Return the created tag using -PassThru
      .EXAMPLE
      New-GitLabProjectRepositoryTag -ProjectID 20 -TagName 'v1.0.0' -Reference 5a411e1
      ---------------------------------------------------------------
      Creates new tag labeld 'v1.0.0' on commit 5a411e1
      .EXAMPLE
      New-GitLabProjectRepositoryTag -ProjectID 20 -TagName 'v1.0.0' -Reference 5a411e1 -PassThru
      ---------------------------------------------------------------
      Creates new tag labeld 'v1.0.0' on commit 5a411e1
  #>
  [CmdletBinding()]
  [Alias()]
  [OutputType()]
  Param
  (
    # The ID of the project
    [Parameter(
        HelpMessage = 'ProjectID',
    Mandatory = $true)]
    [Alias('ProjectID')]
    [string]$ID,

    # The name of the tag
    [Parameter(HelpMessage = 'Tag Name',
    Mandatory = $true)]
    [Alias('Tag','tag_name')]
    [string]$TagName,

    # Create tag using commit SHA, another tag name, or branch name.
    [Parameter(HelpMessage = 'Source (Commit SHA|tag name|branch name)',
    Mandatory = $true)]
    [alias('ref')]
    [String]$Reference,

    # Create an annotated tag with specified message.
    [Parameter(HelpMessage = 'Tag Message',
    Mandatory = $false)]
    [string]$Message,

    # Add release notes to the tag.
    [Parameter(HelpMessage = 'Release Notes',
    Mandatory = $false)]
    [Alias('release_description')]
    [string]$ReleaseDescription,

    # Specify Existing GitlabConnector
    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [psobject]$GitlabConnect = (Get-GitlabConnect),

    # Return the created tag
    [Parameter(HelpMessage = 'Passthru the created tag',
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
