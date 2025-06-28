# SQL Server Database Experimentation Assistant - How to Run a Capture


# DEA
Very basic look at the setup as I couldn&#39;t find much documentation on this when I last tried this out in 2018. Maybe it will help you get started a little more quickly. I&#39;ve not had a chance to leverage the actual comparisons across a large workload. When I originally wrote up the basics on this last year I found my needs required more customized load testing approaches.

## Adding The Feature

Added the DRCReplay.exe and the controller services by pulling up the feature setup and adding existing features to existing SQL instance installed.

![Add Feature](/images/1516994454775.png)

Pointed the controller directory to a new directory I created

```powershell
[io.directory]::CreateDirectory(&#39;X:\Microsoft SQL Server\DReplayClient\WorkingDir&#39;)
[io.directory]::CreateDirectory(&#39;X:\Microsoft SQL Server\DReplayClient\ResultDir&#39;)
```

## Initializing Test

Started with backup of the database before executing the activity I wanted to trace.

```powershell
dbatools\backup-dbadatabase -sqlinstance localhost -database $Dbname -CopyOnly -CompressBackup
```

Initialized application application activity, and then recorded in DEA. The result was now in the capture section.

![DEA Captures](/images/1516995207757.png)

Restoring after trace was recorded in DEA was simple with the following command from Dbatools

```powershell
restore-dbadatabase -SqlInstance localhost -Path &#34;&lt;BackupFilePath&gt;&#34; -DatabaseName SMALL -WithReplace
```

After this restore, initiating the replay was achieved by going to the replay tab.

![DEA Replay](/images/1516995297608.png)

