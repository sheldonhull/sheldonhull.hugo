---
date: "2017-08-08T00:00:00Z"
last_modified_at: "2019-02-21"
tags:
- sql-server
- monitoring
- grafana
- influxdb
- cool-tools
- powershell
title: "Capturing Perfmon Counters With Telegraf"
slug: "capturing-perfmon-counters-with-telegraf"
series: ["InfluxDb"]
---

## Setting up Telegraf to Capture Metrics

I had a lot of issues with getting the GO enviroment setup in windows, this time and previous times. For using telegraf, I'd honestly recommend just leveraging the compiled binary provided.

Once downloaded, generate a new config file by running the first command and then the next to install as service. (I tried doing through NSSM originally and it failed to work with telegraf fyi)

[Gist](https://gist.github.com/sheldonhull/583210cfb588d1958b5c2ba67515ec29)


Once this service was setup and credentials entered, it's ready to run as a service in the background, sending whatever you've configured to the destination of choice.

In my test in Amazon Web Services, using EC2 with Windows Server 2016, I had no issues once EC2 issues were resolved to allow the services to start sending their metrics and show me the load being experienced across all in Grafana.
