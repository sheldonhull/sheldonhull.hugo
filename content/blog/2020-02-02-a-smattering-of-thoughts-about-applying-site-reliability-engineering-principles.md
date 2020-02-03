---
date: 2019-04-16T23:19:00.000+00:00
title: A Smattering of Thoughts About Applying Site Reliability Engineering principles
slug: a-smattering-of-thoughts-about-applying-site-reliability-engineering-principles
excerpt: Applying more SRE principles in your DevOps culture can help equip you with more concrete steps.
tags:
- agile
- working-smart
- site-reliability-engineering
- tech
- devops
draft: true
toc: true

---
The target for this post is folks wanting to consider ways to improve their operations testing with a software testing approach.

_As always, this doesn't reflect the opinion of my employer and is just my opinion._

In my context, this is from the experience of being Scrum Master for a dedicated DevOps team at one point and the experience I've gained by working through various improvements in this process.


I figured I'd go ahead and take this article which I've gutted several times and share some thoughts, even if it's not an authority on the topic. 😀
In the last year, I've been interested in exploring the DevOps philosophy as it applies to operations and software development.
There are so many ways this is done, that DevOps lost much of its meaning in the inundation of DevOps phrases.

What does it mean to plan and scale a team and company?
How do operational stability and the pressure for new feature delivery in a competitive market meet in a health tension?

## What is Site Reliability Engineering

Google's SRE material provides a solid guide on the implementation of SRE teams.
They consider SRE and DevOps in a similar relationship to how Agile views Scrum.
Scrum is an implementation of Agile tenants.
Site Reliability Engineering is an approach to the implementation of a DevOps mindset in a systematic approach.

What I like about the material, is that a lot of the fixes I've considered to improvements in workflow and planning have been thoughtfully answered in their guide.

## Recommended Reading

Recommended reading if this interests you:

