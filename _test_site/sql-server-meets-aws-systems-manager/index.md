# SQL Server Meets AWS Systems Manager


Excited. Have a new solution in the works to deploy Ola Hallengren via SSM Automation runbook across all SQL Server instances with full scheduling and synchronization to S3. Hoping to get the ok to publish this soon, as I haven&#39;t seen anything like this built.

Includes:

- Building SSM Automation YAML doc from a PS1 file using AST &amp; metadata
- Download dependencies from s3 automatically
- Credentials pulled automatically via AWS Parameter Store (could be adapted to Secrets Manager as well)
- Leverage [s5cmd](https://github.com/peak/s5cmd) for roughly 40x faster sync performance with no `aws-cli` required. It&#39;s a Go executable. #ilovegolang
- Deployment of a job that automates flipping instances to `FULL` or `SIMPLE` recovery similar to how RDS does this, for those cases where you can&#39;t control the creation scripts and want to flip SIMPLE to full for immediate backups.
- Formatted deployment summary card sent with all properties to Microsoft Teams. #imissslack
- Management of these docs via terraform.
- Snippet for the setup of an S3 lifecycle policy automatically cleanup old backups. (prefer terraform, but this is still good to know for retro-active fixes)

I&#39;m pretty proud of this being done, as it is replacing Cloudberry, which has a lot of trouble at scale in my experience. I&#39;ve seen a lot of issues with Cloudberry when dealing with 1000-3000 databases on a server.

Once I get things running, I&#39;ll see if I can get this shared in full since it&#39;s dbatools &#43; Ola Hallengren Backup Solution driven.

Also plan on adding a few things like on failure send a PagerDuty incident and other little enhancements to possible enable better response handling.

## Other Resources

- [dbatools](https://dbatools.io/)
- [Ola Hallengren](https://ola.hallengren.com/sql-server-backup.html)
- [AWS Docs on Automation Runbooks](https://docs.aws.amazon.com/systems-manager/latest/userguide/automation-documents.html)
- [s5cmd](https://github.com/peak/s5cmd)
- [AWS Quick Start for Microsoft SQL Server](https://github.com/aws-quickstart/quickstart-microsoft-sql)

