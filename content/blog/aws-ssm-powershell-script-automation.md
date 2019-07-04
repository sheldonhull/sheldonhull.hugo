---
date: 2019-07-04T22:24:01+00:00
title: AWS SSM PowerShell Script Automation
slug: aws-ssm-powershell-script-automation
excerpt:
  simply your management of instances in AWS by learning how to pass PowerShell
  commands through the AWSPowershell cmdlets without having to handle complicated
  string escaping
tags:
  - powershell
  - devops
  - aws
draft: true
---

## SSM Overview

I've found that working with a large number of environments in AWS can provide some interesting challenges for performing various tasks, in a way that scale.

When you begin to have dozens to hundreds of servers that you might need to provide a quick fix, the last thing you want to do is RDP into each and perform some type of scripted action.

AWS SSM (Systems Manager) provides a tremendous amount of functionality to help manage systems. It can perform tasks from running a script, installing an application, and other mundane administrative oriented tasks, to more complex state management, AMI automation, and other tasks that might go beyond the boundaries of virtual machine management.

I'll probably be unpacking a few of these areas over the next few posts, since my world has been heavily focused on SSM usage in the last months, and leveraging it is a must for those working heavily with EC2.

## PowerShell Execution

For the first simple example, AWS SSM provides documents that wrap up various scripted actions and accept parameters. This can be something like Joining a domain or running a shell script.

In my case, I've had the need to change a registry setting, restart a windows service, or set an environment variable across an environment. I additionally wanted to set the target of this run as a tag filter, instead of providing instanceid, since this environment is rebuilt often as part of development.

The commands to execute scripts have one flaw that I abhor. I hate escaping strings. This probably comes from my focused effort on mastering dynamic t-sql :hankey:, at which point I quickly tried to avoid using dynamic sql as much as possible as I realized it was not the end all solution I started to think it was when I just started learning it.

With PowerShell and AWS SSM things could get even messier. You'd have to pass in the command and hope all the json syntax and escaping didn't error things out.

## The solution

Write PowerShell as natively designed, and then encode this scriptblock for passing as an encoded command. I've found for the majority of my adhoc work this provided a perfect solution to eliminate any concerns on having to escape my code, while still letting me write native PowerShell in my Vscode editor with full linting and syntax checks.

### Authenticate

```powershell
Import-Module AWSPowershell.NetCore, PSFramework #PSFramework is used for better config and logging. I include with any work i do
$ProfileName = 'taco'
$region = 'us-west-1'
Initialize-AWSDefaultConfiguration -ProfileName $ProfileName -region $region
```

### Create Your Command

In this section, I've provided a way to reference an existing function so the remote instance can include this function in the local script execution rather than having to copy and paste it into your command block directly. DRY for the win.

```powershell
#----------------------------------------------------------------------------#
#                  Include this function in remote command                   #
#----------------------------------------------------------------------------#
$FunctionGetAWSTags = Get-Content -Path 'C:\temp\Get-AWSTags.ps1' -Raw
$command = {
  Get-Service 'codedeployagent' | Restart-Service -Verbose
}
```

Now that you have a script block, you can work on encoding. This encoding will prevent you from needing to concern yourself with escaping quotes, and you were able to write your entire script in normal editor without issues in linting.

```powershell
#----------------------------------------------------------------------------#
#                   encode command to avoid escape issues                    #
#----------------------------------------------------------------------------#
[string]$CommandString = [string]::Concat($FunctionGetAWSTags, "`n`n", $Command.ToString())
$bytes = [System.Text.Encoding]::Unicode.GetBytes($CommandString)
$encodedCommand = [Convert]::ToBase64String($bytes)
$decodedCommand = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($encodedCommand));
Write-PSFMessage -Level Debug -Message "Decoded Command: $($DecodedCommand)"
```

In my local script, I'll also include this Wait-SSM command that's a quick way to wait for the results of the SSM job to finish and show status. This is because Send-SSMCommand is actually an asynchronous command and doesn't wait for completion, just the successful sending of the command.

```powershell
function Wait-SSM
{
    param(
        [Amazon.SimpleSystemsManagement.Model.Command]$Result
    )
    end
    {
        $Status = (Get-SSMCommandInvocation -CommandId $Result.CommandId -Details $true | Select-Object -ExpandProperty CommandPlugins).Status.Value
        while ($status -ne 'Success')
        {
            $Status = (Get-SSMCommandInvocation -CommandId $Result.CommandId -Details $true | Select-Object -ExpandProperty CommandPlugins).Status.Value
            Start-Sleep -Seconds 5
        }
        Get-SSMCommandInvocation -CommandId $Result.CommandId -Details $true | Select-Object InstanceId, Status | Format-Table -Autosize -Wrap
    }
}
```

### Send Command

Finally, we get to the meat :poultry_leg: and potatos... or in my case I'd prefer the meat and tacos :taco: of the matter.

Sending the command...

```powershell

$Message = (Read-Host "Enter reason")
$sendSSMCommandSplat = @{
    Comment      = $Message
    DocumentName = 'AWS-RunPowerShellScript'
    #InstanceIds  = $InstanceIds # 50 max limit
    Target       = @{Key="tag:env";Values=@("tacoland")}
    Parameter    = @{'commands' = "powershell.exe -nologo -noprofile -encodedcommand $encodedCommand"
    }
}
$result = Send-SSMCommand  @sendSSMCommandSplat
Wait-SSM -Result $result
```

Note that you can also pass in an instance list. To do this, I'd recommend first filtering down based on tags, then also filtering down to available to SSM for running the command to avoid running on instances that are not going to succed, such as instances that are off, or ssm is not running on.

## EC2 Filters

To simplify working with tags, I often use the `ConvertTo-Ec2Filter` function that was written by David Christian (@dchristian3188) and can be viewed on this blog post [EC2 Tags and Filtering](http://bit.ly/2KYcWGF).

```powershell
Function ConvertTo-EC2Filter
{
    [CmdletBinding()]
    Param(
        [Parameter(
            ValueFromPipeline,
            ValueFromPipelineByPropertyName)]
        [HashTable]
        $Filter
    )
    Begin
    {
        $ec2Filter = @()
    }
    Process
    {
        $ec2Filter = Foreach ($key in $Filter.Keys)
        {
            @{
                name   = $key
                values = $Filter[$key]
            }
        }
    }
    End
    {
        $ec2Filter
    }
}
```

```powershell

$searchFor = @{
    'tag:toppings'   = 'saucesAndMoreSauces'
    'tag:env'        = 'tacoland'
}


$ssmInstanceinfo        = Get-SSMInstanceInformation
$ec2Filter              = ConvertTo-EC2Filter -Filter $searchFor
$Instances              = @(Get-EC2Instance -Filter $ec2Filter).Instances
[string[]]$InstanceIds  = ($Instances | Where-Object { $_.State.Name -eq 'running' -and $_.InstanceId -in $ssmInstanceinfo.InstanceId } | Select-Object InstanceId -Unique).InstanceId
```


## wrap-up

Hopefully this will get you going with Send-SSMCommand in a way that helps give you a simple way to issue commands across any number of EC2 instances. For me, it's saved a lot of manual console work to run commands against tagged environments, allowing me to more rapidly apply a fix or chocolatey package, or any number of needs in the context of testing, without all the overhead of doing per instances, or use the dreaded RDP :hankey: connection.

If you find something unclear or worth more explanation, I'm always up for editing and refactoring this post. :tada: