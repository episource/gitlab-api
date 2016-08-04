function Get-GitLabProjectIssue
{
  <#
      .Synopsis
      Get a  a project's issues.
      .DESCRIPTION
      
      .Example
  #>
  [CmdletBinding(DefaultParameterSetName='AllIssues')]
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

    # Return all issues or just those that are opened or closed
    [Parameter(ParameterSetName='AllIssues',
    HelpMessage = 'State (opened|closed)')]
    [validateset('opened','closed')]
    [string]$State,

    #list of label names, issues with any of the labels will be returned
    [Parameter(ParameterSetName='AllIssues',
    HelpMessage='list of labels')]
    [string[]]$Labels,

    #only issues belongiong to milestone will be returned
    [Parameter(ParameterSetName='AllIssues',
    HelpMessage='milestone title')]
    [string[]]$Milestone,

    #The ID of a projects issue
    [Parameter(ParameterSetName='SingleIssue',
        HelpMessage = 'IssueID',
    Mandatory = $true)]
    [string]$IssueID,

    [Parameter(HelpMessage = 'Specify Existing GitlabConnector',
        Mandatory = $false,
    DontShow = $true)]
    [psobject]$GitlabConnect = (Get-GitlabConnect)
  )


  $httpmethod = 'get'
  $apiurl = "projects/$id/issues"
  $parameters = @{}

  if($PSCmdlet.ParameterSetName -like 'AllIssues'){
    if($state){
      $parameters.state = $state
    }
 
    if($labels){
      $parameters.labels = @($labels) -join ','
    }

    if($milestone){
      $parameters.milestone = $milestone
    }
  }

  if($PSCmdlet.ParameterSetName -like 'SingleIssue'){
  $apiurl += "/$IssueID"
  }

  $GitlabConnect.callapi($apiurl,$httpmethod,$parameters)
}