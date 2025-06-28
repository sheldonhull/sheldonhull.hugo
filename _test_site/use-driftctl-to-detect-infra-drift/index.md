# Use Driftctl to Detect Infra Drift


Use [Driftctl](https://github.com/cloudskiff/driftctl) to detect drift in your your infrastructure.
This snippet generates a [html report](https://driftctl.com/html-reports/) to show coverage and drift figures of the target.

For multiple states, you&#39;ll need to adapt this to provide more `--from` paths to ensure all state files are used to identify coverage.

```powershell
$S3BucketUri = &#34;terraform-states-$AWS_ACCOUNT_NUMBER/$AWS_REGION/$TERRAFORMMODULE/terraform.tfstate&#34;
$Date = $(Get-Date -Format &#39;yyyy-MM-dd-HHmmss&#39;)
$ArtifactDirectory = (New-Item &#39;artifacts&#39; -ItemType Directory -Force).FullName
&amp;docker run -t --rm `
    -v ${PWD}:/app:rw `
    -v &#34;$HOME/.driftctl:/root/.driftctl&#34; `
    -v &#34;$HOME/.aws:/root/.aws:ro&#34; `
    -e &#34;AWS_PROFILE=default&#34; ` # Replace this with your aws profile name if you have multiple profiles
    cloudskiff/driftctl scan --from &#34;tfstate&#43;s3://$S3BucketUri&#34; --output &#34;html://$ArtifactDirectory/driftctl-report-$Date.html&#34;
```

Optionally, you can adjust to recursively scan the state file of an entire bucket (say if using Terragrunt to store in special key prefixes).

- Change to `--from &#34;tfstate&#43;s3://mybucket/myprefix&#34;` without requiring the full path to a single tfstate file.
- Recursively search if in many subfolders with: `**/*.tfstate`.

