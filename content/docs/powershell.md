---
title: powershell
date: 2019-03-19
summary: A cheatsheet for some interesting PowerShell related concepts that
  might benefit others looking for some tips and tricks
slug: powershell
permalink: /docs/powershell
comments: true
tags:
  - development
  - powershell
toc:
  enable: true
  keepStatic: false
  auto: true
typora-root-url: ../../static
typora-copy-images-to:  ../../static/images
---

{{< admonition type="info" title="Any requests?" >}}
If you have any requests or improvements for this content, please comment below. It will open a GitHub issue for chatting further.
I'd be glad to improve with any additional quick help and in general like to know if anything here in particular was helpful to someone.
Cheers! 👍
{{< /admonition >}}

## Requirements

- Going forward most examples will focus on Powershell (>= v7), the modern successor to Windows PowerShell & PowerShell Core. Install this easily through chocolatey. Just install chocolatey, and then run `choco upgrade powershell powershell-core -y --source chocolatey` and you should have both 5.1 and core ready to go if your Windows version supports it. If you are on Windows 7 as a developer, there is no :taco: for you, just get upgraded already. Linux has it's own set of directions.
- Anything manipulating system might need admin, so run as admin in prompt.
- `Install-Module PSFramework` // I use this module for better logging and overall improvements in my quality of life. It's high quality, used by big projects like DbaTools and developed by a Powershell MVP with lots of testing. Forget regular `Write-Verbose` commands and just use the `Write-PSFMessage -Level Verbose -Message 'TacoBear'` instead.

### PSFramework

