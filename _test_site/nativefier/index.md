# Nativefier

{{&lt; admonition type=&#34;Info&#34; title=&#34;Update 2021-09-20&#34; open=&#34;true&#34;&gt;}}
Updated with improved handling using public docker image.
{{&lt; /admonition &gt;}}
{{&lt; admonition type=&#34;Info&#34; title=&#34;Update 2021-05-10&#34; open=&#34;true&#34;&gt;}}
Added additional context for setting `internal-urls` via command line.
{{&lt; /admonition &gt;}}

{{&lt; admonition type=&#34;Info&#34; title=&#34;Update 2021-05-13&#34; open=&#34;true&#34;&gt;}}
Added docker run commands to simplify local build and run without global install.
{{&lt; /admonition &gt;}}

Ran across this app, and thought was kinda cool.
I&#39;ve had some issues with Chrome apps showing up correctly in certain macOS windows managers to switch context quickly.

Using this tool, you can generate a standalone electron app bundle to run a webpage in as it&#39;s own dedicated window.

It&#39;s cross-platform.

If you are using an app like Azure Boards that doesn&#39;t offer a native app, then this can provide a slightly improved experience over Chrome shortcut apps.
You can pin this to your tray and treat it like a native app.

## Docker Setup

{{&lt; admonition type=&#34;Note&#34; title=&#34;Optional - Build Locally&#34; open=false &gt;}}
This step is no longer required per public docker image.

```powershell
cd ~/git
gh repo clone nativefier/nativefier
cd nativefier
docker build -t local/nativefier .
```

{{&lt; /admonition &gt;}}

## Docker Build

Highly recommend using docker for the build as it was by far the less complicated.

```powershell
docker run --rm -v ~/nativefier-apps:/target/ local/nativefier:latest --help

$MYORG = &#39;foo&#39;
$MYPROJECT = &#39;bar&#39;
$AppName      = &#39;myappname&#39;
$Platform = &#39;&#39;
switch -Wildcard ([System.Environment]::OSVersion.Platform)
{
    &#39;Win32NT&#39; { $Platform = &#39;windows&#39; }
    &#39;Unix&#39;    {
                if ($PSVersionTable.OS -match &#39;Darwin&#39;)
                {
                    $Platform = &#39;darwin&#39;;
                    $DarkMode = &#39;--darwin-dark-mode-support&#39;
                }
                else
                {
                    $Platform = &#39;linux&#39;
                }
            }
    default { Write-Warning &#39;No match found in switch&#39; }
}
$InternalUrls = &#39;(._?contacts\.google\.com._?|._?dev.azure.com_?|._?microsoft.com_?|._?login.microsoftonline.com_?|._?azure.com_?|._?vssps.visualstudio.com._?)&#39;
$Url          = &#34;https://dev.azure.com/$MYORG/$MYPROJECT/_sprints/directory?fullScreen=true/&#34;

$HomeDir = &#34;${ENV:HOME}${ENV:USERPROFILE}&#34; # cross platform support
$PublishDirectory = Join-Path &#34;${ENV:HOME}${ENV:USERPROFILE}&#34; &#39;nativefier-apps&#39;
$PublishAppDirectory = Join-Path $PublishDirectory &#34;$AppName-$Platform-x64&#34;

Remove-Item -LiteralPath $PublishAppDirectory -Recurse -Force
docker run --rm -v  $HomeDir/nativefier-apps:/target/ nativefier/nativefier:latest --name $AppName --platform $Platform $DarkMode --internal-urls $InternalUrls $Url /target/
```

## Running The CLI

For a site like Azure DevOps, you can run:

```powershell
$MYORG = &#39;foo&#39;
$MYPROJECT = &#39;bar&#39;
$BOARDNAME = &#39;bored&#39;
nativefier --name &#39;board&#39; https://dev.azure.com/$MYORG/$MYPROJECT/_boards/board/t/$BOARDNAME/Backlog%20items/?fullScreen=true ~/$BOARDNAME
```

Here&#39;s another example using more custom options to enable internal url authentication and setup an app for a sprint board.

```powershell
nativefier --name &#34;sprint-board&#34; --darwin-dark-mode-support `
  --internal-urls &#39;(._?contacts.google.com._?|._?dev.azure.com_?|._?microsoft.com_?|._?login.microsoftonline.com_?|._?azure.com_?|._?vssps.visualstudio.com._?)&#39; `
  &#34;https://dev.azure.com/$MYORG/$MYPROJECT/_sprints/directory?fullScreen=true&#34;
  ` ~/sprint-board
```

If redirects for permissions occur due to external links opening, you might have to open the application bundle and edit the url mapping. [GitHub Issue #706](https://github.com/jiahaog/nativefier/issues/706)
This can be done proactively in the `--internal-urls` command line argument shown earlier to bypass the need to do this later.

```text
/Users/$(whoami)/$BOARDNAME/APP-darwin-x64/$BOARDNAME.app/Contents/Resources/app/nativefier.json
```

Ensure your external urls match the redirect paths that you need such as below.
I included the standard oauth redirect locations that Google, Azure DevOps, and Microsoft uses.
Add your own such as github to this to have those links open inside the app and not in a new window that fails to recieve the postback.

```json
&#34;internalUrls&#34;: &#34;(._?contacts\.google\.com._?|._?dev.azure.com_?|._?microsoft.com_?|._?login.microsoftonline.com_?|._?azure.com_?|._?vssps.visualstudio.com._?)&#34;,
```

