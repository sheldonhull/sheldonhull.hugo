# Consider the Benefits of Powershell for Developer Workflows


## Who Am I Talking To

- You use bash or python.
- PowerShell seems wordy, extra verbose, and annoying.
- It&#39;s a windows thing, you say... why would I even look at it.
- Pry bash out of my fingers if yuo dare (probably not for you 😁)

## What PowerShell Is

- The best language for automating Windows... period.
- A great language for development tooling and productivity scripts.
- One of the best languages for automation with interactivity.
Python is fantastic. The REPL isn&#39;t meant for the same interactivity you get with PowerShell.
PowerShell prompt is sorta like mixing Python &amp; fish/bash in a happy marriage.
- A rich language (not just scripting) for interacting with AWS using AWS.Tools.
- A rich object-oriented pipeline that can handle very complex actions in one-liners based on object-oriented pipelines.
- Intuitive and consistent mostly for command discovery.
    - a common complaint from bash pros.
    - The point of the verbosity `Verb-Noun` is discoverability. `tar` for example is a bit harder to figure out than `Expand-Archive -Path foo -DestinationPath foo`
- A language with a robust testing framework for unit, integration, infrastructure, or any other kinda testing you want! (Pester is awesome)

## What PowerShell Isn&#39;t

- Python 🤣
- Good at datascience.
- Succinct
- Meant for high-concurrency
- Good at GUI&#39;s... but come-on we&#39;re devs... guis make us weak 😜
- A good webserver
- Lots more.

## The Right Tool for the Job

I&#39;m not trying to tell you never to use bash.
It&#39;s what you know, great!

However, I&#39;d try to say if you haven&#39;t explored it, once you get past some of the paradigm differences, there is a rich robust set of modules and features that can improve most folks workflow.

## Why Even Consider PowerShell

As I&#39;ve interacted more and more with folks coming from a mostly Linux background, I can appreciate that considering PowerShell seems odd.
It&#39;s only recently that it&#39;s cross platform in the lifecycle of things, so it&#39;s still a new thing to most.

Having been immersed in the .NET world and now working on macOS and using Docker containers running Debian and Ubuntu (sometimes Alpine Linux), I completely get that&#39;s not even in most folks purview.

Yet, I think it&#39;s worth considering for developer workflows that there is a lot of gain to be had with PowerShell for improving the more complex build and development workflows because of the access to .NET.

No, it&#39;s not &#34;superior&#34;. It&#39;s different.
Simple cli bash scripting is great for many things (thus prior article about Improving development workflow `Task` which uses shell syntax).

The fundemental difference in bash vs PowerShell is really text vs object, in my opinion.
This actually is where much of the value comes in for considering what to use.

{{&lt; admonition type=&#34;info&#34; title=&#34;Go For CLI Tools&#34; &gt;}}
Go provides a robust cross-platform single binary with autocomplete features and more.

I&#39;d say that for things such as exporting pipelines to Excel, and other &#34;automation&#34; actions it&#39;s far more work in Go.

Focus Go on tooling that makes the extra plumbing and stronger typing give benefit rather than just overhead.
AWS SDK operations, serverless/lambda, apis, complex tools like Terraform, and more fit the bill perfectly and are a great use case.
{{&lt; /admonition &gt;}}

## Scenario: Working with AWS

If you are working with the AWS SDK, you are working with objects.
This is where the benefit comes in over cli usage.

Instead of parsing json results and using tools like `jq` to choose arrays, instead, you can interact with the object by named properties very easily.

```powershell
$Filters = @([Amazon.EC2.Model.Filter]::new(&#39;tag:is_managed_by&#39;,&#39;muppets&#39;)
$InstanceCollection = (Get-EC2Instance -Filter $Filters)).Instances | Select-PSFObject InstanceId, PublicIpAddress,PrivateIpAddress,Tags,&#39;State.Code as StateCode&#39;, &#39;State.Name as StateName&#39;  -ScriptProperty @{
    Name = @{
        get  = {
            $this.Tags.GetEnumerator().Where{$_.Key -eq &#39;Name&#39;}.Value
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
- Toast notification on results: `Send-OSNotification -Title &#39;Instance Collection Results&#39; -Body &#34;Total results returned: $($InstanceCollection.Count)&#34;`
- Export To Excel with Table:  `$InstanceCollection | Export-Excel -Path ./instance-collection.json -TableStyle Light8 -TableName &#39;FooBar&#39;`
- Send a rich pagerduty event to flag an issue: `Send-PagerDutyEvent -Trigger -ServiceKey foo -Description &#39;Issues with instance status list&#39; -IncidentKey &#39;foo&#39; -Details $HashObjectFromCollection`
- Use a cli tool to flip to yaml (you can use native tooling often without much issue!): `$InstanceCollection | ConvertTo-Json -Depth 10 | cfn-flip | Out-File ./instance-collection.yml`

Now build a test (mock syntax), that passes or fails based on the status of the instances

{{&lt; admonition type=&#34;Note&#34; title=&#34;Disclaimer&#34; open=true &gt;}}

I&#39;m sure there&#39;s great tooling with `jq`, `yq`, excel clis and other libraries that can do similar work.

My point is that it&#39;s pretty straight forward to explore this in PowerShell as object-based pipelines are a lot less work with complex objects than text based parsing.

{{&lt; /admonition &gt;}}

```powershell
Describe &#34;Instance Status Check&#34; {
  Context &#34;Instances That Should Be Running&#34; {
    foreach($Instance in $InstanceCollection)
    {
        It &#34;should be running&#34; {
        $Instance.StatusName | Should -Be &#39;Running&#39;
        }
    }
  }
}
```

Now you have a test framework that you could validate operational issues across hundreds of instances, or just unit test the output of a function.

## Exploring the Object

I did this comparison once for a coworker, maybe you&#39;ll find it useful too!

```powershell
&#34;Test Content&#34; | Out-File ./foo.txt
$Item = Get-Item ./foo.txt

## Examine all the properties and methods available. It&#39;s an object
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

I know many of these things you can do in bash as well, but the object pipeline here I&#39;d wager provides a very solid experience for more complex operations based on the .NET framework types available.

## Wrap Up

This was meant to give a fresh perspective on why some folks have benefited from PowerShell over using shell scripting.
It&#39;s a robust language that for automation/build/cloud automation can give a rich reward if you invest some time to investigate.

For me the basic &#34;right tool for the job&#34; would like like this:

- data: python
- serverless: go &amp; python (powershell can do it too, but prefer the others)
- web: go &amp; python
- basic cli stuff: shell (using `Task` which uses shell syntax)
- complex cli project tasks: powershell &amp; go
- automation/transformation: powershell &amp; python
- high concurrency, systems programming: go

Maybe this provided a fresh perspective for why PowerShell might benefit even those diehard shell scripters of you out there and maybe help convince you to take the plunge and give it a shot.