I use [PSFramework](http://bit.ly/2LHNpkE) on all my instances, as it's fantastic expansion to some core areas with PowerShell. This great module (along with other ancillary supporting ones like `PSModuleDevelopment` are well tested and usable for solving some issues in a much more elegant and robust manner than what is natively offered.

A few key elements it can help with are:

- Improving Configuration and variable handling without complex scope issues
- Improving overall logging and troubleshooting
- Improving object manipulation
- Runspace usability enhancements
- Scripted properties

## Development (Optional)

1. Install VSCode (Users)
2. `choco upgrade vscode-powershell -y` or install in extension panel in VSCode. If you are using ISE primarily.... move on already.

## String Formatting

| Type               | Example                                                | Output                      | Notes                                                               |
| ------------------ | ------------------------------------------------------ | --------------------------- | ------------------------------------------------------------------- |
| Formatting Switch  | 'select {0} from sys.tables' -f 'name'                 | select name from sys.tables | Same concept as .NET \[string]::Format(). Token based replacement   |
| .NET String Format | \[string]::Format('select {0} from sys.tables','name') | select name from sys.tables | Why would you do this? Because you want to showoff your .NET chops? |

## Math & Number Conversions

| From                | To      | Example           | Output              | Notes                                     |
| ------------------- | ------- | ----------------- | ------------------- | ----------------------------------------- |
| scientific notation | Decimal | 2.19095E+08 / 1MB | 208.945274353027 MB | Native PowerShell, supports 1MB, 1KB, 1GB |

## Date & Time Conversion

Converting dates to Unix Epoc time can be challenging without using the correct .NET classes. There is some built in functionality for converting dates such as `(Get-Date).ToUniversalTime() -UFormat '%s'` but this can have problems with time zone offsets. A more consistent approach would be to leverage the following. This was very helpful to me in working with Grafana and InfluxDb which commonly leverage Unix Epoc time format with seconds or milliseconds precision.

```powershell
$CurrentTime = [DateTimeOffset]::new([datetime]::now,[DateTimeOffset]::Now.Offset);

# Unix Epoc time starts from this date
$UnixStartTime = [DateTimeOffset]::new(1970, 1, 1, 0, 0, 0,[DateTimeOffset]::Now.Offset);

# To Use This Now On Timestamp you could run the following
$UnixTimeInMilliseconds = [Math]::Floor( ((get-date $CurrentTime) - $UnixStartTime).TotalMilliseconds)

# To Use with Different Time just change the `$CurrentTime` to another value like so
$UnixTimeInMilliseconds = [Math]::Floor( ((get-date $MyDateValue) - $UnixStartTime).TotalMilliseconds)
```

## Credential Management

### Setup

Look at [SecretsManagement](https://github.com/PowerShell/SecretManagement).

SecureString should be considered deprecated.
It provides a false illusion of security mostly, and it's better to approach with other methods.

- [Obsolete the SecureString Type Discussion](https://github.com/dotnet/runtime/issues/30612#issuecomment-523534346)
- [DE0001](https://github.com/dotnet/platform-compat/blob/master/docs/DE0001.md)

Depending on your technology stack, the best way handle this is to authenticate using a credential library.

For example, if pulling service account credentials for SQL Server in AWS, you could put these in AWS Secrets Manager and use something like:

```powershell
Import-module AWS.Tools.SecretsManager
Write-Warning "Poor Example"
Write-Warning "This exposes the credential in local memory and potentionally logging. It is for demo purposes"
$SecretString = (Get-SECSecretValue 'service-accounts/sql-admin' -ProfileName 'myprofile').SecretString | ConvertFrom-Json -Depth 1
$SecretString.UserName
$SecretString.Password

Write-Host "A better way, you could use this to directly create a secure credential object without creating a variable to store the plain text"
(Get-SECSecretValue 'service-accounts/sql-admin' -ProfileName 'myprofile').SecretString |
ConvertFrom-Json -Depth 1 |
ForEach-Object {
    [pscredential]::new( $_.username, ($_.password | ConvertTo-SecureString -AsPlainText -Force))
}
```

The SecretsManagement powershell module supports a variety of backends such as 1Password, Thycotic Secrets Server, Lastpass, and more.

[↗️ List of Secrets Management Modules](https://www.powershellgallery.com/packages?q=Tags%3A%22SecretManagement%22)

### Using Basic Authorization With REST

When leveraging some api methods you need to encode the header with basic authentication to allow authenticated requests.

```powershell
#seems to work for both version 5.1 and 6.1
param(
    $Uri = ''
)
# Load From SecretsManagement module ideally
$AccessId = $cred.GetNetworkCredential().UserName
$AccessKey = $cred.GetNetworkCredential().Password
$Headers = @{
    Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes( ('{0}:{1}' -f $AccessId, $AccessKey) ))
}
$results = Invoke-RestMethod -Uri $Uri -Header $Headers
$results
```

## Load Functions from a Folder

Prefer to use modules, but for quick adhoc work, you can organize your work in a folder and use a subfolder called functions. I find this better than trying to create one large script file with multiple functions in it.

```powershell
$FunctionsFolder = Join-Path $toolsDir 'functions'
Get-ChildItem -Path $FunctionsFolder -Filter *.ps1 | ForEach-Object {
    Write-PSFMessage -Level Verbose -Message "Loading: $($_.FullName)"
    . "$($_.FullName)"
}
```

## Select Object Manipulation

### Expanding Nested Objects

One thing that I've had challenges with is expanding nested objects with AWSPowershell, as a lot of the types aren't formatted for easy usage without expansion.
For example, when expanding the basic results of `Get-EC2Instance` you can try to parse out the state, but it won't behave as expected.

For example, if you run:

```powershell
(Get-EC2Instance -Filter $ec2Filter).Instances | Select-Object InstanceId, State
```

| InstanceId | State                          |
| ---------- | ------------------------------ |
| i-taco1    | Amazon.EC2.Model.InstanceState |
| i-taco2    | Amazon.EC2.Model.InstanceState |
| i-taco3    | Amazon.EC2.Model.InstanceState |

Trying to expand gets you the state, but now you don't have the original object alongside it.

| Code | Name    |
| ---- | ------- |
| 16   | running |
| 16   | running |
| 16   | running |

PSFramework makes this easy to work with by simply referencing the object properties for parsing in the `Select-PSFObject` statement.

```powershell
(Get-EC2Instance -Filter $ec2Filter).Instances | Select-PSFObject InstanceId, 'State.Code as StateCode', 'State.Name as StateName'
```

The result is exactly you'd you need to work with

| InstanceId | StateCode | StateName |
| ---------- | --------- | --------- |
| i-taco1    | 16        | running   |
| i-taco2    | 16        | running   |
| i-taco3    | 16        | running   |

### Get / Set Accessors in PowerShell

In C# you use get/set accessors to have more control over your properties. In PowerShell, thanks to PSFramework, you can simplify object pipelines by using `Select-PSFObject` to do the equivalent and have a scripted property that handles a script block to provide a scripted property on your object.

For example, in leveraging AWS Profiles, I wanted to get a region name mapped to a specific profile as a default region. You can do this in a couple steps using `ForEach-Object` and leverage `[pscustomobject]`, or you can simplify it greatly by running `Select-PSFObject` like this:

```powershell
Get-AWSCredentials -ListProfileDetail  |  Select-PSFObject -Property ProfileName -ScriptProperty @{
    region = @{
        get = {
            switch ($this.ProfileName)
            {
                'taco1' {'us-east-1'}
                'taco2' {'us-east-1'}
                'taco3' {'us-east-1'}
                'taco4' {'eu-west-1'}
                'taco5' {'us-west-2'}
                'taco6' {'us-east-1'}
                default {'us-east-1'}
            }
        }
    }
}
```

Another good example might be the desire to parse out the final key section from S3, to determine what the file name would actually be for easier filtering or searching. In this case, a simple script property could parse out the name, and then return the last item in the array using Powershell's shortcut of `$array[-1]` to get the last item.

```powershell
Get-S3Object -BucketName 'tacoland' | Select-PSFObject -ScriptProperty @{
    BaseName = @{
        get  = {
            (($this.Name  -split '/')[-1])
        }
    }
}
```

## Parallel Tips & Tricks

If you are using `-Parallel` with the newer runspaces feature in PowerShell 7 or greater, then long running operations such as queries or operations that take a while might be difficult to track progress on.
In my case, I wanted to be able to see the progress for build process running in parallel and found using the synchronized hashtable I was able to do this.

```powershell
$hash = [hashtable]::Synchronized(@{})
$hash.counter = 1
@(1..100) | ForEach-Object -Throttle 8 -Parallel {
    $hash = $using:hash
    $hash.counter++
    Write-Host "Progress: $($hash.counter)"
    Start-Sleep -Milliseconds (Get-Random -Minimum 1 -Maximum 10)
}
$hash.counter
```

I put the delay in there to show that the asynchronous nature doesn't mean 1-100, it could do some faster than others and this shows on the output with content like:

```text
Progress: 1
Progress: 2
Progress: 3
Progress: 4
Progress: 6 <---- parallel, no promise of which runspace finishes first
Progress: 5
```

A more advanced way to use this might be to help guage how long something might take to complete when running parallel SQL Server queries.

```powershell
#################################################################
# Quick Estimate of Pipeline Completion with Parallel Runspaces #
#################################################################

$TotalToProcess = 150
$StopwatchProcess = [diagnostics.stopwatch]::StartNew()

$hash = [hashtable]::Synchronized(@{ })
$hash.counter = 1



@(1..$TotalToProcess ) | ForEach-Object -Throttle 8 -Parallel {
    $d = $_
    $PerItemStopwatch = [diagnostics.stopwatch]::StartNew()
    $hash = $using:hash

    $hash.counter++
    $x = $hash.counter

    $ApproxSecondsEachSoFar = $hash.counter / $using:StopwatchProcess.Elapsed.TotalSeconds
    $RemainingCount = $using:TotalToProcess - $x
    $ApproxRemainingTime =  $RemainingCount * $ApproxSecondsEachSoFar
    Write-Host ( "{0:hh\:mm\:ss\.fff} | {1} | $x of $using:TotalToProcess | remaining time {3} | {2}" -f $PerItemStopwatch.Elapsed, 'Run-ThisStuff', $d, [timespan]::FromSeconds($ApproxRemainingTime).ToString())
    Start-Sleep -Milliseconds (Get-Random -Minimum 1 -Maximum 1500)
}
```

## The Various Iteration Methods Possible

PowerShell supports a wide range of iteration options.
Not all are idiomatic to the language, but can be useful to know about.

I recommend when possible to default to `$Items | ForEach-Object { }` as your default approach.
This ensures a pipeline driven solution that can be enhanced later or piped to other cmdlets that are compatible with the pipeline.

{{< admonition type="warning" title="Gotcha" >}}
This is a cmdlet, not a PowerShell language feature. This means that the behavior of break, continue, and return all operate differently in this ForEach-Object process block than when doing a `foreach` loop.
{{< /admonition >}}

These are ranked in the order I recommend using by default.

Setup the results to test with.

```powershell
$Items = Get-ChildItem
```

### ForEach-Object

```powershell
$Items | ForEach-Object { $_.Name.ToString().ToLower() }
```

- The default go to for major loop work.
- Default first positional argument is `-Process {}` but mostly that is not provided and just the curly braces.
- It is by default the slowest on a scale of raw performance.
- Each item is loaded into memory, and it frees memory as it goes through pipeline.
- Pipelines can be chained passing input as the pipeline progresses.
- Break, continue, return behave differently as you are using a function, not a language operator.

- Magic operator.
- Seriously, I've seen it called that.
- It's only in version >= 4 [Magic Operators](https://bit.ly/3l1i3Vn).
- Loads all results into memory before running, so can be great performance boost for certain scenarios that a `ForEach-Object` would be slower at.

### ForEach Magic Operator

```powershell
$Items.ForEach{ $_.Name.ToString().ToLower() }
```

- This is the standard `foreach` loop.
- It is the easiest to use and understand for someone new to PowerShell, but highly recommend that it is used in exceptions and try to stick with `ForEach-Object` as your default for idiomatic PowerShell if you are learning.
- Standard break, continue, return behavior is a bit easier to understand.

### foreach loop

```powershell
foreach ($item in $Items) { $_.Name.ToString().ToLower() }
```

### Linq

If you find yourself exploring delegate functions in PowerShell, you should probably just use C# or find a different language as you are probably trying to screw a nail with a hammer. 😁

```powershell
$f = [System.Func[string, string]] { param($i) $i.ToString().ToLower() }
$f.Invoke($Items.Name)
```

## Cool Tricks

Output the results of your code into a Console GUI Gridview.
This recent module provides a fantastic solution to allowing filtering and selection of results passed into it.

Install it with: `Install-Module Microsoft.PowerShell.ConsoleGuiTools -Scope CurrentUser -Confirm:$false`

```powershell
# Gather filtered list of EC2 Instances from AWS and then provide a console gui to select and filter the results further
$Filters = @([Amazon.EC2.Model.Filter]::new('tag:{{TAGHERE}}','{{TAG VALUE}}')
(Get-EC2Instance -Filter $Filters)).Instances| Select-PSFObject InstanceId, PublicIpAddress,PrivateIpAddress,Tags,'State.Code as StateCode', 'State.Name as StateName'  -ScriptProperty @{
    Name = @{
        get  = {
            $this.Tags.GetEnumerator().Where{$_.Key -eq 'Name'}.Value
        }
    }
} | Out-ConsoleGridView
```

For quick access, save this to a Visual Studio Code snippet like below:

```json
"ec2-filtered-list": {
    "prefix": "ec2-filtered-list",
    "description": "Get EC2 Filtered results and output to interactive ConsoleGridView",
    "body": [
        "# Gather filtered list of EC2 Instances from AWS and then provide a console gui to select and filter the results further",
        "\\$Filters = @([Amazon.EC2.Model.Filter]::new('tag:${1:TagKey}','${2:TagValue}')",
        "(Get-EC2Instance -Filter \\$Filters)).Instances| Select-PSFObject InstanceId, PublicIpAddress,PrivateIpAddress,Tags,'State.Code as StateCode', 'State.Name as StateName'  -ScriptProperty @{",
        "    Name = @{",
        "        get  = {",
        "            \\$this.Tags.GetEnumerator().Where{\\$_.Key -eq 'Name'}.Value",
        "        }",
        "    }",
        "} | Out-ConsoleGridView"
    ]
}
```

## Puzzles - Fizz Buzz

I did this to participate in Code Golf, and felt pretty good that I landed in 112 🤣 with this.
Really pains me to write in the code-golf style.

{{< gist sheldonhull  "3ea6fd6cafe210edb1d71b5e8d3d1696" >}}

## Syncing Files Using S5Cmd

### Get S5Cmd

Older versions of PowerShell (4.0) and the older AWSTools don't have the required ability to sync down a folder from a key prefix.
This also performs much more quickly for a quick sync of files like backups to a local directory for initiating restores against.

In testing down by the tool creator, they showed this could saturate a network for an EC2 with full download speed and be up to 40x faster than using CLI with the benefit of being a small self-contained Go binary as well.

Once the download of the tooling is complete you can run a copy from s3 down to a local directory by doing something similar to this, assuming you have rights to the bucket.
If you don't have rights, you'll want to set environment variables for the access key and secret key such as:

```powershell
Import-Module aws.tools.common, aws.tools.SecurityToken
Set-AWSCredential -ProfileName 'MyProfileName' -Scope Global
$cred = Get-STSSessionToken -DurationInSeconds ([timespan]::FromHours(8).TotalSeconds)
@"
`$ENV:AWS_ACCESS_KEY_ID = '$($cred.AccessKeyId)'
`$ENV:AWS_SECRET_ACCESS_KEY = '$($cred.SecretAccessKey)'
`$ENV:AWS_SESSION_TOKEN  = '$($cred.SessionToken)'
"@
```

You can copy that string into your remote session to get the access tokens recognized by the s5cmd tool and allow you to grab files from another AWS account S3 bucket.

> NOTE: To sync a full "directory" in s3, you need to leave the asteriks at the end of the key as demonstrated.

### Windows

#### Install S5Cmd For Windows

```powershell
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ToolsDir = 'C:\tools'
$ProgressPreference = 'SilentlyContinue'
$OutZip = Join-Path $ToolsDir 's5cmd.zip'
Invoke-WebRequest -Uri 'https://github.com/peak/s5cmd/releases/download/v1.2.1/s5cmd_1.2.1_Windows-64bit.zip' -UseBasicParsing -OutFile $OutZip

# Not available on 4.0 Expand-Archive $OutZip -DestinationPath $ToolsDir

Add-Type -assembly 'system.io.compression.filesystem'
[io.compression.zipfile]::ExtractToDirectory($OutZip, $ToolsDir)
$s5cmd = Join-Path $ToolsDir 's5cmd.exe'
&$s5cmd version
```

#### Windows Sync A Directory From To Local

```powershell
$ErrorActionPreference = 'Stop'
$BucketName = ''
$KeyPrefix = 'mykeyprefix/anothersubkey/*'

$Directory = "C:\temp\adhoc-s3-sync-$(Get-Date -Format 'yyyy-MM-dd')\$KeyPrefix"
New-Item $Directory -ItemType Directory -Force -ErrorAction SilentlyContinue
$s5cmd = Join-Path $ToolsDir 's5cmd.exe'
Write-Host "This is what is going to run: `n&$s5cmd cp `"s3://$bucketname/$KeyPrefix`" $Directory"
Read-Host 'Enter to continue if this makes sense, or cancel (ctrl+c)'


&$s5cmd cp "s3://$bucketname/$KeyPrefix" $Directory
```

## AWS Tools

### Install AWS.Tools

Going forward, use AWS.Tools modules for newer development.
It's much faster to import and definitely a better development experience in alignment with .NET SDK namespace approach.

Use their installer module to simplify versioning and avoid conflicts with automatic cleanup of prior SDK versions.

```powershell
install-module 'AWS.Tools.Installer' -Scope CurrentUser

$modules = @(
    'AWS.Tools.Common'
    'AWS.Tools.CostExplorer'
    'AWS.Tools.EC2'
    'AWS.Tools.Installer'
    'AWS.Tools.RDS'
    'AWS.Tools.S3'
    'AWS.Tools.SecretsManager'
    'AWS.Tools.SecurityToken'
    'AWS.Tools.SimpleSystemsManagement'
)

Install-AWSToolsModule $modules -Cleanup -Force
```

### Using Systems Manager Parameters (SSM) To Create A PSCredential

```powershell
$script:SqlLoginName = (Get-SSMParameterValue -Name $SSMParamLogin -WithDecryption $true).Parameters[0].Value
$script:SqlPassword = (Get-SSMParameterValue -Name $SSMParamPassword -WithDecryption $true).Parameters[0].Value | ConvertTo-SecureString -AsPlainText -Force
$script:SqlCredential = [pscredential]::new($script:SqlLoginName, $script:SqlPassword)
```

### Using AWS Secrets Manager To Create a PSCredential

Note that this can vary in how you read it based on the format.
The normal format for entries like databases seems to be: `{"username":"password"}` or similar.

```powershell
$Secret = Get-SECSecretValue -SecretId 'service-accounts/my-secret-id' -ProfileName $ProfileName
```

### Generate a Temporary Key

Useful for needing to generate some time sensitive access credentials when connected via SSM Session and needing to access another account's resources.

```powershell
Import-Module aws.tools.common, aws.tools.SecurityToken
Set-AWSCredential -ProfileName 'ProfileName' -scope Global
$cred = Get-STSSessionToken -DurationInSeconds ([timespan]::FromHours(8).TotalSeconds)
@"
`$ENV:AWS_ACCESS_KEY_ID = '$($cred.AccessKeyId)'
`$ENV:AWS_SECRET_ACCESS_KEY = '$($cred.SecretAccessKey)'
`$ENV:AWS_SESSION_TOKEN  = '$($cred.SessionToken)'
"@
```

### Install SSM Agent Manually

This is based on the AWS install commands, but with a few enhancements to better work on older Windows servers.

```powershell
# https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-install-win.html
$ProgressPreference = 'SilentlyContinue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Write-Host "Downloading installer"
$InstallerFile = Join-Path $env:USERPROFILE 'Downloads\SSMAgent_latest.exe'
$invokeWebRequestSplat = @{
    Uri = 'https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/windows_amd64/AmazonSSMAgentSetup.exe'
    OutFile = $InstallerFile
}
Invoke-WebRequest @invokeWebRequestSplat

Write-Host "Installing SSM Agent"
$startProcessSplat = @{
    FilePath     = $InstallerFile
    ArgumentList = '/S'
}
Start-Process @startProcessSplat

Write-Host "Cleaning up ssmagent download"
Remove-Item $InstallerFile -Force
Restart-Service AmazonSSMAgent
```

### AWS PowerShell Specific Cheatsheets

{{< gist sheldonhull  "9534958236fbc3973e704f648cec27e7" >}}

## Pester

Many changes occurred after version 5.
This provides a few examples on how to leverage Pester for data driven tests with this new format.

### BeforeAll And BeforeDiscovery

One big change was the two scopes.
Read the Pester docs for more details.

The basic gist is that BeforeAll is in the "run" scope, while the test generation is BeforeDiscovery.
While older versions of Pester would allow a lot more `foreach` type loops, this should be in the discovery phase now, and then `-Foreach` (aka `-TestCases`) hashtable can be used to iterate more easily now through result sets.

<!-- ### Using Inline Script With PesterContainer -->

### Pester Container To Help Setup Data Driven Tests

Example of setting up inputs for the test script from your InvokeBuild job.

```powershell
$pc = New-PesterContainer -Path (Join-Path $BuildRoot 'tests\configuration.tests.ps1') -Data @{
    credential_user1 = Get-PSFConfigValue "Project.$ENV:GROUP.credential.user1" -NotNull
    credential_user2 = Get-PSFConfigValue "Project.$ENV:GROUP.credential.user2" -NotNull
    sql_instance     = Get-PSFConfigValue "Project.$ENV:GROUP.instance_address" -NotNull
    database_list    = $DatabaseList
}
```

### Pester Configuration Object

Now, you'd add this `PesterContainer` object to the `PesterConfiguration`.

{{< admonition type="Tip" title="Explore PesterConfiguration" open=false >}}
If you want to explore the pester configuration try navigating through it with: `PesterConfiguration]::Default` and then explore sub-properties with actions like: `[PesterConfiguration]::Default.Run | Get-Member`.
{{< /admonition >}}

```powershell

$configuration = [PesterConfiguration]@{
    Run        = @{
        Path        = (Join-Path $BuildRoot 'tests\configuration.tests.ps1')
        ExcludePath = '*PSFramework*', '*_tmp*'
        PassThru    = $True
        Container   = $pc
    }
    Should     = @{
        ErrorAction = 'Continue'
    }
    TestResult = @{
        Enabled      = $true
        OutputPath   = (Join-Path $ArtifactsDirectory 'TEST-configuration-results.xml')
        OutputFormat = 'NUnitXml'

    }
    Output     = @{
        Verbosity = 'Diagnostic'
    }
}


```

This pester configuration is a big shift from the parameterized arguments provided in version < 5.

### Invoke Pester

Run this with: `Invoke-Pester -Configuration $Configuration`

To improve the output, I took a page from `PSFramework` and used the summary counts here, which could be linked to a chatops message.
Otherwise the diagnostic output should be fine.

```powershell
$testresults = @()
$testresults +=  Invoke-Pester -Configuration $Configuration


Write-Host '======= TEST RESULT OBJECT ======='

foreach ($result in $testresults)
{
    $totalRun += $result.TotalCount
    $totalFailed += $result.FailedCount
    # -NE 'Passed'
    $result.Tests | Where-Object Result | ForEach-Object {
        $testresults += [pscustomobject]@{
            Block   = $_.Block
            Name    = "It $($_.Name)"
            Result  = $_.Result
            Message = $_.ErrorRecord.DisplayErrorMessage
        }
    }
}

#$testresults | Sort-Object Describe, Context, Name, Result, Message | Format-List
if ($totalFailed -eq 0) { Write-Build Green "All $totalRun tests executed without a single failure!" }
else { Write-Build Red "$totalFailed tests out of $totalRun tests failed!" }
if ($totalFailed -gt 0)
{
    throw "$totalFailed / $totalRun tests failed!"
}

```

### Use Test Artifact

Use the artifact generated in the Azure Pipelines yaml to publish pipeline test results.

```yaml
## Using Invoke Build for running

- task: PowerShell@2
  displayName: Run Pester Tests
  inputs:
    filePath: build.ps1
    arguments: '-Task PesterTest -Configuration $(Configuration)'
    errorActionPreference: 'Continue'
    pwsh: true
    failOnStderr: true
  env:
    SYSTEM_ACCESSTOKEN: $(System.AccessToken)
- task: PublishTestResults@2
  displayName: Publish Pester Tests
  inputs:
    testResultsFormat: 'NUnit'
    testResultsFiles: '**/TEST-*.xml'     # <---------  MATCHES MULTIPLE TEST FILES AND UPLOADED
    failTaskOnFailedTests: true
  alwaysRun: true                         # <---------  Or it won't upload if test fails

```

## Azure Pipelines Tips

### Dynamic Link to a Pipeline Run

Create a link to a pipeline for your chatops.

```powershell
$button = "${ENV:SYSTEM_TEAMFOUNDATIONCOLLECTIONURI}${ENV:SYSTEM_TEAMPROJECT}/_build/results?buildId=$($ENV:BUILD_BUILDID)&view=logs"
```

### Helper Function for Reporting Progress on Task

This is an ugly function, but hopefully useful as a jump start when in a hurry. 😁

This primarily allows you to quickly report:

- ETA
- Percent complete on a task
- Log output on current task

Needs more refinement and probably should just be an invoke build function, but for now it's semi-useful for some long-running tasks

Setup up your variables like demonstrated.
This doesn't handle nested task creation, so parentid won't be useful for anything other than local progress bar nesting.

```powershell
$ProgressId =  [int]$RANDOM.Next(1, 1000)
$ProgressCounter = 0
$ProgressTotalToProcess = 1000
$ProgressStopwatch =  [diagnostics.stopwatch]::new()
$ProgressStopwatch.Start()
foreach ($i in $List.Items)
{
    $ProgressCounter++
        $ProgressSplat = @{
        Activity       =  '>>> Tacos'
        StatusMessage  =  "$($i.Foo).$($i.Bar)"
        ProgressId     =  $ProgressId
        Counter        =  $Counter
        TotalToProcess =  $ProgressTotalToProcess
        Stopwatch      =  $ProgressStopwatch
        # ParentId       =  $ParentProgressId
        BuildOutput    = $true # for write-host special commands to show task progress in pipelines
    }
    Write-BuildProgressInfo @ProgressSplat
}
```

Include this function in InvokeBuild job.
If not using InvokeBuild, you'll need to change `Write-Build` to `Write-Host` and remove the color attribute.

```powershell
function Write-BuildProgressInfo
{
    [cmdletbinding()]
    param(
        [string]$Activity='doing stuff',
        [string]$StatusMessage,
        [int]$ProgressId,
        [int]$Counter,
        [int]$TotalToProcess,
        $StopWatch,
        $ParentId,
        [switch]$Complete,
        [switch]$BuildOutput
    )
    [hashtable]$writeProgressSplat = @{}
    $writeProgressSplat.Add('Id', $ProgressId)
    $writeProgressSplat.Add('Activity'  , $Activity)
    if ($ParentId)
    {
        $writeProgressSplat.Add('ParentId', $ParentId )
    }

    # Write-Debug($PSBoundParameters.GetEnumerator() | Format-Table -AutoSize| Out-String)
    if ($Counter -lt $TotalToProcess -and $Complete -eq $false)
    {
        #still processing
        [int]$PercentComplete = [math]::Ceiling(($counter/$TotalToProcess)*100)
        try { [int]$AvgTimeMs = [math]::Ceiling(($StopWatch.ElapsedMilliseconds / $counter)) } catch { [int]$AvgTimeMs=0 } #StopWatch from beginning of process

        [int]$RemainingTimeSec = [math]::Ceiling( ($TotalToProcess - $counter) * $AvgTimeMs/1000)
        [string]$Elapsed = '{0:hh\:mm\:ss}' -f $StopWatch.Elapsed

        $writeProgressSplat.Add('Status', ("Batches: ($counter of $TotalToProcess) | Average MS: $($AvgTimeMs)ms | Elapsed Secs: $Elapsed | $($StatusMessage)"))
        $writeProgressSplat.Add('PercentComplete', $PercentComplete)
        $writeProgressSplat.Add('SecondsRemaining', $RemainingTimeSec)
        Write-Progress @writeProgressSplat
        if ($BuildOutput)
        {
            Write-Build DarkGray ("$Activity | $PercentComplete | ETA: $('{0:hh\:mm\:ss\.fff}' -f [timespan]::FromSeconds($RemainingTimeSec)) |  Batches: ($counter of $TotalToProcess) | Average MS: $($AvgTimeMs)ms | Elapsed Secs: $Elapsed | $($StatusMessage)")
            Write-Build DarkGray "##vso[task.setprogress value=$PercentComplete;]$Activity"
        }
    }
    else
    {
        [int]$PercentComplete = 100
        try { [int]$AvgTimeMs = [math]::Ceiling(($StopWatch.ElapsedMilliseconds / $TotalToProcess)) } catch { [int]$AvgTimeMs=0 } #StopWatch from beginning of process
        [string]$Elapsed = '{0:hh\:mm\:ss}' -f $StopWatch.Elapsed

        $writeProgressSplat.Add('Completed', $true)
        $writeProgressSplat.Add('Status', ("Percent Complete: 100% `nAverage MS: $($AvgTimeMs)ms`nElapsed: $Elapsed"))
        Write-Progress @writeProgressSplat
        if ($BuildOutput)
        {
            Write-Build DarkGray ("COMPLETED | $Activity | $PercentComplete | ETA: $('{0:hh\:mm\:ss\.fff}' -f $RemainingTimeSec) |  Batches: ($counter of $TotalToProcess) | Average MS: $($AvgTimeMs)ms | Elapsed Secs: $Elapsed | $($StatusMessage)")
        }
    }
}
```

## File Manipulation

Rename Images With a Counter in A Directory

```powershell
$dir = 'images'
$imagegroup = 'my-images'
Get-ChildItem $dir -Filter *.png | ForEach-Object -Begin { $x = 0 } -Process {
    $file = $_.FullName
    $newname = Join-Path ($file | Split-Path  ) "$imagegroup-$x.png"
    $x++
    Rename-Item $file $newname
}
```