| Link |
| --- |
|[Google - Site Reliability Engineering](http://bit.ly/2RP2zqT)|
|[Do you have an SRE team yet? How to start and assess your journey](http://bit.ly/2tna4fb)|
|[Deploys: It’s Not Actually About Fridays – charity.wtf](http://bit.ly/2GPnJ1O)|
|[Love (and Alerting) in the Time of Cholera (and Observability) – charity.wtf](http://bit.ly/2GMw1HR)|
|[DevOps Topologies](https://web.devopstopologies.com/)|

## Site Reliability Engineering & DevOps

### Where I Started

At the beginning of my tech career, I worked at a place that the word "spec" or "requirement" was considered unreasonable. Acceptance criteria would have been looked down upon, as something too formal and wasteful.

While moving towards to implementation of any new project, I was expected to gather the requirements, build the solution, ensure quality and testing, and deploy to production.
That "cradle to grave" approach done correctly can promote the DevOps principles, such as ensuring rapid feedback from the end-users and ownership from creation through to production.

However, one key area that notably is different from the much healthier development culture I'm now part of, is the failure to build-out requirements, acceptance criteria, and an effective prioritization for the work that is incoming.

I've been in a somewhat interesting blend of roles that gives me some insight into this.
As a developer, I always look at things from an {{< fa robot >}} automation & coding perspective.
It's the exception, rather than the norm for me to do it manually without any type of way to reproduce via code.

I've also been part of a team that did some automation for various tasks in a variety of ways, yet often resolved issues via manual interactions due to the time constraints and pressures of inflowing work. Building out integration tests, code unit tests, or any other automated testing was a nice idea in theory, but allocating time to slow down and refactor for automated testing on code, deployments, and other automated tasks were often deemed too costly or time prohibitive to pursue.

### Reactive

The symptoms I'd normally associate a team that is more reactive than able to build proactively are below.

* Difficult to categorize emergency from something that could be done in a few weeks
* Difficult to deliver on a set of fully completed tasks in a sprint (if you even do a sprint)
* High interrupt ratio for request-driven work instead of able to put into a sprint with planning. This is common in a DevOps dedicated team topology that is in some of the Anti-Types mentioned in [DevOps Anti-Type topologies](https://web.devopstopologies.com/)
* Sprint items in progress tend to stay there for more than a few days due to the constant interruptions or unplanned work items that get put on their plate.
* Unplanned work items are constant, going above the 25% buffer normally put into a sprint team.
* Continued feature delivery pressure without the ability to invest in resiliency of the system.

Google has a lot more detail on the principles of "on call" rotation work compared to project oriented work. [Life of An On-Call Engineer](https://landing.google.com/sre/sre-book/chapters/being-on-call/). Of particular relevance is mention of capping the time that Site Reliability Engineers spend on purely operational work to 50% to ensure the other time is spent building solutions to impact the automation and service reliability in a proactive, rather than reactive manner.

### SLO & Error Budgets

One of the things that struck home, was the importance of SLO and error budgets.
Error budgets provide the key ingredient to balancing new feature delivery, while still ensuring happy customers with a stable system.

One of the best sections I've read on this was: [Embracing Risk](http://bit.ly/2UfsA4l).

Error budgets are discussed, which is such a great concept.
The goal of 100% reliability, while sounding great, is inherently unrealistic.

> Product development performance is largely evaluated on product velocity, which creates an incentive to push new code as quickly as possible. Meanwhile, SRE performance is (unsurprisingly) evaluated based upon reliability of a service, which implies an incentive to push back against a high rate of change. Information asymmetry between the two teams further amplifies this inherent tension.

## Taking the Time To Test

Changing requirements set you up for failure. Planning with defined acceptance criteria of work you are committing to is not about filling in more documentation and work that no one cares about. Properly defining the acceptance criteria for yourself is about the exploratory process that defines and limits to the scope of the work to deliver the minimum viable product. This allows continued momentum and delivery of value to the business.

Without effective acceptance criteria, _you are setting yourself up for more work_, and thus likely to deliver value to the business as quickly. From my perspective, if you cannot truly define the acceptance criteria for work, then it's likely the effort will result in less value, be difficult to deliver, or end up with scope creep.

*This is a critical thing to communicate to any teams struggling with reactive work.* Without spending time ensuring proactive planning and defining the work, more work is often spent reworking and solving problems that might have been better handled with a little planning and forethought.

A classic example of unclear acceptance criteria and it's wasteful impact of work is from a youtube clip here.

{{< youtube BTTdHW8Z668 >}}

How many times have you started work on a project and found yourself in a similar situation?

> "There are many reasons why software projects go wrong. A very common reason is that different people in the organization or on the team have very different understandings of how the software should behave, and what problems it’s trying to solve. Ignorance is the single greatest impediment to throughput"
> Teams that deliberately seek to discover what they are ignorant about before development starts are more productive, because there is less rework.
> The most effective way to do this is through conversation and collaboration between key stakeholders...
> Dan North

## Baby Steps In Testing

Now that I did my high-level philosophizing about the SRE, DevOps, communication, and planning... let's do something more low level and fun.
I could probably split this off to it's own post, but instead I'm just going to keep it here because the material before inspired the example in the first place.

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
When you write the feature files to work with Cucumber, you write them in Gherkin. Gherkin is supported for automated testing in many scripting languages. In a Windows environment, for example, you can use it to check many things like services running, connectivity with a server, installation of an app, and more using invocation via Pester.

Most examples I've found on Cucumber are focused very much on user testing, like website clicks, saving things, and other very narrow development focused actions.

What I've failed to see as much of is the discussion on the value of using this approach with teams implementing "Infrastructure as Code", operations teams, and other non-application specific roles.
To be fair, the more complicated but better design approach would probably do this with Ansible, Chef, PowerShell DSC, Saltstack, or another tool.

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

Get-InstalledApp 'Sumo' | Should -Be $true
}
And 'the service should show up' {
@(Get-Service 'Sumo*').Count | Should -Be 0
}
And 'the service should be running' {
@(Get-Service 'Sumo*' | Where-Object Status -eq 'Running').Count | Should -Be 0
}
```

Now that I wrote this, I could simply run:

```powershell
Invoke-Gherkin -Path InstallFancyLoggingVendor.steps.ps1
```

This would run all the steps from a feature file and ensure I'm able to repeat these tests after any change to confirm they work.

## Wrap Up

Long winded post, but since I've been mulling over this for a while, and had a mix of practical and concept-oriented concepts to cover, I hope you got some value from this either on the SRE concept level or the practical steps to approaching an operational task from more of a software development mentality with writing tests.
