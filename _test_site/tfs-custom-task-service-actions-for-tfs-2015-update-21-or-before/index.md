# TFS Custom Task - Service Actions (for TFS 2015 Update 2.1 or before)


{{&lt; admonition type=&#34;info&#34; title=&#34;Updated: 2020-04-29&#34; &gt;}}
broken image links removed
{{&lt; /admonition &gt;}}

Apparently, boolean values for custom VSTS tasks for versions prior to TFS 2015 Update 3) require some special handling as they don&#39;t pass the checkbox values as actual powershell `$true` or `$false`. Instead the task passes this information along as `true` or `false`. To properly handle this you&#39;ll need to pass in the value as a `string` then convert to `boolean`.

I found a great start on working on this solution in a blog post by Rene which has more detail, so [check it out.](http://bit.ly/2mggrc9) In addition, some reading on [promiscuous types](http://bit.ly/2mgmMnY) with powershell can be helpful to understand why special handling is needed with conversion.
For example, in the task.json file you&#39;ll have:

```json
    &#34;inputs&#34;: [
            {
                &#34;defaultValue&#34;: &#34;MyServiceName*&#34;,
                &#34;label&#34;: &#34;ServiceName&#34;,
                &#34;name&#34;: &#34;ServiceName&#34;,
                &#34;required&#34;: true,
                &#34;type&#34;: &#34;string&#34;
            },
            {
                &#34;defaultValue&#34;: &#34;true&#34;,
                &#34;helpMarkDown&#34;: &#34;issue restart command&#34;,
                &#34;label&#34;: &#34;ChangeCredentials&#34;,
                &#34;name&#34;: &#34;ChangeCredentials&#34;,
                &#34;required&#34;: true,
                &#34;type&#34;: &#34;boolean&#34;
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

Below I&#39;ve included a custom TFS Task for basic start/stop/restart/change credentials with a custom tfs task. It&#39;s not super refined, but it&#39;s a good start to get you on your way.

{{&lt; gist sheldonhull  622ee7b3da8423b689c9a266816103aa &gt;}}

