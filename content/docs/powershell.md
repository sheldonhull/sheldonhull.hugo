---
title: powershell
slug: powershell
date: 2019-03-19
last_modified_at: 2019-03-19
toc: true
excerpt: A cheatsheet for some interesting PowerShell related concepts that might
  benefit others looking for some tips and tricks
permalink: "/docs/powershell"
tags:
- development
- powershell

---
## Requirements
- Assuming you have minimum of Powershell 5.1. If you don't, you should be on that at the minimum. Just install chocolatey, and then run `choco upgrade powershell powershell-core -y --source chocolatey` and you should have both 5.1 and core ready to go if your Windows version supports it. If you are on Windows 7 as a developer, there is no :taco: for you, just get upgraded already.
- Anything manipulating system might need admin, so run as admin in prompt.
- `Install-Module PSFramework` // I use this module for better logging and overall improvements in my quality of life. It's high quality, used by big projects like DbaTools and developed by a Powershell MVP with lots of testing. Forget regular `Write-Verbose` commands and just use the `Write-PSFMessage -Level Verbose -Message 'TacoBear'` instead.

## Development (Optional)

1. Install VSCode (Users)
2. `choco upgrade vscode-powershell -y` or install in extension panel in VSCode. If you are using ISE primarily.... move on already.


## String Formatting

| Type | Example | Output | Notes |
| --- | --- | --- | --- |
| Formatting Switch | 'select {0} from sys.tables' -f 'name' | select name from sys.tables | Same concept as .NET \[string\]::Format(). Token based replacement |
| .NET String Format | \[string\]::Format('select {0} from sys.tables','name') | select name from sys.tables | Why would you do this? Because you want to showoff your .NET chops? |

## Math & Number Conversions

| From | To | Example | Output | Notes |
| --- | --- | --- | --- | --- |
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

{{% premonition type="note" title="Notice" %}}
Personally, I use `BetterCredential\Get-Credential` which is `module\function` syntax if I'm not certain I've imported first. The reason is auto-discovery of module functions in PowerShell might use the default `Get-Credentials` that BetterCredentials overloads if you don't import first. BetterCredentials overrides the default cmdlets to improve for using CredentialManager, so make sure you import it, not assume it will be correctly imported by just referring to the function you are calling.
{{% /premonition %}}

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