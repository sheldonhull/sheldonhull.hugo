---
date: "2015-01-13T00:00:00Z"
slug: dev-tools-file-search
tags:
- sql-server
title: 'Dev Tools: The File Searcher/Launcher to rule them all'
---

Why does this not have more recognition? In the experimentation of various file management and launching apps, I've tried several (Launchy, Listary, etc), but none have offered the speed and customization of Find and Run Robot. This app is a life saver for the power user! Here is an example of how you can have a hotkey to immediately launch a customized google search. The group alias gives you extensibility to filter the text you are typing to identify this alias of "Google Me" as the result to use since we typed ? as the first part of the string (that is the anchor ^).

![Edit Group Alias Options](/images/FARR2_1_Edit_Group_Alias-2015-01-13_07_41_58_hpabr7.png)

Note the encoding is handled by $$u1 for the websearch, automatically correctly encoding spaces, semicolons, and other characters.

![group alias list example](/images/FARR2_2_Options-2015-01-13_07_42_21_tq81fn.png)

Here's the final result of what you'd start typing.

![filtered group alias shows google search](/images/FARR2_3_Find_and_Run_Robot_2___Tuesday_January_13_2015_-_7_42_AM-2015-01-13_07_43_21_k6wuxk.png)

The cool part about this is the ability to not only match the initial regex, but also to filter inside this pattern to provide lists of options inside our match. In this example, I wanted to list favorite website by typing "G" at the beginning of the string followed by the keyword to filter my websites. This can be accomplished by anchoring the beginning of the regex filter to ^g, then filtering with the $$1.

![multiple options to launch inside an alias](/images/FARR2_4_Edit_Group_Alias-2015-01-13_07_52_25_rq5ord.png)

Here is the initial filtered match based only on "G"

![filtering the results of the alias further](/images/FARR2_5_Find_and_Run_Robot_2___Tuesday_January_13_2015_-_7_52_AM-2015-01-13_07_53_08_ulmo8z.png)

And finally the magic happens when the letters after "g" are parsed to get the website I want. This allows one to launch favorite websites easily, and you could even customize the url or more based on what regex magic you work!

![the final result with minimal keystrokes](/images/FARR2_6_Find_and_Run_Robot_2___Tuesday_January_13_2015_-_7_52_AM-2015-01-13_07_53_14_ejmama.png)

All of these concepts apply to launching favorite apps and more. FARR2 has more customization than apps like launchy, symenu, and more, as it allows one to easily tweak the search "score" and add bonus points to items matching common folders or file types such as exe, xlsx, and more. Score model is pretty amazing.

![score model](/images/FARR2_6_Options-2015-01-13_08_03_15_yojqfl.png)

Example of customized options to boost certain valuable matches in search results.

![boost search points for file types or folders](/images/FARR2_7_Options-2015-01-13_08_03_21_yiwpob.png)

Finally, the killer feature for those fans of Everything search tool (Void) is the integration of the Everything search engine as an option to quickly search your entire computer in millseconds. You can easily setup a search filter with a space at the beginning so that all you have to do is type space and your search phrase and it will switch over to using the plugin search engine.

![everything search engine integration](/images/FARR2_8_Plugin_Manager-2015-01-13_08_03_47_bqwkdp.png)

Why does this tool not get more recognization! What a life saver as you search through sql files, projects, and docs! Hope this helped point you in the direction of an amazing tool... post a comment if you try it out and tell me what you think! [Find and Run Robot Help](http://goo.gl/rQ3YEE) [Find and Run Robot Download](http://goo.gl/RIjaoF)
