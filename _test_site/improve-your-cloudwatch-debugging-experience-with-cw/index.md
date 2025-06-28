# Improve Your Cloudwatch Debugging Experience With Cw


A quick fix to improve your debugging of remote commands in AWS is to install [cw](https://github.com/lucagrulla/cw).

With a quick install, you can run a command like: `cw tail -f --profile=qa --region=eu-west-1 ssm/custom-automation-docs/my-custom-doc`.
This will give you a real-time stream of what&#39;s running.

You can also use the AWS Visual Studio Code extension, but I prefer having a terminal open streaming this as I don&#39;t have to go in and refresh any further tools to see what&#39;s happening.
I tend to always start with a single instance/resource for debugging so this is a great way to remove the barrier to visibility a bit more.

