---
date: 2017-03-07T00:00:00Z
tags:
- tfs
- build-tasks
- powershell
- tech
title: TFS Custom Task - Service Actions (for TFS 2015 Update 2.1 or before)
slug: tfs-custom-task-service-actions-(for-tfs-2015-update-21-or-before)

---

{{< premonition type="info" title="Updated: 2020-04-29" >}}
broken image links removed
{{< /premonition >}}

Apparently, boolean values for custom VSTS tasks for versions prior to TFS 2015 Update 3) require some special handling as they don't pass the checkbox values as actual powershell `$true` or `$false`. Instead the task passes this information along as `true` or `false`. To properly handle this you'll need to pass in the value as a `string` then convert to `boolean`.

I found a great start on working on this solution in a blog post by Rene which has more detail, so [check it out.](http://bit.ly/2mggrc9) In addition, some reading on [promiscuous types](http://bit.ly/2mgmMnY) with powershell can be helpful to understand why special handling is needed with conversion.
For example, in the task.json file you'll have:

```json
    "inputs": [
            {
                "defaultValue": "MyServiceName*",
                "label": "ServiceName",
                "name": "ServiceName",
                "required": true,
                "type": "string"
            },
            {
                "defaultValue": "true",
                "helpMarkDown": "issue restart command",
                "label": "ChangeCredentials",
                "name": "ChangeCredentials",
                "required": true,
                "type": "boolean"
            }
```

This boolean value provides a checkbox on the custom task window.

To properly work with the boolean value, you have to bring it in as a script then convert it to a boolean value.

```powershell

    param(
             [string]$ServiceName
            ,[string]$ServiceAccount
            ,[string]$RestartService
            ,[string]$StartService
            ,[string]$StopService
            ,[string]$ChangeCredentials
    )

```

once you have the parameters, use .NET convert functionality to

```powershell

[bool]$_RestartService    = [System.Convert]::ToBoolean($RestartService)
[bool]$_StartService      = [System.Convert]::ToBoolean($StartService)
[bool]$_StopService       = [System.Convert]::ToBoolean($StopService)
[bool]$_ChangeCredentials = [System.Convert]::ToBoolean($ChangeCredentials)

```

Below I've included a custom TFS Task for basic start/stop/restart/change credentials with a custom tfs task. It's not super refined, but it's a good start to get you on your way.

{{< gist 622ee7b3da8423b689c9a266816103aa >}}
