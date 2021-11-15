---

date: 2021-11-15T22:04:08+0000
title: Thermal Throttling Mac Intel Woes
slug: thermal-throttling-mac-intel-woes
tags:

- tech
- development
- microblog

# images: [/images/]

typora-root-url: ../../../static
typora-copy-images-to:  ../../../static/images
series: ["getting-started-on-macos"]

---

I lost roughly half a day in productivity. CPU hit 100% for an extended period, making it difficult to even use the terminal.

Initially, I thought the culprit was Docker, as it was running some activity with local codespaces and linting tools.
Killing Docker did nothing.

Htop pointed out kernel as the primary hog, and you can't kill that.

After digging around online, I found further mentions about charging on the right side, not the left to avoid thermal issues causing CPU throttling.

The white charger cable wasn't plugged in.
The phone charger was, but the white cable to the laptop charger wasn't.

I was drawing power from the dock, which doesn't provide the same output as the Apple charger (seems to be a common issue).

This Stack Exchange question pointed me back to checking the charging: [macos - How to find cause of high kernel_task cpu usage? - Ask Different](https://apple.stackexchange.com/questions/363337/how-to-find-cause-of-high-kernel-task-cpu-usage)

I was skeptical of this being the root cause of kernel CPU usage, but once I plugged in the charger, the CPU issue resolved itself within 30 seconds.

This is completely ridiculous.
If throttling is occurring, a polished user experience would be to notify of insufficient power from charger, not hammer my performance.
Additionally, it seems odd how many docking stations I've looked at for my Mac don't provide the minimum required power to sustain heavy usage.

While I still enjoy using the Mac, having 4 cables coming out from it to use at my desk compared to my older Lenovo/HP docking station experience feels like a subpar experience.
