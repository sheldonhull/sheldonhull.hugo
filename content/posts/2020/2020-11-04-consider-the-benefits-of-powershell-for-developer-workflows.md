---
date: 2020-11-04T07:00:00Z
title: Consider the Benefits of Powershell for Developer Workflows
slug: consider-the-benefits-of-powershell-for-developer-workflows
summary:
  You use bash and python. You have no need of the wierdness that is powershell.
  Give me couple minutes to convince you otherwise. Maybe you'll find something useful :-)
tags:
- development
- cool-tools
- golang
- automation
toc: true
series: ["Development Workflow Tooling"]
---

## Who Am I Talking To

- You use bash or python.
- PowerShell seems wordy, extra verbose, and annoying.
- It's a windows thing, you say... why would I even look at it.
- Pry bash out of my fingers if yuo dare (probably not for you 😁)

## What PowerShell Is

- The best language for automating Windows... period.
- A great language for development tooling and productivity scripts.
- One of the best languages for automation with interactivity.
Python is fantastic. The REPL isn't meant for the same interactivity you get with PowerShell.
PowerShell prompt is sorta like mixing Python & fish/bash in a happy marriage.
- A rich language (not just scripting) for interacting with AWS using AWS.Tools.
- A rich object-oriented pipeline that can handle very complex actions in one-liners based on object-oriented pipelines.
- Intuitive and consistent mostly for command discovery.
    - a common complaint from bash pros.
    - The point of the verbosity `Verb-Noun` is discoverability. `tar` for example is a bit harder to figure out than `Expand-Archive -Path foo -DestinationPath foo`
- A language with a robust testing framework for unit, integration, infrastructure, or any other kinda testing you want! (Pester is awesome)

## What PowerShell Isn't

- Python 🤣
- Good at datascience.
- Succinct
- Meant for high-concurrency
- Good at GUI's... but come-on we're devs... guis make us weak 😜
- A good webserver
- Lots more.

## The Right Tool for the Job

I'm not trying to tell you never to use bash.
It's what you know, great!

However, I'd try to say if you haven't explored it, once you get past some of the paradigm differences, there is a rich robust set of modules and features that can improve most folks workflow.

## Why Even Consider PowerShell

As I've interacted more and more with folks coming from a mostly Linux background, I can appreciate that considering PowerShell seems odd.
It's only recently that it's cross platform in the lifecycle of things, so it's still a new thing to most.

Having been immersed in the .NET world and now working on macOS and using Docker containers running Debian and Ubuntu (sometimes Alpine Linux), I completely get that's not even in most folks purview.

Yet, I think it's worth considering for developer workflows that there is a lot of gain to be had with PowerShell for improving the more complex build and development workflows because of the access to .NET.

No, it's not "superior". It's different.
Simple cli bash scripting is great for many things (thus prior article about Improving development workflow `Task` which uses shell syntax).

The fundemental difference in bash vs PowerShell is really text vs object, in my opinion.
This actually is where much of the value comes in for considering what to use.

{{< admonition type="info" title="Go For CLI Tools" >}}
Go provides a robust cross-platform single binary with autocomplete features and more.

I'd say that for things such as exporting pipelines to Excel, and other "automation" actions it's far more work in Go.

Focus Go on tooling that makes the extra plumbing and stronger typing give benefit rather than just overhead.
AWS SDK operations, serverless/lambda, apis, complex tools like Terraform, and more fit the bill perfectly and are a great use case.
{{< /admonition >}}

## Scenario: Working with AWS

If you are working with the AWS SDK, you are working with objects.
This is where the benefit comes in over cli usage.

Instead of parsing json results and using tools like `jq` to choose arrays, instead, you can interact with the object by named properties very easily.

```powershell
$Filters = @([Amazon.EC2.Model.Filter]::new('tag:is_managed_by','muppets')
$InstanceCollection = (Get-EC2Instance -Filter $Filters)).Instances | Select-PSFObject InstanceId, PublicIpAddress,PrivateIpAddress,Tags,'State.Code as StateCode', 'State.Name as StateName'  -ScriptProperty @{
    Name = @{
        get  = {
            $this.Tags.GetEnumerator().Where{$_.Key -eq 'Name'}.Value
        }
    }
}
```

