# AWS SSM PowerShell Script Automation


## SSM Overview

I&#39;ve found that working with a large number of environments in AWS can provide some interesting challenges for performing various tasks, in a way that scale.

When you begin to have dozens to hundreds of servers that you might need to provide a quick fix, the last thing you want to do is RDP into each and perform some type of scripted action.

AWS SSM (Systems Manager) provides a tremendous amount of functionality to help manage systems. It can perform tasks from running a script, installing an application, and other mundane administrative oriented tasks, to more complex state management, AMI automation, and other tasks that might go beyond the boundaries of virtual machine management.

I&#39;ll probably be unpacking a few of these areas over the next few posts, since my world has been heavily focused on SSM usage in the last months, and leveraging it is a must for those working heavily with EC2.

## PowerShell Execution

For the first simple example, AWS SSM provides documents that wrap up various scripted actions and accept parameters. This can be something like Joining a domain or running a shell script.

In my case, I&#39;ve had the need to change a registry setting, restart a windows service, or set an environment variable across an environment. I additionally wanted to set the target of this run as a tag filter, instead of providing instanceid, since this environment is rebuilt often as part of development.

The commands to execute scripts have one flaw that I abhor. I hate escaping strings. This probably comes from my focused effort on mastering dynamic t-sql :hankey:, at which point I quickly tried to avoid using dynamic sql as much as possible as I realized it was not the end all solution I started to think it was when I just started learning it.

With PowerShell and AWS SSM things could get even messier. You&#39;d have to pass in the command and hope all the json syntax and escaping didn&#39;t error things out.

## The solution

Write PowerShell as natively designed, and then encode this scriptblock for passing as an encoded command. I&#39;ve found for the majority of my adhoc work this provided a perfect solution to eliminate any concerns on having to escape my code, while still letting me write native PowerShell in my Vscode editor with full linting and syntax checks.

### Authenticate

```powershell
Import-Module AWSPowershell.NetCore, PSFramework #PSFramework is used for better config and logging. I include with any work i do
$ProfileName = &#39;taco&#39;
$region = &#39;us-west-1&#39;
Initialize-AWSDefaultConfiguration -ProfileName $ProfileName -region $region
```

### Create Your Command

In this section, I&#39;ve provided a way to reference an existing function so the remote instance can include this function in the local script execution rather than having to copy and paste it into your command block directly. DRY for the win.

```powershell
#----------------------------------------------------------------------------#
#                  Include this function in remote command                   #
#----------------------------------------------------------------------------#
$FunctionGetAWSTags = Get-Content -Path &#39;C:\temp\Get-AWSTags.ps1&#39; -Raw
$command = {
  Get-Service &#39;codedeployagent&#39; | Restart-Service -Verbose
}
```

Now that you have a script block, you can work on encoding. This encoding will prevent you from needing to concern yourself with escaping quotes, and you were able to write your entire script in normal editor without issues in linting.

```powershell
#----------------------------------------------------------------------------#
#                   encode command to avoid escape issues                    #
#----------------------------------------------------------------------------#
[string]$CommandString = [string]::Concat($FunctionGetAWSTags, &#34;`n`n&#34;, $Command.ToString())
$bytes = [System.Text.Encoding]::Unicode.GetBytes($CommandString)
$encodedCommand = [Convert]::ToBase64String($bytes)
$decodedCommand = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($encodedCommand));
Write-PSFMessage -Level Debug -Message &#34;Decoded Command: $($DecodedCommand)&#34;
```

In my local script, I&#39;ll also include this Wait-SSM command that&#39;s a quick way to wait for the results of the SSM job to finish and show status. This is because Send-SSMCommand is actually an asynchronous command and doesn&#39;t wait for completion, just the successful sending of the command.

```powershell
function Wait-SSM
{
    param(
        [Amazon.SimpleSystemsManagement.Model.Command]$Result
    )
    end
    {
        $Status = (Get-SSMCommandInvocation -CommandId $Result.CommandId -Details $true | Select-Object -ExpandProperty CommandPlugins).Status.Value
        while ($status -ne &#39;Success&#39;)
        {
            $Status = (Get-SSMCommandInvocation -CommandId $Result.CommandId -Details $true | Select-Object -ExpandProperty CommandPlugins).Status.Value
            Start-Sleep -Seconds 5
        }
        Get-SSMCommandInvocation -CommandId $Result.CommandId -Details $true | Select-Object InstanceId, Status | Format-Table -Autosize -Wrap
    }
}
```

### Send Command

Finally, we get to the meat :poultry_leg: and potatos... or in my case I&#39;d prefer the meat and tacos :taco: of the matter.

Sending the command...

```powershell
$Message = (Read-Host &#34;Enter reason&#34;)
$sendSSMCommandSplat = @{
    Comment                                       = $Message
    DocumentName                                  = &#39;AWS-RunPowerShellScript&#39;
    #InstanceIds                                  = $InstanceIds # 50 max limit
    Target                                        = @{Key=&#34;tag:env&#34;;Values=@(&#34;tacoland&#34;)}
    Parameter                                     = @{&#39;commands&#39; = &#34;powershell.exe -nologo -noprofile -encodedcommand $encodedCommand&#34;  }
    CloudWatchOutputConfig_CloudWatchLogGroupName  = &#39;ssm/manual/my-command&#39;
    CloudWatchOutputConfig_CloudWatchOutputEnabled = $true
}
$result = Send-SSMCommand  @sendSSMCommandSplat
Wait-SSM -Result $result
```

Note that you can also pass in an instance list.
To do this, I&#39;d recommend first filtering down based on tags, then also filtering down to available to SSM for running the command to avoid running on instances that are not going to succed, such as instances that are off, or ssm is not running on.

To stream results from cloudwatch, try looking at my post: [Post on Using Cw for Cloudwatch Log Stream In Terminal]({{&lt; relref &#34;2020-09-16-improve-your-cloudwatch-debugging-experience-with-cw.md&#34; &gt;}} &#34;Post on Using Cw for Cloudwatch Log Stream In Terminal&#34;)

```powershell
cw tail -f --profile=my-profile --region=eu-west-1 &#39;ssm/manual/my-command&#39;
```

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
    &#39;tag:toppings&#39;   = &#39;saucesAndMoreSauces&#39;
    &#39;tag:env&#39;        = &#39;tacoland&#39;
}


$ssmInstanceinfo        = Get-SSMInstanceInformation
$ec2Filter              = ConvertTo-EC2Filter -Filter $searchFor
$Instances              = @(Get-EC2Instance -Filter $ec2Filter).Instances
[string[]]$InstanceIds  = ($Instances | Where-Object { $_.State.Name -eq &#39;running&#39; -and $_.InstanceId -in $ssmInstanceinfo.InstanceId } | Select-Object InstanceId -Unique).InstanceId
```


## wrap-up

Hopefully this will get you going with Send-SSMCommand in a way that helps give you a simple way to issue commands across any number of EC2 instances. For me, it&#39;s saved a lot of manual console work to run commands against tagged environments, allowing me to more rapidly apply a fix or chocolatey package, or any number of needs in the context of testing, without all the overhead of doing per instances, or use the dreaded RDP :hankey: connection.

If you find something unclear or worth more explanation, I&#39;m always up for editing and refactoring this post. :tada:

