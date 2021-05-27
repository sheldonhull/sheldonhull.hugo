---
date: 2021-01-14T02:42:20Z
title: Leverage Renovate for Easy Dependency Updates
slug: leverage-renovate-for-easy-dependency-updates
typora-root-url: ../../../static
typora-copy-images-to:  ../../../static/images
tags:
  - tech
  - development
  - microblog
  - terraform
  - devops
series: ["renovate"]
---

Renovate is a great tool to know about.
For Go, you can keep modules updated automatically, but still leverage a pull request review process to allow automated checks to run before allowing the update.

This is particularly useful with Terraform dependencies, which I consider notoriously difficult to keep updated.
Instead of needing to use ranges for modules, you can start specifying exact versions and this GitHub app will automatically check for updates periodically and submit version bumps.

Why? You can have a Terraform plan previewed and checked for any errors on a new version update with no work.
This means your blast radius on updates would be reduced as you are staying up to date and previewing each update as it's available.

No more 5 months of updates and figuring out what went wrong 😁

Here's an example json config that shows how to allow automerging, while respecting minor/major version updates not enabling automerge.

Note that you'd want to install the auto-approver app they document in the marketplace if you have pull request reviews required.

In addition, if you use `CODEOWNERS` file, this will still block automerge.
Consider removing that if you aren't really leveraging it.

{{< gist sheldonhull  "f36ea328a2167e93a7015906beb08bbe" >}}