With this `$InstanceCollection` variable, we now have access to an easily used object that can be used with named properties.

- Give me all the names of the EC2 instances: `$InstanceCollection.Name`
- Sort those: `$InstanceCollection.Name | Sort-Object` (or use alias shorthand such as `sort`)
- For each of this results start the instances: `$InstanceCollection | Start-EC2Instance`

## Practical Examples

Beyond that, we can do many things with the rich eco-system of prebuilt modules.

Here are some example of some rich one-liners using the power of the object based pipeline.

- Export To Json: `$InstanceCollection | ConvertTo-Json -Depth 10 | Out-File ./instance-collection.json`
- Toast notification on results: `Send-OSNotification -Title 'Instance Collection Results' -Body "Total results returned: $($InstanceCollection.Count)"`
- Export To Excel with Table:  `$InstanceCollection | Export-Excel -Path ./instance-collection.json -TableStyle Light8 -TableName 'FooBar'`
- Send a rich pagerduty event to flag an issue: `Send-PagerDutyEvent -Trigger -ServiceKey foo -Description 'Issues with instance status list' -IncidentKey 'foo' -Details $HashObjectFromCollection`
- Use a cli tool to flip to yaml (you can use native tooling often without much issue!): `$InstanceCollection | ConvertTo-Json -Depth 10 | cfn-flip | Out-File ./instance-collection.yml`

Now build a test (mock syntax), that passes or fails based on the status of the instances

{{< admonition type="Note" title="Disclaimer" open=true >}}

I'm sure there's great tooling with `jq`, `yq`, excel clis and other libraries that can do similar work.

My point is that it's pretty straight forward to explore this in PowerShell as object-based pipelines are a lot less work with complex objects than text based parsing.

{{< /admonition >}}

```powershell
Describe "Instance Status Check" {
  Context "Instances That Should Be Running" {
    foreach($Instance in $InstanceCollection)
    {
        It "should be running" {
        $Instance.StatusName | Should -Be 'Running'
        }
    }
  }
}
```

Now you have a test framework that you could validate operational issues across hundreds of instances, or just unit test the output of a function.

## Exploring the Object

I did this comparison once for a coworker, maybe you'll find it useful too!

```powershell
"Test Content" | Out-File ./foo.txt
$Item = Get-Item ./foo.txt

## Examine all the properties and methods available. It's an object
$Item | Get-Member
```

This gives you an example of the objects behind the scene.
Even though your console will only return a small set of properties back, the actual object is a .NET object with all the associated methods and properties.

This means that `Get-Item` has access to properties such as the base name, full path, directory name and more.

You can access the actual `datetime` type of the `CreationTime`, allowing you to do something like:

```powershell
($item.LastAccessTime - $Item.CreationTime).TotalDays
```

This would use two date objects, and allow you to use the relevant `Duration` methods due to performing math on these.

The methods available could be anything such as `$Item.Encrypt(); $Item.Delete; $Item.MoveTo` and more all provided by the .NET namespace `System.IO.FileInfo`.

I know many of these things you can do in bash as well, but the object pipeline here I'd wager provides a very solid experience for more complex operations based on the .NET framework types available.

## Wrap Up

This was meant to give a fresh perspective on why some folks have benefited from PowerShell over using shell scripting.
It's a robust language that for automation/build/cloud automation can give a rich reward if you invest some time to investigate.

For me the basic "right tool for the job" would like like this:

- data: python
- serverless: go & python (powershell can do it too, but prefer the others)
- web: go & python
- basic cli stuff: shell (using `Task` which uses shell syntax)
- complex cli project tasks: powershell & go
- automation/transformation: powershell & python
- high concurrency, systems programming: go

Maybe this provided a fresh perspective for why PowerShell might benefit even those diehard shell scripters of you out there and maybe help convince you to take the plunge and give it a shot.
