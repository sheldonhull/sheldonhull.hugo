---

date: 2022-03-24T18:39:42+0000
title: Remove Pending Operations From Pulumi State
slug: remove-pending-operations-from-pulumi-state
tags:
- tech
- development
- microblog
- infrastructure-as-code
series:
- pulumi
---

If you need to work through some issues with a deployment and remove a pending operation in Pulumi state file, you can do this pretty easily manually, or save a quick bit of scrolling and use `gojq` (or `jq` if you want).

- Export: `pulumi stack export --file state.json`
- Align formatting: `cat state.json | gojq > stateFormatted.json`
- Remove pending operation: `cat stateFormatted.json | gojq '.deployment.pending_operations = []' > stateNew.json`
- Now you can compare the results without any whitespace variance.
- Import: `pulumi stack import --file stateNew.json`
