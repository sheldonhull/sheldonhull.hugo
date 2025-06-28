# Install ReadyRoll via Command Line


#### command line install options

ReadyRoll has some great features, including the ability to use without cost on a build server. If you want to ease setup on multiple build servers you could create a simple command line install step against the EXE.

#### future changes

ReadyRoll was recently acquired by Redgate, so the installer options may change in the future to be more inline with the standard Redgate installer. For now, this is a way to automate an install/updates.

#### autoupdating via Ketarin

I personally use Ketarin to help me manage automatically updating apps like SQL Server Management Studio. I&#39;ve uploaded a public entry for ReadyRoll to automate download and install of the latest ReadyRoll version when available. For more detail on how to use Ketarin see my earlier post on [Automating SSMS Upgrades]({{&lt; relref &#34;2016-04-27-automating-ssms-2016-updates-&amp;-install.md&#34; &gt;}})

### command line options

1.  Find the path of the installer
2.  Run `ReadyRoll.msi /exenoui /qn` for a silent install.

![2016-08-16_11-05-53](/images/2016-08-16_11-05-53.png)
- For automated setup and install use the following code with Ketarin

{{&lt; gist sheldonhull  bfde8f5846555183e3abd4e7575bc2a9 &gt;}}

