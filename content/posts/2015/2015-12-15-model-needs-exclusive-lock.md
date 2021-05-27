---
date: "2015-12-15T00:00:00Z"
typora-root-url: ../../../static
typora-copy-images-to:  ../../../static/images
tags:
- sql-server
title: "Model needs exclusive lock"
slug: "model-needs-exclusive-lock"
---

Ran into an issue where a developer was trying to create a database and was denied due to no ability to obtain exclusive lock on model. After verifying with other blogs, I found that creating a database required exclusive lock to use model as a template for the new database creation.

In my case I had connected with SSMS directly to model for some queries instead of master. In this case, SQL Complete (Devarts's excellent alternative to SQL Prompt) was querying the schema had this open session was blocking usage of model to create a new database. After killing this low priority query session, no issues were experienced.

Good to remember! Don't connect directly to model unless you have a specific reason to do so. Otherwise, you might be the culprit on some blocking errors.
