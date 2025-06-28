# Automate Windows Updates for Development


I&#39;ve run into the case where I wanted updates continually applied, while the machine still was part of the GPO that didn&#39;t automatically install updates. For this developer and test oriented machine I wanted every update applied.

I utilized a great module for this and created a script to setup the task and logging to make this an easy task.

If you experience an issue with the WindowsUpdate Vs Microsoft update as the configured update provider, then you can just change the switch in the script for  `-MicrosoftUpdate` to  `-WindowsUpdate`

This isn&#39;t something I&#39;d run in production, but I&#39;ve found it helpful to updating a development server with the latest SQL Server updates, as well as a development machine, allowing me to keep up with any latest changes with minimal effort.

Change the reboot parameter to your preferred option in the script. I left as `autoreboot` for the purpose of a low priority dev server being updated.

{{&lt; gist sheldonhull  3dc7333846aa93d3f01daaefbcce2898 &gt;}}

