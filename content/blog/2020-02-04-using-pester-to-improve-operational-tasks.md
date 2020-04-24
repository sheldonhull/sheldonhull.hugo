---
date: 2020-04-20T13:00:00.000+00:00
title: Using Pester to Improve Operational Tasks
slug: using-pester-to-improve-operational-tasks
excerpt: Leverage more software development testing principles for operational tasks
  to improve the quality and repeatability of work completed
comments: true
toc: true
images: 
tags:
- tech
- devops
- testing

---
## Taking the Time To Test

Requirements in a constant state of change set you up for failure.

Failure to work through requirements before starting can also increase the risk of failure.

Planning with defined acceptance criteria of work you are committing to is not about filling in more documentation and work that no one cares about. Properly defining the acceptance criteria for yourself is about the exploratory process that defines and limits the scope of the work to deliver the minimum viable product. This allows continued momentum and delivery of value to the business.

## Doesn't this create more busy work for me?

Without effective acceptance criteria, _you are setting yourself up for more work_, and thus likely to deliver value to the business as quickly. From my perspective, if you cannot truly define the acceptance criteria for work, then it's likely the effort will result in less value, be difficult to deliver, or end up with scope creep.

_This is a critical thing to communicate to any teams struggling with reactive work._ Without spending time ensuring proactive planning and defining the requirement and acceptance criteria, more time is often spent reworking and solving problems that might have been better handled with a little planning and forethought.

A classic example of unclear acceptance criteria and the wasteful impact of work is from a youtube clip here.

{{< youtube BTTdHW8Z668 >}}

How many times have you started work on a project and found yourself in a similar situation?

> "There are many reasons why software projects go wrong. A very common reason is that different people in the organization or on the team have very different understandings of how the software should behave, and what problems it’s trying to solve. Ignorance is the single greatest impediment to throughput"
> Teams that deliberately seek to discover what they are ignorant about before development starts are more productive because there is less rework.
> The most effective way to do this is through conversation and collaboration between key stakeholders...
> Dan North

## Small Steps In Testing

Now that I did my high-level philosophizing ... let's do something more low level and fun.

### An example of adding tests to DevOps oriented tasks

If we want to apply the "software engineer solving operational problems" approach to a very simple task, we could take the example of deploying a logging agent.

A software engineer expects a healthy culture to include tests for any code they write.
This ensures better quality, more rapid velocity in changes, and other benefits that TDD advocates can tell you in other places.

For our example, let's say we are deploying a monitoring agent on some servers.

### Gherkin

Gherkin is the syntax used to describe the tests.

{{< premonition type="info" title="Pester Syntax" >}}
You can write Pester tests with PowerShell in a different format, but I'm going to use Gherkin here because of its sentences and far less of a confusing DSL for our example.
{{< /premonition >}}

My understanding would be to compare Cucumber "spoken word", and Gherkin as the "language" chosen to communicate.
When you write the feature files to work with Cucumber, you write them in Gherkin.
Gherkin is supported for automated testing in many scripting languages.
In a Windows environment, for example, you can use it to check many things like services running, connectivity with a server, installation of an app, and more using invocation via Pester.

Most examples I've found on Cucumber are focused very much on user testing, like website clicks, saving things, and other very narrow development focused actions.

What I've failed to see as much of is the discussion on the value of using this approach with teams implementing "Infrastructure as Code", operations teams, and other non-application specific roles.

## Make Your Checklist Automated

In my example, let's start small and say you just have PowerShell, and some servers.

What I've discovered is that to actual validate DevOps oriented work is completed, you typically go through the equivalent of what a Cucumber test would have.
This "checklist" of validations is often manually performed, lacking consistency and the ability to scale or repeat with minimal effort.

Consider an alternative approach to helping solve this issue, and expanding your ability to automate the tedious testing and validation of changes made.

```cucumber
Scenario
Given (environment state)
When (something is done)
Then (expected result)
```

### Using Pester To Write An Ops Test

Instead of using manual checks to validate a series of steps, let's see what a Cucumber oriented test might define as the acceptance criteria to confirm successfully finished, and how this might work with automating the tests.

This is a simple MSI with some command-line arguments that might be required.
You want to validate the chocolatey package you deploy with correctly parsed the arguments passed in, and then successfully registered with the logging services.

An example feature file with Gherkin might look like this:

```cucumber
@class
Feature: I can generate configuration files for FancyLoggingVendor collection dynamically

    Background: The test environment
        Given the test environment is setup

    Scenario: Source json is configured to collect windows event logs
        Given FancyLoggingVendor json object is initialized
        When the package parameters request a Windows Event
        Then the created json file contents match
            """
{
"api.version":"v1",
"sources":\[
{
"sourceType":"LocalWindowsEventLog",
"name":"GherkinTest",
"renderMessages":true,
"cutoffRelativeTime":"-1h",
"hostname":"gherkintest",
"logNames":\[
"Security",
"Application"
\]
}
\]
}
            """
```

Another one that shows Scenario Outlines. This adds more functionality to looping through various variations of test cases.

