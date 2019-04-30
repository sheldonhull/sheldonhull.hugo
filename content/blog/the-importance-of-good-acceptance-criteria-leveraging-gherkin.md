---
date: 2019-04-16T18:19:00-05:00
title: The Importance of Good Acceptance Criteria & Leveraging Gherkin
slug: the-importance-of-good-acceptance-criteria-in-devops
excerpt: Changing requirements set you up for failure. Planning ahead with truly defining
  acceptance criteria of work you are committing to is not about filling in more documentation
  and work that no one cares about.
tags:
- agile
- working-smart
- tech
- devops
draft: true

---
The target for this post can be developers, or operations team. In my context, this is from the experience of being Scrum Master for a dedicated DevOps team that began the process of migrating from a more reactionary approach to preplanning, sprints, and building out a healthy backlog.

\## Cradle To Grave

At the beginning of my tech career, I worked at a place that the word "spec" or "requirement" was considered unreasonable. In moving towards to implementation of any new project, as a developer, I was expected to gather the requirements, build the solution, ensure quality and testing, and deploy to production.

That "cradle to grave" approach done correctly can promote Agile tenants, such as ensuring rapid feedback from the end users. However, one key area that notably is different from the much healthier development culture I'm now part of, is the failure to build out requirements, acceptance criteria, and an effective backlog.

In having been in a mostly pure development environment, to now being in a role that's focused on DevOps and infrastructure, I thought I'd chronicle some of these thoughts as it's an evolving understanding, that might provide help for anyone looking to help reduce the reactive approach that is so easy to fall into.

## Reactive

The symptoms I'd normally associate a team that is more reactive than proactive in nature is:

* Difficult to categorize emergency from something that could be done in a few weeks
* Difficult to deliver on a set of fully completed tasks in a sprint (if you even do a sprint), due to more than a couple interruptions on requests from other teams. This is especially pronounced in a dedicated team doing DevOps oriented work.
* Sprint items in progress tend to stay there for more than a few days due to the constant interruptions or unplanned work items that get put on their plate.
* Unplanned work items are constant, going above the 25% buffer normally put into a sprint team.

## Planning Ahead Can Reduce Work

Changing requirements set you up for failure. Planning ahead with truly defining acceptance criteria of work you are committing to is not about filling in more documentation and work that no one cares about. Even if no one else read your acceptance criteria except yourself, it's about the exploratory process that helps you define and limit the scope of your work to truly deliver value.

Without effective acceptance criteria, you are setting yourself up for more work, and thus likely to deliver value to the business as quickly. From my perspective, if you cannot truly define the acceptance criteria for work, then it's likely the effort will result in less value, be difficult to deliver, or end up with scope creep.

A classic example of unclear acceptance criteria is one of my favorite clips here:

{{% youtube BTTdHW8Z668 %}}

How many times have you started work on a project and found yourself in a similar situation?

## Solving This Pickle of a Problem with Gherkin

I couldn't help the lame pun, my apologies.

Most examples I've found on Cucumber are focused very much on user testing, like website clicks, saving things, and other very narrow development focused actions. What I've failed to see as much of is the discussion on the value of using this approach with teams implementing "Infrastructure as Code", operations teams, and other non-application specific roles.

In my case, working in an environment that blends development with a heavy emphasis on infrastructure, continual-integration, and builds, I've found that the same approach can provide a tremendous value in helping define effective acceptance criteria.

Cucumbers page describes why thinking through this stuff matters:

> "There are many reasons why software projects go wrong. A very common reason is that different people in the organization or on the team have very different understandings of how the software should behave, and what problems it’s trying to solve. Ignorance is the single greatest impediment to throughput" - Dan North  
> Teams that deliberately seek to discover what they are ignorant about before development starts are more productive, because there is less rework.  
> The most effective way to do this is through conversation and collaboration between key stakeholders...

## Gherkin

Gherkin is the syntax used to describe the tests. My understanding would be to compare Cucumber as "spoken word", and Gherkin as the "language" chosen to communicate. When you write the feature files to work with Cucumber, you write them in Gherkin. Gherkin is supported for automated testing in many scripting languages. In a Windows environment for example, you can actually use it to check tons of infrastructure things like services running, connectivity with a server, installation of an app and more using invocation via Pester.

