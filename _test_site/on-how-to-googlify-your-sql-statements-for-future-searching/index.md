# On how to Googlify your SQL statements for future searching


For sake of future generations, let&#39;s begin to reduce typing and reuse code we&#39;ve built. I think we can all agree that TSQL statements are often repeated.
Ideally, snippets should be created to reduce repeated typing and let us focus on logic and content. However, some statements may not really be &#34;snippet worthy&#34;, and just be quick adhoc queries.
In the past, the solution for saving queries for reuse or reference in the future would be to just save in the projects folder manually. However, it is difficult to always make sure the file is saved, review previous version that may be want had overrode, or even review what statements you actually executed. [SSMSToolsPack](http://www.ssmstoolspack.com/) has historically offered a great logging option. However, as an individual it was hard to justify the cost out of my own pocket. [SSMSBoost](http://www.ssmsboost.com/) has provided a great solution! Note that this was recently added (April), and is a &#34;rough draft&#34; , with minimal interface options, yet provides an amazing solution that I&#39;ve found to offer a great solution.
In addition to the other great features that SSMSBoost offers (which I&#39;ll write about in the future), SSMSBoost now offers 3 unique solutions to saving work.

1. **Executed Statement** Logging This feature saves all your executed statements (ie, when you hit execute) as a .sql file for future reference.  As of today, there is no GUI for managing this. Never fear, I have a great solution for you.
2. **Editor History Logging** This feature saves the current contents of your open query windows at predefined intervals, by default set to 60 seconds. According to their documentation, if no changes have been made to file, it will not save a new version. It will only add a new version once changes are detected to a file.
![ssmsBoost_findInHistory](/images/ssmsBoost_findInHistory_wl9xgr.jpg)
3.**Tab History Logging** If you crash SSMS, close SSMS without saving tabs, or have some unsavory Windows behavior that requires SSMS to be restarted, don&#39;t fear... your tabs are saved. When restarting you can select restore tabs and begin work again. I&#39;ve found this feature to be a lifesaver!
![ssmsBoostRecentTabs](/images/ssmsBoostRecentTabs_bndhth.jpg)

## Searching Your Executed and Editor History

Instructions I recommend for setup and searching your entire sql history nearly instantly.

1. Install [SSMSBoost](http://www.ssmsboost.com/) (free community edition if you can&#39;t support with professional version)
2. Install [DocFetcher](http://docfetcher.sourceforge.net/en/index.html)(open source full text search tool. Best I found for searching and previewing sql files without the complexity of using GREP or other similar tools)
3. Download and run [Preview Handler](http://www.winhelponline.com/utils/previewconfig.zip) from [WinHelp](http://www.winhelponline.com/)
4. Run Preview Handler &gt; Find .SQL &gt; Preview as plain text
5. Run SSMS &gt; Open Settings in SSMSBoost
6. Configure settings as you see fit. I personally move my Editor History and Executed statement&#39;s location to my SSMS Folder, so that I can use something like Create Synchronicity to backup all my work daily.
![SSMSBoost_settings](/images/SSMSBoost_settings_kzsbzr.jpg)
7. Restart SSMS for settings to take effect.
8. Start DocFetcher, go to settings in the top right hand corner.
![DocFetcher_1_startup](/images/DocFetcher_1_startup_irjelx.jpg)

Basic Settings I choose (If you aren&#39;t using [Bitstream](http://ftp.gnome.org/pub/GNOME/sources/ttf-bitstream-vera/1.10/)font... you are missing out)
![DocFetcher_2_basicSettings](/images/DocFetcher_2_basicSettings_unugtr.jpg)

## Docfetcher Advance settings tweaks Change

    CurvyTabs = true HtmlExtensions = html;htm;xhtml;shtml;shtm;php;asp;jsp;sql InitialSorting = -8

* Why? Curvy tabs... because curves are nice
* HTML Extensions, obvious
* Initial Sorting = -8 means that instead of sorting by &#34;match %&#34; which I didn&#39;t find helpful for me, to sort by modified date in desc order. This means I&#39;ll find the most most recent match for the text I&#39;m searching for at the top of my list.

* Setup your custom indexes. I setup separate indexes for executed statements and editor history so I could filter down what I cared about and eliminate near duplicate matches for the most part. Right click in blank space to create index.

I setup as follows:
![DocFetcher_createIndex1](/images/DocFetcher_createIndex1_t0qhl5.jpg)
&lt;br&gt;
![DocFetcher_createIndex2](/images/DocFetcher_createIndex2_i121sx.jpg)

1. Now the DocFetcher daemon will run in the background, if you copied my settings, and update your indexes.  Searching requires no complex regex, and can be done easily with statements. I&#39;d caution on putting exact phrases in quotes, as it does detect wildcards.
![DocFetcher_previewSearch](/images/DocFetcher_previewSearch_m2g07n.jpg)

