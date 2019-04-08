---
date: "2017-08-11T00:00:00Z"
tags:
- troubleshooting
- virtualization
- ramblings
- tech
title: "Fixing VirtualBox Only Showing 32bit Windows OS Options"
slug: "fixing-virtual-box-only-showing-32bit-windows-os-options"
---

Original help was identified from this article [Why is VirtualBox only showing 32 bit guest versions on my 64 bit host OS?](http://www.fixedbyvonnie.com/2014/11/virtualbox-showing-32-bit-guest-versions-64-bit-host-os/)

In browsing through the comments, I saw mention that the root issue is that Hypervisor running interferes with Virtualboxes virtual management, so I disabled Hypervisor service, repaired the install, and rebooted. I also disabled automatic start for Hypervisor.
This resolved the issue without requiring the uninstallation of the Hypervisor feature in Windows.

