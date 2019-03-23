---
date: "2017-08-07T00:00:00Z"
last_modified_at: "2019-02-21"
tags:
- time-series
- powershell
- influxdb
- monitoring
- sql-server
- cool-tools
title: InfluxDB and Annotations
toc: true
---

## Other Posts in Series

*   [Running InfluxDb As A Service in Windows]({% post_url 2017-05-24-running-influx-db-as-a-service-in-windows  %})
*   [Setting Up InfluxDb, Chronograf, and Grafana for the SqlServer Dev]({% post_url 2017-05-17-setting-up-influx-db-chronograf-and-grafana-for-the-sql-server-dev %})
*   **[InfluxDB And Annotations]({% post_url 2017-08-07-influx-db-and-annotations %})**
*   [Capturing Perfmon Counters With Telegraf]({% post_url 2017-08-08-capturing-perfmon-counters-with-telegraf %})


This post assumes you've already setup InfluxDB and have Grafana running.

## Inserting annotations

Annotations are not a special type of resource, instead it's just another metric that you query with a feature in Grafana to display on other metrics. This means the same insert Line Protocol applies to the Annotation.

This post on maxchadwick.xyz greatly helped me get started: [Creating Grafana Annotations with InfluxDb Max Chadwick](http://bit.ly/2pgmwtH)

Per Max's original post it supports html as well, so you could link for example to a build, test result, or anything else you want to link to from your performance statistics.

{% gist e95ca6d909f741ebe80fa28c6da4de5b %}


This provides an annotation on your timeline in a nice format for browsing through the timeline. I can see usage cases for identifying specific activity or progress in tests, helping coorelate the performance metrics with known activity steps from a build, script, or other related tasks. You could have an type of activity trigger this powershell insert, providing a lot of flexibility to help relate useful metrics to your monitoring.

My personal use case has been to ensure load testing start/end times and other significant points of time in a test are easily visible in the same timeline I'm reviewing metrics on.

Warning: I did experience performance degradation with Grafana and many annotations on a timeline. I found just disabling the annotations kept this from occurring, so you only pull them when youd them.

![inserting+annotation+shows+on+graph](/assets/img/inserting+annotation+shows+on+graph.png)

## Adding Annotations to Grafana

Now that you have the results being inserted into InfluxDB, you can query these in Grafana as annonations to overlay your graphs.

![Adding+Annotation+To+Grafana+to+pull+from+InfluxDB](/assets/img/Adding+Annotation+To+Grafana+to+pull+from+InfluxDB.png)

## Potential Uses

I could see a whole lot of uses for this!

*   insert at build related activity
*   Windows update
*   Specific Database Related Maintenance like Ola Hallengren's index optimize or database integrity check

Monitoring always loses it's value when you have a limited picture of what is happening. Triggering relevant details for stuff that might help analyze activity might be the key to immediately gaining an understanding on what is causing a spike of activity, or of better evaluating the timeline of a load test.
