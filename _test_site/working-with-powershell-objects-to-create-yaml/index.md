# Working With Powershell Objects to Create Yaml


## Who This Might Be For

- PowerShellers wanting to know how to create json and yaml dynamically via `pscustomobject`.
- Anyone wanting to create configs like Datadog or other tools dynamically without the benefit of a configuration management tool.
- Anyone else wanting to fall asleep more quickly. (I can think of better material such as the Go spec docs, but hey, I can&#39;t argue with your good taste 😄)

## YAML

It&#39;s readable.

It&#39;s probably cost all of us hours when debugging yaml that&#39;s nested several layers and an errant whitespace got in.

It&#39;s here to stay.

I prefer it over JSON for readability, but I prefer JSON for programmability.

Sometimes though, tooling uses yaml, and we need to be able to flip between both.

Historically I&#39;ve used `cfn-flip` which is pretty great.

## Enter yq

The problem I have with using `cfn-flip` is dependencies.
It&#39;s a bit crazy to setup a docker image and then need to install a bunch of python setup tools to just get this one tool when it&#39;s all I need.

I thought about building a quick `Go` app to do this and give me the benefit of a single binary, as there is a pretty useful `yaml` package already.
Instead, I found a robust package that is cross-platform called `yq` and it&#39;s my new go to. 🎉

## Just plain works

[The docs are great](http://bit.ly/3pphpTb)

Reading `STDIN` is a bit clunky, but not too bad, though I wish it would take more of a pipeline input approach natively.
Instead of passing in `{&#34;string&#34;:&#34;value&#34;} | yq` it requires you to specify `stringinput | yq eval - --prettyPrint` .
Note the single hyphen after eval. This is what signifies that the input is `STDIN`.

## Dynamically Generate Some Configs

I was working on some Datadog config generation for SQL Server, and found this tooling useful, especially on older Windows instances that didn&#39;t have the capability to run the nice module [powershell-yaml](http://bit.ly/3j4D94J).

Here&#39;s how to use PowerShell objects to help generate a yaml configuration file on demand.

### Install

See install directions for linux/mac, as it&#39;s pretty straightforward.

For windows, the chocolatey package was outdated as of the time of the article using the version 3.x.

I used a PowerShell 4.0 compatible syntax here that should work on any instances with access to the web.

```powershell
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
if (-not (Test-Path &#39;C:\tools\yq.exe&#39; -PathType Leaf))
    {
        $ProgressPreference = &#39;SilentlyContinue&#39;
        New-Item &#39;C:\tools&#39; -ItemType Directory -Force
        Invoke-WebRequest &#39;https://github.com/mikefarah/yq/releases/download/v4.4.1/yq_windows_amd64.exe&#39; -OutFile &#39;C:\tools\yq.exe&#39; -UseBasicParsing
        Unblock-File &#39;C:\tools\yq.exe&#39; -Confirm:$false
    }
```

Once this was downloaded, you could either make sure `C:\tools` was in `PATH` or just use the fully qualified path for our simple use case.

### Get AWS Metadata

In AWS, I parsed the metadata for the AccountID and InstanceID to generate a query to pull the Name tag dynamically.

{{&lt; admonition type=&#34;Tip&#34; title=&#34;Permissions Check&#34; &gt;}}
You must have the required permissions for the instance profile for this to work.
This is not an instance level permission, so you&#39;ll want to add the required DescribeTags and ListInstances permissions for using a command such as `Get-EC2Tag`
{{&lt; /admonition &gt;}}

```powershell
Import-Module AWSPowershell -Verbose:$false *&gt; $null
# AWSPowerShell is the legacy module, but is provided already on most AWS instances
$response = Invoke-RestMethod -Uri &#39;http://169.254.169.254/latest/dynamic/instance-identity/document&#39; -TimeoutSec 5
$AccountId = $response.AccountId
```

### Pull Back EC2 Tags

Now we can pull back the tag using an EC2 instance filter object.

```powershell
$filters = @(
      [Amazon.EC2.Model.Filter]::new(&#39;resource-id&#39;, $response.InstanceId)
  )
  $tags = Get-EC2Tag -Filters $filters
  $tagcollection = $tags.ForEach{
      $t = $_
      [pscustomobject]@{
          Name  = $t.name
          Value = $t.value
      }
  }
  Write-Host &#34;Tags For Instance: $($tagcollection | Format-Table -AutoSize -Wrap | Out-String)&#34;
  $HostName = $Tags.GetEnumerator().Where{ $_.Key -eq &#39;Name&#39; }.Value.ToLower().Trim()
  $SqlInstance = $HostName
```

### Switch Things Up With A Switch

The next step was to alias the instance.

The better way to do this would be to use a tag that it reads, but for my quick ad-hoc use, this just let me specific an explicit alias to generate as a tag in the yaml. Again, try to use the Datadog tagging feature to do this automatically if possible.

{{&lt; admonition type=&#34;Tip&#34; title=&#34;Switch Statements&#34; &gt;}}
If you aren&#39;t familiar with PowerShell&#39;s switch statement, it&#39;s a nice little feature for making this evaluation easy to read.

For the breadth of what this cool language feature can do, check this article out:

[Everything you ever wanted to know about the switch statement](http://bit.ly/3pwnei0)
{{&lt; /admonition &gt;}}


```powershell
switch ($AccountId)
{
    &#39;12345&#39; { $AWSAccountAlias  = &#39;mydevenv&#39; ; $stage = &#39;qa&#39; }
    &#39;12345&#39; { $AWSAccountAlias  = &#39;myprodenv&#39; ; $stage = &#39;prod&#39; }
    default
    {
        throw &#34;Couldn&#39;t match a valid account number to give this an alias&#34;
    }
}
```

Now, preview the results of this Frankenstein.

```powershell
Write-Host -ForegroundColor Green (&#34;
`$HostName        = $HostName
`$SqlInstance     = $SqlInstance
`$AWSAccountAlias = $AWSAccountAlias
`$stage           = $stage
 &#34;)
```

### Ready To Generate Some Yaml Magic

```powershell
$TargetConfig = (Join-Path $ENV:ProgramData &#39;Datadog/conf.d/windows_service.d/conf.yaml&#39;)
$Services = [pscustomobject]@{
    &#39;instances&#39; = @(
        [ordered]@{
            &#39;services&#39;                   =  @(
                &#39;SQLSERVERAGENT&#39;
                &#39;MSSQLSERVER&#39;
                &#39;SQLSERVERAGENT&#39;
            )
            &#39;disable_legacy_service_tag&#39; = $true
            &#39;tags&#39;                       = @(
                &#34;aws_account_alias:$AWSAccountAlias&#34;
                &#34;sql_instance:$SqlInstance&#34;
                &#34;stage:$stage&#34;
            )
        }
    )
}

$Services | ConvertTo-Json -Depth 100 | &amp;&#39;C:\tools\yq.exe&#39; eval - --prettyPrint | Out-File $TargetConfig -Encoding UTF8
```

This would produce a nice json output like this

![Example config image](/images/2021-02-08-yaml-config-example.png)

### One More Complex Example

Start with creating an empty array and some variables to work with.

```powershell
$UserName = &#39;TacoBear&#39;
$Password = &#39;YouReallyThinkI&#39;&#39;dPostThis?Funny&#39;
$TargetConfig = (Join-Path $ENV:ProgramData &#39;Datadog/conf.d/sqlserver.d/conf.yaml&#39;)
$Queries = @()
```

Next include the generic Datadog collector definition.

This is straight outta their [Github repo](http://bit.ly/3cisxgY) with the benefit of some tagging.

```powershell
$Queries &#43;= [ordered]@{
    &#39;host&#39;      =&#39;tcp:localhost,1433&#39;
    &#39;username&#39;  =$UserName
    &#39;password&#39;  = $Password
    &#39;connector&#39; =&#39;adodbapi&#39;
    &#39;driver&#39;    = &#39;SQL Server&#39;
    &#39;database&#39;  = &#39;master&#39;
    &#39;tags&#39;      = @(
        &#34;aws_account_alias:$AWSAccountAlias&#34;
        &#34;sql_instance:$SqlInstance&#34;
        &#34;stage:$stage&#34;
    )
}
```

{{&lt; admonition type=&#34;Tip&#34; title=&#34;Using &#43;= for Collections&#34; &gt;}}
Using `&#43;=` is a bit of an anti-pattern for high performance PowerShell, but it works great for something like this that&#39;s ad-hoc and needs to be simple.
For high performance needs, try using something like `$list = [Systems.Collections.Generic.List[pscustomobject]]:new()` for example.
This can then allow you to use the `$list.Add([pscustomobject]@{}` to add items.

A bit more complex, but very powerful and performance, with the benefit of stronger data typing.
{{&lt; /admonition &gt;}}

This one is a good example of the custom query format that Datadog supports, but honestly I found pretty confusing in their docs until I bumbled my way through a few iterations.

```powershell
$Queries &#43;=    [ordered]@{
    # description: Not Used by Datadog, but helpful to reading the yaml, be kind to those folks!
    &#39;description&#39;             = &#39;Get Count of Databases on Server&#39;
    &#39;host&#39;                    =&#39;tcp:localhost,1433&#39;
    &#39;username&#39;                = $UserName
    &#39;database&#39;                = &#39;master&#39;
    &#39;password&#39;                = $Password
    &#39;connector&#39;               =&#39;adodbapi&#39;
    &#39;driver&#39;                  = &#39;SQL Server&#39;
    &#39;min_collection_interval&#39; = [timespan]::FromHours(1).TotalSeconds
    &#39;command_timeout&#39;         = 120

    &#39;custom_queries&#39;          = @(
        [ordered]@{
            &#39;query&#39;   = &#34;select count(name) from sys.databases as d where d.Name not in (&#39;master&#39;, &#39;msdb&#39;, &#39;model&#39;, &#39;tempdb&#39;)&#34;
            &#39;columns&#39; = @(
                [ordered]@{
                    &#39;name&#39; = &#39;instance.database_count&#39;
                    &#39;type&#39; = &#39;gauge&#39;
                    &#39;tags&#39; = @(
                        &#34;aws_account_alias:$AWSAccountAlias&#34;
                        &#34;sql_instance:$SqlInstance&#34;
                        &#34;stage:$stage&#34;
                    )
                }
            )
        }
    )
}
```

Let me do a quick breakdown, in case you aren&#39;t as familiar with this type of syntax in PowerShell.

1. `$Queries &#43;=` takes whatever existing object we have and replaces it with the current object &#43; the new object. This is why it&#39;s not performant for large scale work as it&#39;s basically creating a whole new copy of the collection with your new addition.
2. Next, I&#39;m using `[ordered]` instead of `[pscustomobject]` which in effect does the same thing, but ensures I&#39;m not having all my properties randomly sorted each time. Makes things a little easier to review. This is a shorthand syntax for what would be a much longer tedious process using `New-Object` and `Add-Member`.
3. Custom queries is a list, so I cast it with `@()` format, which tells PowerShell to expect a list. This helps json/yaml conversion be correct even if you have just a single entry. You can be more explicit if you want, like `[pscustomobject[]]@()` but since PowerShell ignores you mostly on trying to be type specific, it&#39;s not worth it. Don&#39;t try to make PowerShell be Go or C#. 😁

### Flip To Yaml

Ok, we have an object list, now we need to flip this to yaml.

It&#39;s not as easy as `$Queries | yq` because of the difference in paradigm with .NET.

We are working with a structured object.

Just look at `$Queries | Get-Member` and you&#39;ll probably get: `TypeName: System.Collections.Specialized.OrderedDictionary.` The difference is that Go/Linux paradigm is focused on text, not objects. With `powershell-yaml` module you can run `ConvertTo-Yaml $Queries` and it will work as it will handle the object transformation.

However, we can actually get there with PowerShell, just need to think of a text focused paradigm instead. This is actually pretty easy using `Converto-Json`.

```powershell
$SqlConfig = [ordered]@{&#39;instances&#39; = $Queries }
$SqlConfig | ConvertTo-Json -Depth 100 | &amp;&#39;C:\tools\yq.exe&#39; eval - --prettyPrint | Out-File $TargetConfig -Encoding UTF8
```

This takes the object, converts to json uses the provided cmdlet from PowerShell that knows how to properly take the object and all the nested properties and magically split to `JSON`.  Pass this into the `yq` executable, and behold, the magic is done.

You should have a nicely formatted yaml configuration file for Datadog.

If not, the dog will yip and complain with a bunch of red text in the log.

### Debug Helper

Use this on the remote instance to simplify some debugging, or even connect via SSM directly.

```powershell
&amp; &#34;$env:ProgramFiles\Datadog\Datadog Agent\bin\agent.exe&#34; stopservice
&amp; &#34;$env:ProgramFiles\Datadog\Datadog Agent\bin\agent.exe&#34; start-service

#Stream Logs without gui if remote session using:
Get-Content &#39;C:\ProgramData\Datadog\logs\agent.log&#39; -Tail 5 -Wait

# interactive debugging and viewing of console
# &amp; &#34;$env:ProgramFiles\Datadog\Datadog Agent\bin\agent.exe&#34; launch-gui
```

## Wrap Up

Ideally, use Chef, Ansible, Saltstack, DSC, or another tool to do this. However, sometimes you just need some flexible options for generating this type of content dynamically. Hopefully, you&#39;ll find this useful in your PowerShell magician journey and save some time.

I&#39;ve already found it useful in flipping json content for various tools back and forth. 🎉

A few scenarios that tooling like yq might prove useful could be:

- convert simple query results from json to yaml and store in git as config
- Flip an SSM Json doc to yaml
- Review a complex json doc by flipping to yaml for more readable syntax
- Confusing co-workers by flipping all their cloudformation from yaml to json or yaml from json. (If you take random advice like this and apply, you probably deserve the aftermath this would bring 🤣.)

