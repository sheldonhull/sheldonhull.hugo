---
date: 2020-05-29 15:48:41 +00:00
title: My Experience Switching To A Macbook Pro From Windows
slug: my-experience-switching-to-a-macbook-pro-from-windows
excerpt: Having used Windows mostly for my entire life, this is what it was like switching
  to a Mac for professional use
tags:
- devops
- tech
- development
- apple
draft: true

---
## My background

My background has been very strongly focused on the .NET world, with a focused start on SQL Server, later branching into learning PowerShell.
This world was heavily focused on Windows.

## Why switch

Having focused on Windows for so long, using a Macbook for development always intrigued me, but was actually not the driving factor.
Poor specs and performance issues with the currently issued laptop kept impacting my work, causing impact to my efforts.
As my work right now is heavily focused in DevOps oriented areas, I found that the reliance on tooling that only worked in Windows over time has greatly reduced.

While I'm very excited for WSL2 with Windows, what I kept feeling like I was doing was battling my system instead of accomplishing the work I needed to get done.
As someone who has been an obsessive tweaker of whatever OS I'm on, I've actually found my desire for full customization diminishing as the development work becomes more interesting.
In this case, being able to work with more linux tooling without as much conflict was appealing.

Additionally, the windows specs for the workbooks I had available were definitely subpar to what a highend macbook could offer.

So I took the plunge, was approved thanks to a supportive manager, and now am working exclusively on a 16" Macbook Pro I9.

## Initial Impressions

### Setup

Learned some Ansible on the fly and configured everything pretty much from the start with Ansible.
Overall, that made it a much better developer onboarding experience than trying to write my initial chocolatey package bootstrap script.

## Painpoints

* DisplayLink installation was painful for docking usage
* No aeropeek
* No automatic window snapping without third party apps
* Text editing shortcuts
  * Absolutely despise the changed home/end and selection behavior. Trying to remap this is painful.

## Wins

* So far I've found Finder to be really good and much more intuitive than Explorer in Windows.
* The consistency of app placement makes finding things to run quick, whereas in Windows, finding the app can be a beast at times. Think about this from a new Windows developer perspective. Go to Program Files (x86), or Program Files, but some go into AppData, and then settings in ProgramData, but sometimes that program prefers to put some of the configuration data in the Program directory and sometimes in ProgramData.... unless they want to put it in AppData.... and then Local/Roaming etc. It gets really really confusing quick. That's why tools like _Everything_ are so helpful!
* Docker startup is 🚀 FAST. I'm talking about an update for Docker, and install restart and in a few seconds it's back up and running. I've been so used to it being minutes on Windows.

## Quirks

* As of this time, mouse cursor not autohiding in full screen video without work arounds

## Verdict

So far, the experience has been one I'd repeat.
For me, I've actually accomplished more, and gotten aware from my desk more with the improved quality of the mobile experience and touchpad.

Would I do it again?
Currently yes.