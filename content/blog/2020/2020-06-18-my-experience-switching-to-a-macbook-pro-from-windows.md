---
date: 2020-06-18 12:00:00 +00:00
title: My Experience Switching To A Macbook Pro From Windows
slug: my-experience-switching-to-a-macbook-pro-from-windows
summary: Having used Windows mostly for my entire life, this is what it was like switching
  to a Mac for professional use
tags:
- devops
- tech
- development
- apple

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
  * Absolutely despise the changed home/end and selection behavior. Trying to remap this is painful. I've limited my remapping to try and adjust to the way it works natively, but it's difficult. VSCode remapping for certain actions is also tricky, but possible.

## Wins

* So far I've found Finder to be really good and much more intuitive than Explorer in Windows.
* The consistency of app placement makes finding things to run quick, whereas in Windows, finding the app can be a beast at times. Think about this from a new Windows developer perspective. Go to Program Files (x86), or Program Files, but some go into AppData, and then settings in ProgramData, but sometimes that program prefers to put some of the configuration data in the Program directory and sometimes in ProgramData.... unless they want to put it in AppData.... and then Local/Roaming etc. It gets really really confusing quick. That's why tools like _Everything_ are so helpful!
* Docker startup is 🚀 FAST. I'm talking about an update for Docker, and install restart and in a few seconds it's back up and running. I've been so used to it being minutes on Windows.
* Brew is stellar. I love Chocolatey on Windows, but I'm seeing some advantages to a central repository containing all the packages, instead of each package being the responibility of maintainers to keep up to date. This makes the contribution phase much more difficult in Chocolatey. I've written very complex Choco packages for my company, but haven't yet setup a community one, whereas Brew, Scoop, and others have a central repository that you can easily submit a push request to with improvements or new additions without having to manage the autorefresh of the packages. A minor, but important distinction to me, as the ease of contributing must be there for more people to engage in it.
* Not having Windows as my OS has helped me go cold turkey as much as possible on running more workloads in Docker. Visual Studio Docker workspaces are absolutely incredible, and paired with a good tool like `InvokeBuild` with PowerShell, you have a stellar setup than can easily bootstrap itself on a new machine with ease.

## Quirks

* As of this time, mouse cursor not auto-hiding in full screen video without work arounds on certain sites.
* Experimenting with some apps resulted in 2 full system crashes in first 3 weeks of using, so stability while good wasn't as stellar as I was hoping. Just like Windows, it all depends on what you are running.
* Massive lag on bluetooth and even Logitech Unifying receiver based mouse and keyboard, enough to make them unusable. Others seem to have had similar issues when I searched.
* Need to buy a powered hub to expand ports, as only USB-C resulting in all my peripherals not working.

## Verdict

So far, the experience has been one I'd repeat.
For me, I've actually accomplished more, and gotten aware from my desk more with the improved quality of the mobile experience and touchpad.

Would I do it again?
Currently yes.
