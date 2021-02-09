---
date: "2017-05-24T00:00:00Z"
last_modified_at: "2019-02-21"
tags:
- influxdb
- powershell
- configuration
- tech
- sql-server
title: "Running InfluxDB as a service in Windows"
slug: "running-influx-db-as-a-service-in-windows"
toc: true
series: ["InfluxDb"]
---

## Run as a Service

As part of the process to setup some metrics collections for sql-server based on perfmon counters I've been utilizing InfluxDB. Part of getting started on this is ensuring InfluxDB runs as a service instead of requiring me to launch the exe manually. For more information on InfluxDb, see my other post: [Setting Up InfluxDb, Chronograf, and Grafana for the SqlServer Dev]({{< relref "2017-05-24-running-influx-db-as-a-service-in-windows.md" >}})

This of course, did not go without it's share of investigation since I'm working with a compiled executable that was originally built in `GO`. I had issues registering InfluxDB as a service. This is typically due to enviromental/path variables. In my powershell launch of `InfluxD.exe` I typically used a script like the following:

{{< gist sheldonhull  6f4e11d60244af00edac438cb9ae6ea5 >}}

I investigated running as a service and found a great reminder on using NSSM for this: [Running Go executables ... as windows services ' Ricard Clau](http://bit.ly/2pDW65t) I went and downloaded NSSM again and first setup and register of the service went without a hitch, unlike my attempt at running `New-service -name 'InfluxDB' -BinaryPathName 'C:\Influx\influxdb\InfluxD.exe' -DisplayName 'InfluxDB' -StartupType Automatic -Credential (get-credential)`. I'm pretty sure the core issue was the `PATH` variables and other related enviromental paths were not setup with "working directory" being the InfluxDB which would be expected by it.

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
    C:\tools\nssm.exe set InfluxDB ObjectName SERVICENAME "PASSWORD"
    C:\tools\nssm.exe set InfluxDB Start SERVICE_AUTO_START
    C:\tools\nssm.exe set InfluxDB Type SERVICE_WIN32_OWN_PROCESS

Pretty awesome! It's a nice change to have something perfectly the first time with no issues.
