function Get-GitLabProjectIssue
{
  <#
      .SYNOPSIS
      Gets GitLab Project Issue.
      .DESCRIPTION
      Gets GitLab Project Issue. Gets all Issues by Default.
      All issues can be filtered by:
         -State (opened:closed)
         -Labels (comma seperated labels)
         -Milestone (assigned Milestone)

      If IssueID is passed only specified issue is retured.
      .EXAMPLE
      Get-GitLabProjectIssue -ProjectID 20
      ---------------------------------------------------------------
      Gets all issues for project 20
      .EXAMPLE
      Get-GitLabProjectIssue -ProjectID 20 -IssueID 1
      ---------------------------------------------------------------
      Gets issue 1 for project 20
      .EXAMPLE
      Get-GitLabProjectIssue -ProjectID 20 -State 'opened'
      ---------------------------------------------------------------
      Gets all open issues for project 20
  #>
  [CmdletBinding(DefaultParameterSetName = 'AllIssues')]
  [Alias()]
  [OutputType()]
  Param
  (
    # The ID of a project
    [Parameter(
        HelpMessage = 'ProjectID',
    Mandatory = $true)]
    [Alias('ID')]
    [String]$ProjectID,

    # If specified only returns opened or closed issues.
    [Parameter(ParameterSetName = 'AllIssues',
    HelpMessage = 'State (opened|closed)')]
    [validateset('opened','closed')]
    [string]$State,

    # If list of label names is specified only issues with any of the labels will be returned
    [Parameter(ParameterSetName = 'AllIssues',
    HelpMessage = 'list of labels')]
    [string[]]$Labels,

    # If Specified only issues belonging to specified milestone will be returned
    [Parameter(ParameterSetName = 'AllIssues',
    HelpMessage = 'milestone title')]
    [string[]]$Milestone,

    #The ID of a projects issue
    [Parameter(ParameterSetName = 'SingleIssue',
        HelpMessage = 'IssueID',
    Mandatory = $true)]
    [string]$IssueID,

    # Existing GitlabConnector Object, can be retrieved with Get-GitlabConnect
    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [psobject]$GitlabConnect = (Get-GitlabConnect)
  )


  $httpmethod = 'get'
  $apiurl = "projects/$([System.Web.HttpUtility]::UrlEncode($projectId))/issues"
  $parameters = @{}

  if($PSCmdlet.ParameterSetName -like 'AllIssues')
  {
    if($State)
    {
      $parameters.state = $State
    }
 
    if($Labels)
    {
      $parameters.labels = @($Labels) -join ','
    }

    if($Milestone)
    {
      $parameters.milestone = $Milestone
    }
  }

  if($PSCmdlet.ParameterSetName -like 'SingleIssue')
  {
    $apiurl += "/$IssueID"
  }

  $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)
}
