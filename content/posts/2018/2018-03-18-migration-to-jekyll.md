---
date: "2018-03-18T00:00:00Z"
last_modified_at: "2019-02-21"
typora-root-url: ../../../static
typora-copy-images-to:  ../../../static/images
tags:
  - tech
  - jekyll
title: "Migration To Jekyll"
slug: "migration-to-jekyll"
toc: true
---

I've been in the process of migrating my site to it's final home (as far as my inner geek can be satisfied staying with one platform)... Jekyll.

## Jekyll

[Jekyll](http://bit.ly/2FK4B7p) is a static website generator that takes plain markdown files and runs through through files that are basically templates for the end html content, allowing flexibility in content generation. The result ends up being a static website with beautifully generated typography, search, pagination, and other great features for a blogging engine. You also keep the benefit of writing in our beloved markdown, allowing easy source controlling of your blog.

This site at this time basically is a github repo. Upon commit, Netlify provides an amazing free resource for developers to automatically launch a remote build, minify, ensure content is with their CDN and publishes the changes to your site upon successful build. Pretty amazing! They also have more flexibility than Github-Pages in that you can use other Ruby based plugins for Jekyll, while Github limits the plugins available, resulting in less features in Jekyll that are available.

## Worth It?

This was a pretty exhaustive migration process, primarily because I worked on ensuring all links were correctly remapped, features like tag pages were in place, and all assets were migrated from Cloudinary and other locations. Overall it was a very time consuming affair but considering free hosting that will scale for any load required vs \$144 at squarespace, I think it's a win. In addition, no MySQL databases to manage, Apache webservers to maintain, PHP editions to troubleshoot.... well that sold me.

## Using Fuzzy String Matching To Fix Urls

### resources

- [PowerShell: Check List of Urls and Retrieve Status Codes](https://gist.github.com/sheldonhull/830be16d464d2205236f95c7615a4446)
- [PowerShell: Generate CSV from Sitemap.xml](https://gist.github.com/sheldonhull/fdc5c12fa10c806811cdc75b8955587f)

### matching urls

I noticed a lot of broken url's when migrating my site, so I got a list of url's and wanted to compare the old broken urls against a list of current url's and do a match to find the best resulting match. For instance, with the Jekyll title generating the link, I had issues with a url change like this:

I generated a sitemap csv by using ConvertFrom-Sitemap, originally written by Michael Hompus at TechCenter.

| Original                                         | New                                                                 |
| ------------------------------------------------ | ------------------------------------------------------------------- |
| `https://www.sheldonhull.com/blog/syncovery-arq` | `https://www.sheldonhull.com/blog/syncovery-&-arq-syncing-&-backup` |

What I wanted was a way to do a fuzzy match on the url to give me the best guess match, even if a few characters were different... and I did not want to write this from scratch in the time I have.

I found a reference to a great library called [Communary.PASM](https://www.powershellgallery.com/packages/Communary.PASM) and in PowerShell ran the install command: `Install-Package Communary.PASM -scope currentuser`

The resulting adhoc script I created:

{{< gist sheldonhull  c57c51882e7102e6b9b383443c115409 >}}

The resulting matches were helpful in saving me a lot of time, finding partial matches when a few characters were off.

| Original                                      | FuzzyMatched                                  |
| --------------------------------------------- | --------------------------------------------- |
| /blog/transaction-logging-recovery-101        | /blog/transaction-logging-&-recovery-(101)    |
| /blog/transaction-logging-recovery-part-2     | /blog/transaction-logging-&-recovery-(part-2) |
| /blog/transaction-logging-&-recovery-(part-3) | /blog/transaction-logging-recovery-part-3     |

I then tested out another several algorithms. I had come across references to the Levenshtein algorithm when reading about string matching on Stack Overflow. I added that logic into my script, and watched paint dry while it ran. It wasn't a good fit for my basic string matching. Learning more about string matching sounds interesting though as it seems to be a common occurrence in development, and I'm all for anything that lets me write less regex :-)

For my rough purposes the Fuzzy match was the best fit, as most of the title was the same, just typically missing the end, or slight variance in the delimiter.

I had other manual cleanup to do, but still, it was an interesting experiment. Gave me an appreciation for a consistent url naming schema, as migration to a new engine can be made very painful by changes in the naming of the posts. After some more digging, I decided to not worry about older post urls and mostly just focused on migrating any comments. I think the most interesting part of this was learning a little about the various string matching algorithm's out there... It's got my inner data geek interested in learning more on this.
