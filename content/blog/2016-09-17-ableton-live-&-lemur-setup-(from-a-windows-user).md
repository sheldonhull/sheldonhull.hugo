---
date: "2016-09-17T00:00:00Z"
tags:
- music
- ramblings
- cool-tools
title: "Ableton Live & Lemur Setup (From a Windows User)"
slug: "ableton-live-&-lemur-setup-(from-a-windows-user)"
---

Had a chance to look at this program thanks to the generosity of the developer. They had a promotion that ended prematurely and they sent me a license as a goodwill gesture. Pretty fantastic service, and thanks to them for this.The documentation was a little sparse for the Windows setup, so I ran into some complications getting it to work.

I have used TouchOSC, and had some difficulty with configuring it for windows. True to other's postings, Lemur didn't make this easier. Especially as a windows user, this is not a simple plug and play and go type of tool. If you are looking for that then you'd be better served by looking a Touchable, Conductr, or something similar that provides the full package.
The difference is that Lemur offers a complete "development" environment for templates and automation. The sky is the limit. You can even have a single ipad controlling multiple computers based on the midi being mapped on one controller to various destinations.
To get Lemur talking to Ableton Live (9.6), this is pretty much what worked for me after experimenting.

1.  Install Lemur
2.  Install Live Control 2 (basically just a set of template and automation scripts)
3.  Copy Live Control Template onto ipad (you can drag the file directly to the app in Itunes and hit sync)
4.  Install [LoopBe](http://bit.ly/2cyHGLt). Note I tried rptMidi as well as LoopMidi, and this is the only one that worked without issue for me on Windows 10.
5.  Setup Lemur Daemon service as shown in screenshot.
![midi port configuration](/images/2016-09-17_13-49-45.png)
6.  In ableton I setup as the following:
![2016-09-17_13-54-06](/images/2016-09-17_13-54-06.png)
7.  If you drag a drum track into a channel and activate for recording, you can tap in the "play" tab and change "key" to "drum". Then you can find the appropriate drum machine field by scrolling up or down.
This got the initial setup going so I was able to drop a drum track in, and tap out a rhythm. I think I'm going to have invest more time into it to get what I want, so the jury is out for me as a casual user whether or not I'll be able to leverage this vs TouchOSC or touchable. It's pretty powerful, just pretty complex!
As a person primarily focused with Live for DAW and home recording/experimentation, I'm probably not going to leverage fully at this time like others would. If I gain some more traction with it, I'll try and post some more useful updates. Both TouchOSC and Lemur are designed for customization. If you want to get going with limited setup, look at Touchable, Conductr, or another similar to that.

