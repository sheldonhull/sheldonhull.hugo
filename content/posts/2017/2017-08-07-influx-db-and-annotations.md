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
title: "InfluxDB and Annotations"
slug: "influx-db-and-annotations"
toc: true
series: ["InfluxDb"]
---

> [!info] Updated: 2020-04-29+
> broken image links removed


This post assumes you've already setup InfluxDB and have Grafana running.

## Inserting annotations

Annotations are not a special type of resource, instead it's just another metric that you query with a feature in Grafana to display on other metrics. This means the same insert Line Protocol applies to the Annotation.

This post on maxchadwick.xyz greatly helped me get started: [Creating Grafana Annotations with InfluxDb Max Chadwick](http://bit.ly/2pgmwtH)

Per Max's original post it supports html as well, so you could link for example to a build, test result, or anything else you want to link to from your performance statistics.

[Gist](https://gist.github.com/sheldonhull/e95ca6d909f741ebe80fa28c6da4de5b)

This provides an annotation on your timeline in a nice format for browsing through the timeline. I can see usage cases for identifying specific activity or progress in tests, helping coorelate the performance metrics with known activity steps from a build, script, or other related tasks. You could have an type of activity trigger this powershell insert, providing a lot of flexibility to help relate useful metrics to your monitoring.

My personal use case has been to ensure load testing start/end times and other significant points of time in a test are easily visible in the same timeline I'm reviewing metrics on.

Warning: I did experience performance degradation with Grafana and many annotations on a timeline. I found just disabling the annotations kept this from occurring, so you only pull them when youd them.

## Adding Annotations to Grafana

Now that you have the results being inserted into InfluxDB, you can query these in Grafana as annonations to overlay your graphs.

## Potential Uses

I could see a whole lot of uses for this!

* insert at build related activity
* Windows update
* Specific Database Related Maintenance like Ola Hallengren's index optimize or database integrity check

Monitoring always loses it's value when you have a limited picture of what is happening. Triggering relevant details for stuff that might help analyze activity might be the key to immediately gaining an understanding on what is causing a spike of activity, or of better evaluating the timeline of a load test.
