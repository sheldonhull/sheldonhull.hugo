---
date: "2016-03-18T00:00:00Z"
typora-root-url: ../../../static
typora-copy-images-to:  ../../../static/images
tags:
- sql-server
title: "Calculating Some Max Mirror Stats"
slug: "calculating-some-max-mirror-stats"
alias: ['temp-slug-72']
---

This turned out to be quite a challenge. I couldn't find anything that made this very clean and straight forward to calculate, and in my case I was trying to gauge how many mirroring databases I could run on a server.In my scenario, I wasn't running Expensive Edition (@BrentO coined this wonderful phrase), so was looking for the best way to assess numbers by doing mirroring on a large number of databases, in my case > 300 eventually.
The documentation was... well.... a bit confusing. I felt like my notes were from the movie "A Beautiful Mind" as I tried to calculate just how many mirrors were too many!
This is my code snippet for calculating some basic numbers as I walked through the process. Seems much easier after I finished breaking down the steps.
And yes, Expensive Edition had additional thread impact due to multi-threading after I asked about this. Feedback is welcome if you notice a logical error. Note that this is "theoretical". As I've discovered, thread count gets reduced with increase activity so the number mirrored database that can be mirrored with serious performance issues gets decreased with more activity on the server.

{{< gist sheldonhull  1335ab60accc21b95ece >}}
