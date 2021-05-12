---
date: 2021-05-12T13:10:02-05:00
title: Azure Devops Pr Automation Requires Generic Contribute
slug: azure-devops-pr-automation-requires-generic-contribute
tags:
  - tech
  - development
  - microblog
  - azure-devops
  - devops
series: ["renovate"]
---

Big fan of renovate for terraform dependency management.

Ran into some complications with restarting an onboarding with Whitesource Renovate in Azure DevOps Repos and the Azure Pipeline automation.
I've run into this before, so logging this for my sanity.

- If you failed to onboard with Azure DevOps, you can't rename the PR like in GitHub to simplify restarting the onboarding process.
- Instead, delete the `renovate.json` file and commit to your default branch.
- Then re-add and get the `renovate.json` committed back to your default branch.
- Run your Azure DevOps Pipeline to trigger the dependency assessment.
- If you didn't add the project build service account to your repo with `Contribute`, `Contribute to Pull Requests`, `Force Push` (to allow force update of branches it creates), and `Create Tag`.

{{< admonition type="Tip" title="Where do you add the permissions for build?" open="true">}}

Go to your repository security settings (in this case I'm adding to all to simplify, but you can do on a repo by repo basis if you enjoy tedium):

`https://dev.azure.com/MYORG/MYPROJECT/_settings/repositories?_a=permissions`

Then in the search type your project name and you should see a `PROJECTNAME\Build Service (PROJECTNAME)` show up.

If you are using a custom service account with on-premise agents instead of hosted, then adjust your approach accordingly.

{{< /admonition >}}
