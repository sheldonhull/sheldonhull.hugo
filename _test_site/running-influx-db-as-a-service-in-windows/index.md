# Running InfluxDB as a service in Windows


## Run as a Service

As part of the process to setup some metrics collections for sql-server based on perfmon counters I&#39;ve been utilizing InfluxDB. Part of getting started on this is ensuring InfluxDB runs as a service instead of requiring me to launch the exe manually. For more information on InfluxDb, see my other post: [Setting Up InfluxDb, Chronograf, and Grafana for the SqlServer Dev]({{&lt; relref &#34;2017-05-24-running-influx-db-as-a-service-in-windows.md&#34; &gt;}})

This of course, did not go without it&#39;s share of investigation since I&#39;m working with a compiled executable that was originally built in `GO`. I had issues registering InfluxDB as a service. This is typically due to enviromental/path variables. In my powershell launch of `InfluxD.exe` I typically used a script like the following:

{{&lt; gist sheldonhull  6f4e11d60244af00edac438cb9ae6ea5 &gt;}}

I investigated running as a service and found a great reminder on using NSSM for this: [Running Go executables ... as windows services &#39; Ricard Clau](http://bit.ly/2pDW65t) I went and downloaded NSSM again and first setup and register of the service went without a hitch, unlike my attempt at running `New-service -name &#39;InfluxDB&#39; -BinaryPathName &#39;C:\Influx\influxdb\InfluxD.exe&#39; -DisplayName &#39;InfluxDB&#39; -StartupType Automatic -Credential (get-credential)`. I&#39;m pretty sure the core issue was the `PATH` variables and other related enviromental paths were not setup with &#34;working directory&#34; being the InfluxDB which would be expected by it.

## [NSSM - Non-Sucking Service Manager](http://bit.ly/2pDTR25)

Using `nssm install` provided the GUI which I used in this case. Using the following command I was able to see the steps taken to install, which would allow reproducing the install from a .bat file very easily.

    set-location C:\tools
    .\nssm.exe dump InfluxDB

This resulted in the following output:

    C:\tools\nssm.exe install InfluxDB C:\Influx\influxdb\influxd.exe
    C:\tools\nssm.exe set InfluxDB AppDirectory C:\Influx\influxdb
    C:\tools\nssm.exe set InfluxDB AppExit Default Restart
    C:\tools\nssm.exe set InfluxDB AppEvents Start/Pre C:\Influx\influxdb\influx.exe
    C:\tools\nssm.exe set InfluxDB AppEvents Start/Post C:\Influx\influxdb\influx.exe
    C:\tools\nssm.exe set InfluxDB AppNoConsole 1
    C:\tools\nssm.exe set InfluxDB AppRestartDelay 60000
    C:\tools\nssm.exe set InfluxDB DisplayName InfluxDB
    C:\tools\nssm.exe set InfluxDB ObjectName SERVICENAME &#34;PASSWORD&#34;
    C:\tools\nssm.exe set InfluxDB Start SERVICE_AUTO_START
    C:\tools\nssm.exe set InfluxDB Type SERVICE_WIN32_OWN_PROCESS

Pretty awesome! It&#39;s a nice change to have something perfectly the first time with no issues.

