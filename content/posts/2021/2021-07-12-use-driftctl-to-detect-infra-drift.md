---
date: 2021-07-12T15:08:30-05:00
title: Use Driftctl to Detect Infra Drift
slug: use-driftctl-to-detect-infra-drift
tags:
- tech
- development
- microblog
- terraform
- infrastructure-as-code
typora-root-url: ../../../static
typora-copy-images-to:  ../../../static/images
---

Use [Driftctl](https://github.com/driftlang/driftctl) to detect drift in your your infrastructure.
This snippet generates a [html report](https://driftctl.com/html-reports/) to show coverage and drift figures of the target.

For multiple states, you'll need to adapt this to provide more `--from` paths to ensure all state files are used to identify coverage.

```powershell
$S3BucketUri = "terraform-states-$AWS_ACCOUNT_NUMBER/$AWS_REGION/$TERRAFORMMODULE/terraform.tfstate"
$Date = $(Get-Date -Format 'yyyy-MM-dd-HHmmss')
$ArtifactDirectory = (New-Item 'artifacts' -ItemType Directory -Force).FullName
&docker run -t --rm `
    -v ${PWD}:/app:rw `
    -v "$HOME/.driftctl:/root/.driftctl" `
    -v "$HOME/.aws:/root/.aws:ro" `
    -e "AWS_PROFILE=default" ` # Replace this with your aws profile name if you have multiple profiles
    cloudskiff/driftctl scan --from "tfstate+s3://$S3BucketUri" --output "html://$ArtifactDirectory/driftctl-report-$Date.html"
```
