---
date: "2015-01-21T00:00:00Z"
tags:
- sql-server
title: "Statistics Parsing"
slug: "statistics-parsing"
---

Never really enjoyed reading through the statistics IO results, as it makes it hard to easily guage total impact when you have a long list of tables. A friend referred me to: http://www.statisticsparser.com/ This site is great! However, I really don't like manually copying and pasting the results each time. I threw together a quick autohotkey script that will detect your clipboard change event, look for "scan count" keyword, and then open a "chrome app", paste the results and submit. Note that I have the option "window name enabled" at the bottom of the textbox on the webpage. If you don't the tabcount navigation might be a little off, so tweak this if you want.

{{< gist sheldonhull  01631b28176f71ce4789 >}}