```gherkin
Feature: I can install FancyLoggingVendor on my machine

    Background: The local package is updated and the functions loaded
        Given the test environment is setup

    Scenario Outline: As a local user, I can install FancyLoggingVendor and configure capture my desired target
        Given this package is not installed
        When the package source is a local nupkg file
        And a <Description> is provided with the values: <Paths>
        Then I can install from this source
        And the sources json returns sources of: <ExpectedSourcesCount>
        And the application should show up in installed programs
        And the service should show up
        And the service should be running
        Examples: Source Variations
            | Description              | Paths                              | ExpectedSourcesCount |
            | Single_File              | C:\\temp\\taco.log                 | 1                    |
            | Single_File_with_Filters | C:\\temp\\_.log                    | 1                    |
            | SingleFolder             | C:\\temp\\foobar                   | 1                    |
            | MultipleFolders          | C:\\temp\\foobar,C:\\temp\\foobar2 | 2                    |
            | SingleFolder_with_filter | C:\\temp\\foobar\\_.log            | 1                    |
```

This provides us with a way to validate and test something like a chocolatey package installation or custom install script.

## Leveraging Automation To Scale your Test

So all that writing...what benefit? Is it going to save time?

With PowerShell, I'd write something similar to match a called step to a code block here.

{{< premonition type="warning" title="Warning" >}}

Case sensitive name as of 2019-04-16 for keywords. Therefore to match steps, use `Before` not `before` or it won't match.

{{< /premonition >}}

```powershell

# Uses PSFramework as greatly simplifies any variable scoping or general configuration work, making this type of test easily reusable
#this is incomplete, just to give some practical examples of how I might use to repeat a test like this.

Before Each Scenario {
# other prep work
}

Given 'local package is updated and the functions loaded' {
# package up the
}
Given 'the test environment is setup' {
# do setup stuff here or other stuff that might be needed
}
Given 'this package is not installed' {
{ choco uninstall (Get-PSFConfigValue 'gherkin.packagename') } | Should -Not -Throw
}
When 'the package source is a local nupkg file' {
Set-PSFConfig 'gherkin.packagesource' -Value (Get-ChildItem -Path (Get-PSFConfigValue 'gherkin.packagefolder') -Filter *.nupkg).FullName
}

Then 'I can install from this source' {

$ChocoArguments = @()
$ChocoArguments += 'upgrade'
$ChocoArguments += Get-PSFConfigValue 'gherkin.packagename'
$ChocoArguments += '--source "{0}"' -f (Get-PSFConfigValue 'gherkin.packagefolder')
$ChocoArguments += (Get-PSFConfigValue 'gherkin.params')
$ChocoArguments += '--verbose'
{ Start-Process choco.exe -ArgumentList $ChocoArguments -NoNewWindow -PassThru | Wait-Process } | Should -Not -Throw
}

And 'the sources json returns sources of: <ExpectedSourcesCount>' {
param($ExpectedSourcesCount)
Write-PSFmessage -Level Important -FunctionName 'FancyLoggingVendor.Install.steps.ps1' -Message "ExpectedSourcesCount -- $ExpectedSourcesCount"
$DefaultJsonFile = 'PathToJsonHere'
Test-Path $DefaultJsonFile -PathType Leaf | Should -Be $True
@(Get-Content $DefaultJsonFile -Raw | ConvertFrom-Json | Select-Object Sources).Count | Should -Be $ExpectedSourcesCount
}
And 'the application should show up in installed programs' {

# helper function could be loaded and used to parse registry info for installed app showing up, or you could code it directly

Get-InstalledApp 'MyAgent' | Should -Be $true
}
And 'the service should show up' {
@(Get-Service 'MyAgent*').Count | Should -Be 0
}
And 'the service should be running' {
@(Get-Service 'MyAgent*' | Where-Object Status -eq 'Running').Count | Should -Be 0
}
```

Now that I wrote this, I could simply run:

```powershell
Invoke-Gherkin -Path InstallFancyLoggingVendor.steps.ps1
```

This would run all the steps from a feature file and ensure I'm able to repeat these tests after any change to confirm they work.

## Other Great Use Cases

I've leveraged this to validate SQL Server configuration changes on a new AWS RDS Deployment, validate build steps completed successfully, tested file paths existing, and more. I really like how you can have this all integrated in a nice UI by uploading the nunit tests in Azure DevOps pipelines too.

## Start Small

Take a look at the simple Pester syntax examples or the gherkin examples I gave and use that to do anything you keep having to check more than a few times. You'll find your efforts rewarded by having more consistent testing and probably save quite a bit of effort as well.

## Helped?

If you found these concepts helpful and would like an example of using Pester to test SQL Server login authentication, user group assignment, and more, let me know. I've done SQL Server pester tests using traditional Pester syntax that would validate maintenance solution deployment, login mapping, and more. If this was valuable, I could do a write-up of this. 

If you also would like more fundamentals, I'd be willing to do a basic Pester write-up for an operational focused task that is ground zero too, just depends if you the reader find this helpful.

Comments always appreciated if this helped you! Let's me know it's actually helping someone out and always great to connect with others. 🍻