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
---

{{< admonition type="info" title="Any requests?" >}}
If you have any requests or improvements for this content, please comment below. It will open a GitHub issue for chatting further.
I'd be glad to improve with any additional quick help and in general like to know if anything here in particular was helpful to someone.
Cheers! 👍
{{< /admonition >}}

## Requirements

* Going forward most examples will focus on Powershell (>= v7), the modern successor to Windows PowerShell & PowerShell Core. Install this easily through chocolatey. Just install chocolatey, and then run `choco upgrade powershell powershell-core -y --source chocolatey` and you should have both 5.1 and core ready to go if your Windows version supports it. If you are on Windows 7 as a developer, there is no :taco: for you, just get upgraded already. Linux has it's own set of directions.
* Anything manipulating system might need admin, so run as admin in prompt.
* `Install-Module PSFramework` // I use this module for better logging and overall improvements in my quality of life. It's high quality, used by big projects like DbaTools and developed by a Powershell MVP with lots of testing. Forget regular `Write-Verbose` commands and just use the `Write-PSFMessage -Level Verbose -Message 'TacoBear'` instead.

### PSFramework

I use [PSFramework](http://bit.ly/2LHNpkE) on all my instances, as it's fantastic expansion to some core areas with PowerShell. This great module (along with other ancillary supporting ones like `PSModuleDevelopment` are well tested and usable for solving some issues in a much more elegant and robust manner than what is natively offered.

A few key elements it can help with are:

* Improving Configuration and variable handling without complex scope issues
* Improving overall logging and troubleshooting
* Improving object manipulation
* Runspace usability enhancements
* Scripted properties

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

### Setup for BetterCredentials

First, don't store anything as plain text in your files. That's a no no.
Secondly, try using [BetterCredentials](https://github.com/Jaykul/BetterCredentials "BetterCredentials Github Repo"). This allows you to use Windows Credential Manager to store your credentials and then easily pull them back in for usage later in other scripts you run. I've found it a great way to manage my local credentials to simplify my script running.

```powershell
Install-Module BetterCredentials -Force -AllowClobber
```

Personally, I use `BetterCredential\Get-Credential` which is `module\function` syntax if I'm not certain I've imported first. The reason is auto-discovery of module functions in PowerShell might use the default `Get-Credentials` that BetterCredentials overloads if you don't import first. BetterCredentials overrides the default cmdlets to improve for using CredentialManager, so make sure you import it, not assume it will be correctly imported by just referring to the function you are calling.


### Creating a Credential

Then to create credentials try using this handy little filter/function

```
<#
.Description
	Quick helper function for passing in credentials to create. Why filter? Planned on using with pipeline. Right now just using arguments in examples below.
#>
filter CredentialCreator
{
    [cmdletbinding()]
    param(
     [string]$UserName
    ,[string]$Pass
    ,[string]$Target
    )
    [string]$CalcTarget = ($Target,$UserName -ne '')[0]
    $SetCredentialSplat = @{
        Credential = [pscredential]::new($UserName,($Pass | ConvertTo-SecureString -AsPlainText -Force))
        Target = $CalcTarget
        Description = "BetterCredentials cached credential for $CalcTarget"
        Persistence = 'LocalComputer'
        Type = 'Generic'
    }
    BetterCredentials\Set-Credential @SetCredentialSplat
    Write-PSFMessage -Level Important -Message "BetterCredentials cached credential for $CalcTarget"

}
```

Example on using this quick function (if you don't want to use my quick helper, then just use code in the function as an example).

```powershell
#----------------------------------------------------------------------------#
#                   Example On Using to Create Credentials                   #
#----------------------------------------------------------------------------#
$pass = Read-Host 'Enter Network Pass'
CredentialCreator -UserName "$ENV:USERDOMAIN\$ENV:UserName" -Pass $pass -Target "$ENV:USERDOMAIN\$ENV:UserName"
CredentialCreator -UserName "TacoBear" -Pass 'TacoBearEatsThings' -Target "azure-tacobear-api"
```

### Clearing all credentials in credential repo

```powershell
Find-Credential * | Remove-Credential
```

### Using Credentials in a Script

Using with credential object

```powershell
Do-Something -Credential (Find-Credential 'azure-tacobear-api')
```

Extracting out the raw name and password for things that won't take the credential object, but want the password as a string (uggh)

```powershell
$cred = Find-Credential 'azure-tacobear-api'
$UserName = $cred.GetNetworkCredential().UserName   #Note that this could be an access key if you wanted.
$AccessKey = $cred.GetNetworkCredential().Password
```

### Using Basic Authorization With REST

When leveraging some api methods you need to encode the header with basic authentication to allow authenticated requests. This is how you can do that in a script without having to embed the credentials directly, leveraging `BetterCredentials` as well.

```powershell
#seems to work for both version 5.1 and 6.1
param(
    $Uri = ''
)

Import-Module BetterCredentials
$cred = Find-Credential 'mycredentialname'
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

```powershell
$Items = Get-ChildItem
```

- The default go to for major loop work.
- Default first positional argument is `-Process {}` but mostly that is not provided and just the curly braces.
- It is by default the slowest on a scale of raw performance.
- Each item is loaded into memory, and it frees memory as it goes through pipeline.
- Pipelines can be chained passing input as the pipeline progresses.
- Break, continue, return behave differently as you are using a function, not a language operator.

```powershell
$Items | ForEach-Object { $_.Name.ToString().ToLower() }
```

- Magic operator.
- Seriously, I've seen it called that.
- It's only in version >= 4 [Magic Operators](https://bit.ly/3l1i3Vn).
- Loads all results into memory before running, so can be great performance boost for certain scenarios that a `ForEach-Object` would be slower at.

```powershell
$Items.ForEach{ $_.Name.ToString().ToLower() }
```

- This is the standard `foreach` loop.
- It is the easiest to use and understand for someone new to PowerShell, but highly recommend that it is used in exceptions and try to stick with `ForEach-Object` as your default for idiomatic PowerShell if you are learning.
- Standard break, continue, return behavior is a bit easier to understand.

```powershell
foreach ($item in $Items) { $_.Name.ToString().ToLower() }
```

- If you find yourself exploring delegate functions in PowerShell, you should probably just use C# or find a different language as you are probably trying to screw a nail with a hammer. 😁

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

{{< gist sheldonhull  "9bdb6ae57121e3c9ddc3fa594119c476" >}}

## Other Cheatsheets

Trying a new gist driven approach here, so this will auto update.

{{< gist sheldonhull c738117686c3e9cf7d717e1301e250b7 >}}

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
