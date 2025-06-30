---
title: powershell
date: 2019-03-19
summary: A cheatsheet for some interesting PowerShell related concepts that
  might benefit others looking for some tips and tricks
slug: powershell
permalink: /notes/powershell
comments: true
tags:
  - development
  - powershell
toc:
  enable: true
  keepStatic: false
  auto: true
---

With magic like this, why use bash!

<img src="images/powershell-avatar.svg">https://github.com/PowerShell/PowerShell</img>


## Requirements

- Going forward most examples will focus on Powershell (>= v7), the modern successor to Windows PowerShell & PowerShell Core. Install this easily through chocolatey. Just install chocolatey, and then run `choco upgrade powershell powershell-core -y --source chocolatey` and you should have both 5.1 and core ready to go if your Windows version supports it. If you are on Windows 7 as a developer, there are no tacos for you, just get upgraded already. Linux has its own set of directions.
- Anything manipulating system might need admin, so run as admin in prompt.
- `Install-Module PSFramework` // I use this module for better logging and overall improvements in my quality of life. It's high quality, used by big projects like DbaTools and developed by a Powershell MVP with lots of testing. Forget regular `Write-Verbose` commands and just use the `Write-PSFMessage -Level Verbose -Message 'TacoBear'` instead.

### PSFramework

I use [PSFramework](http://bit.ly/2LHNpkE) on all my instances, as it's a fantastic expansion to some core areas with PowerShell. This great module (along with other ancillary supporting ones like `PSModuleDevelopment`) are well tested and usable for solving some issues in a much more elegant and robust manner than what is natively offered.

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
| .NET String Format | \[string]::Format('select {0} from sys.tables','name') | select name from sys.tables | Why would you do this? Because you want to show off your .NET chops? |

## Math & Number Conversions

| From                | To      | Example           | Output              | Notes                                     |
| ------------------- | ------- | ----------------- | ------------------- | ----------------------------------------- |
| scientific notation | Decimal | 2.19095E+08 / 1MB | 208.945274353027 MB | Native PowerShell, supports 1MB, 1KB, 1GB |

## Date & Time Conversion

Converting dates to Unix Epoc time can be challenging without using the correct .NET classes. There is some built in functionality for converting dates such as `(Get-Date).ToUniversalTime() -UFormat '%s'`, but this can have problems with time zone offsets. A more consistent approach would be to leverage the following. This was very helpful to me when working with Grafana and InfluxDb which commonly use Unix Epoc time format with seconds or milliseconds precision.

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
Write-Warning "This exposes the credential in local memory and potentially logging. It is for demo purposes"
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

SecretsManagement powershell module supports a variety of backends such as 1Password, Thycotic Secrets Server, Lastpass, and more.

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

Prefer to use modules, but for quick ad hoc work, you can organize your work in a folder and use a subfolder called functions. I find this better than trying to create one large script file with multiple functions in it.

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

The result is exactly what you'd need to work with

| InstanceId | StateCode | StateName |
| ---------- | --------- | --------- |
| i-taco1    | 16        | running   |
| i-taco2    | 16        | running   |
| i-taco3    | 16        | running   |

### Get / Set Accessors in PowerShell

In C# you use get / set accessors to have more control over your properties. In PowerShell, thanks to PSFramework, you can simplify object pipelines by using `Select-PSFObject` to do the equivalent and have a scripted property that handles a script block to provide a scripted property on your object.

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
In my case, I wanted to be able to see the progress for build process running in parallel and found using synchronized hashtable I was able to do this.

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

A more advanced way to use this might be to help gauge how long something might take to complete when running parallel SQL Server queries.

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
- Standard break, continue, return behavior is easier to understand.

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
$Filters = @([Amazon.EC2.Model.Filter]::new('tag:{{TAGHERE}}','{{TAG VALUE}}'))
(Get-EC2Instance -Filter $Filters).Instances| Select-PSFObject InstanceId, PublicIpAddress,PrivateIpAddress,Tags,'State.Code as StateCode', 'State.Name as StateName'  -ScriptProperty @{
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

<script src="https://gist.github.com/sheldonhull/3ea6fd6cafe210edb1d71b5e8d3d1696.js"></script>

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

## Compare Seperate Machine Files

When I was working on a project involving Windows and an installed product, I found some mismatches in the library files that were on a machine.

Since the dlls were mismatching this caused issues with the application.

Here's a way to simplify checking for this in the future.

```powershell
$MyDirectory = ''
Function Format-FileSize {
Param (
[int]$size
)
  If ($size -gt 1TB)
  {[string]::Format("{0:0.00} TB", $size / 1TB)}
  ElseIf ($size -gt 1GB)
  {[string]::Format("{0:0.00} GB", $size / 1GB)}
  ElseIf ($size -gt 1MB)
  {[string]::Format("{0:0.00} MB", $size / 1MB)}
  ElseIf ($size -gt 1KB)
  {[string]::Format("{0:0.00} kB", $size / 1KB)}
  ElseIf ($size -gt 0)
  {[string]::Format("{0:0.00} B", $size)}
  Else
  {""}
}
$results = Get-ChildItem -Path $MyDirectory -Recurse  | Where-Object {$_.PSIsContainer -eq $false} | ForEach-Object {
  [System.IO.FileInfo]$FileInfo = Get-Item $_.FullName
  try {
    $FileVersion = $FileInfoVersionInfo.FileVersion
  } catch {
    $FileVersion = $null
  }
  try {
    $AssemblyVersion = [Reflection.AssemblyName]::GetAssemblyName($FileInfo.FullName).Version
  } catch {
    $AssemblyVersion = $null
  }
  [PSCustomObject]@{
    Name          = $FileInfo.Name
    Size          = Format-FileSize $FileInfo.Length
    FileVersion   = $FileVersionAssembly
    Version       = $AssemblyVersion
    Directory     = $FileInfo.Directory
  }
}
$results | Export-CLIXML -path report.xml -Encoding UTF8 -Force
```

Once you run this on a system that works like you expect you’ll get a serialized xml file that can be used to compare what another machine might have.

You could then compare the results with:

```powershell
$Original = Import-CLIXML -path $OriginalFile
$Expected = Import-CLIXML -path $ExpectedFile

Compare-Object -ReferenceObject $Original -DifferenceObject $Expected -Property Name,Size,FileVersion,AssemblyVersion
```

The output should look similar to this:

```text
Name            : Newtonsoft.Json.dll
Size            : 443.11 kB
FileVersion     :
AssemblyVersion : 9.0.0.0
SideIndicator   : =>

Name            : Newtonsoft.Json.dll
Size            : 509.00 kB
FileVersion     :
AssemblyVersion : 8.0.0.0
SideIndicator   : <=
```

If you are dealing with the dreaded GAC (Global Assembly Cache) try using this model to a comparison as well.

```powershell
if(@(Get-Module GAC -ListAvailable -EA 0).Count -eq 0){
Install-Module GAC -Scope CurrentUser
}

Import-Module Gac
Get-GACAssembly -name '*AssemblyNames*' | Export-CLIXML -path report.xml

```
