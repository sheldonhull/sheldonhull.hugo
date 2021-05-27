---
date: "2013-04-18T00:00:00Z"
typora-root-url: ../../../static
typora-copy-images-to:  ../../../static/images
tags:
- sql-server
title: "dynamic sql and a char crash"
slug: "dynamic-sql-and-a-char-crash"
---

Dynamic SQL can be helpful, but a pain to debug. I spent hours today working on figuring out why my simple date comparison in dynamic SQL wasn't working. Found out that the remote database I was connecting to had a char date instead of a datetime. I found the comparison of CHARDATE > VARCHARDATE failed to error out, but also failed to give a proper result set. Changing the look-up to ensure both dates were converted to date fixed the issue. During this debugging I was reviewing my dynamically created SQL statement.

I learned that SSMS limits the amount of text it will return. In trying to view the single large UNION ALL statement, I was experiencing truncated results. I wanted to ensure the code being executed looked proper, but couldn't get past the truncation.

Enter [SSMSBoost](https://www.ssmsboost.com) to the rescue!

SSMSboost is created by developers and very responsive to requests. I'll do a proper review soon. They offer a visualize data option that goes beyond the usage I employed. For my purpose, I clicked on the cell and selected visual cell as text, and opened the data in notepad++. This showed the full text without truncation. I was able to move on in my debugging then as I knew the dynamic sql statement was not actually truncated except to my SSMS output. Dynamic SQL is a great tool, but if I had been working with direct queries, the issue would have been much faster to resolve!
