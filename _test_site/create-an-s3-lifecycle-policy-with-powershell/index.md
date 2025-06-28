# Create an S3 Lifecycle Policy with PowerShell


First, I&#39;m a big believer in doing infrastructure as code.

Using the AWS SDK with any library is great, but for things like S3 I&#39;d highly recommend you use a Terraform module such as [Cloudposse terraform-aws-s3-bucket module](https://registry.terraform.io/modules/cloudposse/s3-bucket/aws/latest).
Everything Cloudposse produces has great quality, flexibility with naming conventions, and more.

Now that this disclaimer is out of the way, I&#39;ve run into scenarios where you can have a bucket with a large amount of data such as databases which would be good to do some cleanup on before you migrate to newly managed backups.

In my case, I&#39;ve run into 50TB of old backups due to tooling issues that prevented cleanup from being successful.
The backup tooling stored a sqlite database in one subdirectory and in another directory the actual backups.

I preferred at this point to only perform the lifecycle cleanup on the backup files, while leaving the sqlite file alone. (side note: i always feel strange typing sqlite, like I&#39;m skipping an l 😁).

Here&#39;s an example of how to do this from the AWS PowerShell docs.

I modified this example to support providing multiple key prefixes.
What wasn&#39;t quite clear when I did this the need to create the entire lifecycle policy collection as a single object and pass this to the command.

If you try to run a loop and create one lifecycle policy for each `Write-S3LifecycleConfiguration` command, it only kept what last ran.
Instead, ensure you create the entire object as shown in the example, and then you&#39;ll be able to have multiple lifecycle policies get attached to your bucket.

Good luck!

{{&lt; gist sheldonhull ad168faccb06cd0387bcebfdf99da3d6 &gt;}}

