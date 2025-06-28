# ANTS Performance Profiler for the SQL Server Dev


{{&lt; admonition type=&#34;info&#34; title=&#34;2019-11-10&#34; &gt;}}
Image links are gone due and due to age of post, unable to recover
{{&lt; /admonition &gt;}}

There are a few .NET tools that until recently I haven&#39;t had the chance to work with as much, specifically ANTS Memory Profiler and ANTS Performance Profiler. The memory profiler is more useful for someone focused on memory leaks which a SQL Dev isn&#39;t as focused on for performance tuning. However, there are major benefits for diving into SQL Performance tuning with ANTS Performance profiler. I think I&#39;d say this tool makes the _epic_ category of my #cooltools kit.

One of the most challenging processes for profiling activity is really identifying the single largest pain point. Trying to line up timings with the SQL plans and the application side by side is a big timesaver, and Red Gate improved ANTS Performance profiler to include the executed SQL with execution plans, making it a single stop to profile and get some useful information.

There are other ways to get useful information, such as running Brent Ozar&#39;s First Responder kit queries, Glenn Berry&#39;s diagnostic queries, Query Store, and more. These tend to focus on server performance. As someone working in software development, there is something to be said for the simplicity of running the application and profiling the .NET and SQL performance in one captured &amp; filtered result set. It&#39;s a pretty quick way to immediately reduce noise and view a complete performance picture of the application.

For performance profiling, Visual Studio has an option called Performance Profiler. I found my initial look at it to be positive, just really noisy.

_Disclaimer: As a member of the Friends of Red Gate program, I get to try out all the cool Red Gate tools. Lucky me! This doesn&#39;t bias my reviews as I just like great tools that help me work with SQL server. This is one of them!_

## Profiling .NET App

&lt;!-- ![Setting up your profiling session](/images/profiling-net-app.png) Setting up your profiling session --&gt;

At the time of this articles publishing, there is no 2017 Visual studio extension which makes this process a few clicks less. For now, it still is simple. All you do is go to the bin/debug folder and select the executable you want to profile. Attaching to the .NET excecutable is required for my purpose, as attaching to an _existing process doesn&#39;t give you the ability to get all the SQL calls_ which we definitely want.

## Timeline &amp; Bookmarks

&lt;!-- ![timeline-bookmarks](/images/timeline-bookmarks.png) --&gt;

During the profiling you can perform actions with the application and create bookmarks of points in time as you are performing these actions to make it easier to compare and review results later.

## Reviewing Results

&lt;!-- ![Call Tree View](/images/review-results.png) Call Tree View --&gt;

This is based on the call tree. It shows code calls, and is a great way to be the database guy that says... &#34;hey SQL server isn&#39;t slow, it&#39;s your code&#34; :-)

## Database Calls

&lt;!-- ![Database Calls](/images/database-calls.png) Database Calls --&gt;

The database calls are my favorite part of this tool. This integration is very powerful and lets you immediately trim down to the calls made with timings and associated executed sql text. RG even went and helped us out by providing an execution plan viewer! When I first saw this I fell in love. Having had no previous experience with Entity framework of other ORMs, I found the insight into the performance and behavior of the application to be tremendously helpful the first time I launched this.

## Exporting HTML Report

&lt;!-- ![HTML Exported Report](/images/ants-html-exported-report.png) HTML Exported Report --&gt;

A benefit for summarizing some action for others to consume is the ability to select the entire timeline, or narrow to a slide of time, and export the results as a HTML report.

This was pretty helpful as it could easily provide a way to identify immediate pain points in a daily performance testing process and focus effort on the highest cost application actions, as well as database calls.

## Automation in Profiling

RG Documentation shows great flexibility for the profiler being call from command line. I see a lot of potential benefit here if you want to launch a few actions systematically from your application and establish a normal performance baseline and review this report for new performance issues that seem to be arising.

I generated some reports automatically by launching my executable via command line, profiling, and once this was completed, I was provided with a nice formatted HTML report for the calls. At the time of this article, I couldn&#39;t find any call for generating the SQL calls as their own report.

{{&lt; gist sheldonhull  8055f44fd25af7d010ba22c6e54692e4 &gt;}}


## TL;DR

**Pros**

1.  Incredibly powerful way to truly get a picture into an application&#39;s activity and the true pain points in performance it is experiencing. It truly helps answer the question very quickly of what is the area that needs the most attention.
2.  Very streamlined way to get a summary of the SQL activity an application is generating and the associated statements and execution plans for further analysis.

**Cons**

1.  At times, with larger amounts of profiled data the application could feel unresponsive. Maybe separating some of the panes activity into asynchronous loads with progress indicators would make this feel better.

** Neutral/Wishlist **

1.  More an observation than complaint, but I sure would like to see some active work being released on this with more functionality and SQL performance tuning focus. Seems to be stable and in maintenance mode rather than major enhancements being released. For those involved in software development, this tool is a powerful utility and I&#39;d love to see more improvements being released on it. RedGate... hint hint? :-)
2.  I&#39;d like to see even more automation focus, with the option of preset Powershell cmdlets, and team foundation server task integration to help identify changes in performance patterns when scaled up. Leveraging this to help baseline application performance overall and report and develop trends against this might help catch issues that crop up more quickly.

## additional info on more profiling focused apps

Since the material is related, I thought I&#39;d mention a few tools I&#39;ve used to help profile activity, that is not focused on a wholistic performance analysis, and more about activity.

1.  For more &#34;profiling&#34; and less performance analysis my favorite SQL profiling tool Devart&#39;s [DbForge Sql Profiler](https://www.devart.com/dbforge/sql/event-profiler/) uses extended events and while amazing, isn&#39;t as focused a tool for app and SQL performance analysis. If you haven&#39;t checked that tool (free!) out I highly recommend it vs running profiler. It uses extended events and provides a nice experience in profiling and reviewing results. Super easy to use and very flexible for filtering/sorting/exporting. The only issues I have with it are the filtering setup is annoying, but tolerable to work with, and no execution plans that I&#39;ve been able to find built in, unlike running extended events in SSMS directly. Hopefully, Devart will recognize what an awesome tool they&#39;ve made and continue to push it forward.
2.  For just getting Entity framework and other ADO.net calls you can use intellitrace with the option for ADO.NET tracing enabled. I found this nice, but a little clunky to use compared to Linq Insight or other options mentioned. It&#39;s included with visual studio so if only using periodically then this would be ok to work with.
3.  For a cleaner implementation of Entity Framework Profiling than the Intellitrace route use [Devarts dbForge Linq Insight](http://bit.ly/2vo2Zaj) (I love this tool for cleaner profiling of ADO.NET activity when you aren&#39;t focused on overall performance of the application) and are working in Visual studio.

If all else fails... you can always succumb to dark side and just use SQL Profiler or worse yet...SSMS activity monitor :-)

&lt;!-- ![Image courtesy of Gratisography.com CC0](/images/xevents-vs-profiler.jpg) Image courtesy of Gratisography.com CC0 --&gt;

