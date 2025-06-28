# Quick Start to Using Influxdb on Macos


## Intro

OSS 2.0 is a release candidate at this time, so this may change once it&#39;s released.

It wasn&#39;t quite clear to me how to get up and running quickly with a docker based setup for OSS 2.0 version, so this may save you some time if you are interested. It also should be very similar to the Windows workflow excepting the basic `brew` commands and service install commands you&#39;ll just want to flip over to `choco install telegraf` .

## Docker Compose

Grabbed this from a comment and modified the ports as the were flipped from the `9999` range used during first early access.

```yaml
# docker exec -it influxdb /bin/bash

version: &#34;3.1&#34;
services:
  influxdb:
    restart: always  # It will always restart on rebooting machine now, no need to manually manage this
    container_name: influxdb
    ports:
      - &#39;8086:8086&#39;
    images: [&#39;quay.io/influxdb/influxdb:2.0.0-rc&#39;]
    volumes:
      - influxdb:/var/lib/influxdb2
    command: influxd run --bolt-path /var/lib/influxdb2/influxd.bolt --engine-path /var/lib/influxdb2/engine --store bolt
volumes:
  influxdb:

```

The main modifications I made was ensuring it auto started.

Access the instance on `localhost:8086`.

## Telegraf

It&#39;s pretty straight-forward using homebrew. `brew install telegraf`

The configuration file is created by default at: `/usr/local/etc/telegraf.conf` as well as the `telegraf.d` directory.

I&#39;m still a bit new on macOS, so once I opened Chronograf, I wanted to try the new http based configuration endpoint, so I used the web gui to create a telegraf config for system metrics and tried replacing the `telegraf.conf` reference in the plist file.
This didn&#39;t work for me as I couldn&#39;t get the environment variable for the token to be used, so I ended up leaving it as is, and instead edited the configuration.

- `brew services stop telegraf`
- `micro /usr/Local/Cellar/telegraf/1.15.3/homebrew.mxcl.telegraf.plist`

I updated the configuration (see line 16) unsuccessfully with the http config endpoint.

```text
&lt;?xml version=&#34;1.0&#34; encoding=&#34;UTF-8&#34;?&gt;
&lt;!DOCTYPE plist PUBLIC &#34;-//Apple//DTD PLIST 1.0//EN&#34; &#34;http://www.apple.com/DTDs/PropertyList-1.0.dtd&#34;&gt;
&lt;plist version=&#34;1.0&#34;&gt;
  &lt;dict&gt;
    &lt;key&gt;KeepAlive&lt;/key&gt;
    &lt;dict&gt;
      &lt;key&gt;SuccessfulExit&lt;/key&gt;
      &lt;false/&gt;
    &lt;/dict&gt;
    &lt;key&gt;Label&lt;/key&gt;
    &lt;string&gt;homebrew.mxcl.telegraf&lt;/string&gt;
    &lt;key&gt;ProgramArguments&lt;/key&gt;
    &lt;array&gt;
      &lt;string&gt;/usr/local/opt/telegraf/bin/telegraf&lt;/string&gt;
      &lt;string&gt;-config&lt;/string&gt;
      &lt;string&gt;/usr/local/etc/telegraf.conf&lt;/string&gt;
      &lt;string&gt;-config-directory&lt;/string&gt;
      &lt;string&gt;/usr/local/etc/telegraf.d&lt;/string&gt;
    &lt;/array&gt;
    &lt;key&gt;RunAtLoad&lt;/key&gt;
    &lt;true/&gt;
    &lt;key&gt;WorkingDirectory&lt;/key&gt;
    &lt;string&gt;/usr/local/var&lt;/string&gt;
    &lt;key&gt;StandardErrorPath&lt;/key&gt;
    &lt;string&gt;/usr/local/var/log/telegraf.log&lt;/string&gt;
    &lt;key&gt;StandardOutPath&lt;/key&gt;
    &lt;string&gt;/usr/local/var/log/telegraf.log&lt;/string&gt;
  &lt;/dict&gt;
&lt;/plist&gt;
```

What worked for me was to edit: `micro /usr/local/etc/telegraf.conf` and add the following (I set the token explicitly in my test case).

```toml
 [[outputs.influxdb_v2]]
  urls = [&#34;http://localhost:8086&#34;]
  token = &#34;$INFLUX_TOKEN&#34;
  organization = &#34;sheldonhull&#34;
  bucket = &#34;telegraf&#34;
```

- Start service with `brew services restart telegraf` and it should start sending data.
- NOTE: I&#39;m still getting the hang of brew and service management on Linux/macOS, so the first time I did this it didn&#39;t work and I ended up starting it using `telegraf -config http://localhost:8086/api/v2/telegrafs/068ab4d50aa24000` and just running initially in my console (having already set the `INFLUX_TOKEN` environment variable)
Any comments on if I did something wrong here would be appreciated :grin: I&#39;m pretty sure the culprit is the need for the `INFLUX_TOKEN` environment variable and I&#39;m not sure if the service load with brew is actually sourcing the `.profile` I put this in.
Maybe I can pass it explicitly?

## Additional Monitoring

This is a work in progress.
I found [GitHub Issue #3192](https://github.com/influxdata/telegraf/issues/3192) and used it as a starting point to experiment with getting a &#34;top processes&#34; for evaluating what specifically was impacting my systems at the time of a spike.
I&#39;ll update this once I&#39;ve gotten things further improved.

```toml
# # Monitor process cpu and memory usage
# https://github.com/influxdata/telegraf/tree/master/plugins/inputs/procstat
[[inputs.procstat]]
    pattern = &#34;${USER}&#34;
    fieldpass = [
      &#34;cpu_time_user&#34;,
      &#34;cpu_usage&#34;,
      &#34;memory_rss&#34;,
    ]

[[processors.topk]]
  namepass = [&#34;*procstat*&#34;]
  fields = [
      &#34;cpu_time_user&#34;,
      &#34;cpu_usage&#34;,
      &#34;memory_rss&#34;,
  ]
  period = 20
  k = 3
  # group_by = [&#34;pid&#34;]

[[processors.regex]]
  namepass = [&#34;*procstat*&#34;]
  [[processors.regex.tags]]
    key = &#34;process_name&#34;
    pattern = &#34;^(.{60}).*&#34;
    replacement = &#34;${1}...&#34;
```

## Final Result

I like the final result.
Dark theme for the win.

I&#39;ve had some spikes in Vscode recently, impacting my CPU so I&#39;ve been meaning to do something like this for a while, but finally got it knocked out today once I realized there was a 2.0 docker release I could use to get up and running easily. Next step will be to add some process level detail so I can track the culprit (probably VScode &#43; Docker Codespaces).

![Influx System Dashboard](/images/2020-10-30_19-39-41-influx-macos.png)

## Wishlist

- Pretty formatting of date/time like Grafana does, such as converting seconds into hour/minutes.
- Log viewing api so I could query cloudwatch logs like Grafana offers without needing to ingest.
- Edit existing telegraf configuration in the load data section. Right now I can&#39;t edit.
- MSSQL Custom SQL Server query plugin to be released :grin: [Issue 1894](https://github.com/influxdata/telegraf/issues/1894) &amp; [PR 3069](https://github.com/influxdata/telegraf/pull/3069)
Right now I&#39;ve done custom exec based queries using dbatools and locally included PowerShell modules.
This sorta defeats the flexibility of having a custom query call so I can minimize external dependencies.