What I've discovered is that to actual validate DevOps oriented work is completed, you typically go through the equivalent of what a Cucumber test would have. This "checklist" of validations is often manually performed, lacking consistency and the ability to scale or repeat with minimal effort.

Consider an alternative approach to helping solve this issue, and expanding your ability to automate the tedious testing and validation of changes made.

\`\`\`  
Scenario  
Given (environment state)  
When (something is done)  
Then (expected result)  
\`\`\`

## How Can This Apply to Operational Tasks?

Instead of using manual checks to validate a series of steps, let's see what a Cucumber oriented test might define as the acceptance criteria to confirm successfully finished, and how this might work with automating the tests.

Let's say you wanted to deploy a logging agent against a server. This is a simple MSI with some command line arguments that might be required. You want to validate the chocolatey package you deploy with correctly parsed the arguments passed in, and then successfully registered with the logging services.

An example feature file with Gherkin might look like this:

\`\`\`gherkin  
@class  
Feature: I can generate configuration files for Sumologic collection dynamically

Background: The test environment  
Given the test environment is setup

Scenario: Source json is configured to collect windows event logs  
Given Sumologic json object is initialized  
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

\`\`\`

Another one that shows Scenario Outlines which give the ability for me to loop the test for all the different variations I want to define in a table and confirm all of them, while only writing one Scenario Outline.

\`\`\`gherkin  
@install  
Feature: I can install sumologic on my machine

Background: The local package is updated and the functions loaded  
Given the test environment is setup

Scenario Outline: As a local user, I can install SumoLogic and configure capture my desired target  
Given this package is not installed  
When the package source is a local nupkg file  
And a <Description> is provided with the values: <Paths>  
Then I can install from this source  
And the sources json returns sources of: <ExpectedSourcesCount>  
And the application should show up in installed programs  
And the service should show up  
And the service should be running  
Examples: Source Variations  
| Description | Paths | ExpectedSourcesCount |  
| Single_File | C:\\temp\\taco.log | 1 |  
| Single_File_with_Filters | C:\\temp\\_.log | 1 |  
| SingleFolder | C:\\temp\\foobar | 1 |  
| MultipleFolders | C:\\temp\\foobar,C:\\temp\\foobar2 | 2 |  
| SingleFolder_with_filter | C:\\temp\\foobar\\_.log | 1 |  
\`\`\`

This provides us with a way to validate and test our chocolatey scripts successful installation and configuration.

## Leveraging Automation To Scale your Test

So all that writing.... what benefit? Is it going to save time?

With PowerShell, I'd write something similar to below to basically match a called step to a code block here.

{{% warning %}}

Case sensitive name as of 2019-04-16 for keywords. Therefore to match steps, use \`Before\` not \`before\` or it won't match.

{{% /warning %}}

\`\`\`powershell

# Uses PSFramework as greatly simplifies any variable scoping or general configuration work, making this type of test easily reusable

\#this is incomplete, just to give some practical examples of how I might use to repeat a test like this.

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
Write-PSFmessage -Level Important -FunctionName 'SumoLogic.Install.steps.ps1' -Message "ExpectedSourcesCount -- $ExpectedSourcesCount"  
$DefaultJsonFile = 'PathToJsonHere'  
Test-Path $DefaultJsonFile -PathType Leaf | Should -Be $True  
@(Get-Content $DefaultJsonFile -Raw | ConvertFrom-Json | Select-Object Sources).Count | Should -Be $ExpectedSourcesCount  
}  
And 'the application should show up in installed programs' {

# helper function could be loaded and used to parse registry info for installed app showing up, or you could code it directly

Get-InstalledApp 'Sumo' | Should -Be $true  
}  
And 'the service should show up' {  
@(Get-Service 'Sumo*').Count | Should -Be 0  
}  
And 'the service should be running' {  
@(Get-Service 'Sumo*' | Where-Object Status -eq 'Running').Count | Should -Be 0  
}  
\`\`\`

Now that I wrote as basic test, I could simply run

\`\`\`powershell  
Invoke-Gherkin -Path InstallSumoLogic.steps.ps1  
\`\`\`

This would run all the steps from a feature file and ensure I'm able to repeat these tests after any change to confirm they work.

# Wrap Up

Long winded post, but wanted to write a better example and walk through how building out some examples and scenarios can help not only repeatable testing, but the importance of using something like this in building better acceptance criteria, which results in a better ability to meet the needs of the business.