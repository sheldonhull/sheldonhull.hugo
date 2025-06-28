# Steampipe Is Sql Magic


## Up And Running In Minutes

I tried [Steampipe](https://steampipe.io/) out for the first time today.

&gt; {{&lt; fa-icon brands  twitter fa-fw &gt;}} [Follow Steampipe On Twitter](https://twitter.com/steampipeio)

I&#39;m seriously impressed.

I built a project [go-aws-ami-metrics](https://github.com/sheldonhull/go-aws-ami-metrics) last year to test out some Go that would iterate through instances and AMIs to build out aging information on the instances.

I used it to help me work through how to use the AWS SDK to iterate through regions, instances, images, and more.

In 15 mins I just solved the equivalent issue in a way that would benefit anyone on a team.
My inner skeptic was cynical, thinking this abstraction would be problematic and I&#39;d be better served by just sticking with the raw power of the SDK.

It turns out this tool already is built on the SDK using the same underlying API calls I&#39;d be writing from scratch.

First example: [DescribeImage](https://github.com/turbot/steampipe-plugin-aws/blob/ce50c2141cd24ed37552afd976482c55961e7725/aws/table_aws_ec2_ami.go#L204)

This is the magic happening in the code.

```go
 resp, err := svc.DescribeImages(&amp;ec2.DescribeImagesInput{
  Owners: []*string{aws.String(&#34;self&#34;)},
 })
 for _, image := range resp.Images {
  d.StreamListItem(ctx, image)
 }
```

This is the same SDK I used, but instead of having to build out all the calls, there is a huge library of data already returned.

```go
 req, publicImages := client.DescribeImagesRequest(&amp;ec2.DescribeImagesInput{
  Filters: []*ec2.Filter{
   {
    Name:   aws.String(&#34;is-public&#34;),
    Values: []*string{aws.String(&#34;true&#34;)},
   },
  },
 },
 )
```

There is no need to reinvent the wheel.
Instead of iterating through regions, accounts, and more, Steampipe allows this in plain old SQL.

![Query The Cloud](/images/2021-07-16-postgres-and-aws.png &#34;Query The Cloud&#34;)
For example, to gather:

- EC2 Instances
- that use AWS Owned Images
- and use an image that created greater than `n` period
- and want the aging in days

```sql
SELECT
 ec2.instance_id,
 ami.name,
 ami.image_id,
 ami.state,
 ami.image_location,
 ami.creation_date,
 extract(&#39;day&#39; FROM now()) - extract(&#39;day&#39; FROM ami.creation_date) AS creation_age,
 ami.public,
 ami.root_device_name
FROM
 aws_ec2_ami_shared AS ami
 INNER JOIN aws_ec2_instance AS ec2 ON ami.image_id = ec2.image_id
WHERE
 ami.owner_id = &#39;137112412989&#39;
  AND ami.creation_date &gt; now() - INTERVAL &#39;4 week&#39;
```

There are plugins for GitHub, Azure, AWS, and many more.

You can even do cross-provider calls.

Imagine wanting to query a tagged instance and pulling the tag of the work item that approved this release.
Join this data with Jira, find all associated users involved with the original request, and you now have an idea of the possibility of cross-provider data Steampipe could simplify.

Stiching this together is complicated.
It would involve at least 2 SDK&#39;s and their unique implementation.

I feel this is like Terraform for Cloud metadata, a way to provide a consistent experience with syntax that is comfortable to many, without the need to deal with provider specific quirks.

## Query In Editor

- I downloaded the recommended [TablePlus](https://tableplus.com/) with `brew install tableplus`.
- Ran `steampipe service start` in my terminal.
- Copied the Postgres connection string from the terminal output and pasted into TablePlus.
- Pasted my query, ran, and results were right there as if I was connected to a database.

![TablePlus](/images/2021-07-16-16.24.53-TablePlus-query-editor.png &#34;TablePlus&#34;)

## AWS Already Has This

AWS has lots of ways to get data.
AWS Config can aggregate across multiple accounts, SSM can do inventory, and other tools can do much of this.

AWS isn&#39;t easy.
Doing it right is hard.
Security is hard.

Expertise in building all of this and consuming can be challenging.

🎉 Mission accomplished!

## Experience

I think Steampipe is offering a fantastic way to get valuable information out of AWS, Azure, GitHub, and more with a common language that&#39;s probably the single most universal development language in existenance: *SQL*.

&gt; One of the goals of Steampipe since we first started envisioning it is that it should be simple to install and use - you should not need to spend hours downloading pre-requisites, fiddling with config files, setting up credentials, or pouring over documentation.
&gt; We&#39;ve tried very hard to bring that vision to reality, and hope that it is reflected in Steampipe as well as our plugins.

Providing a cli with features like this is incredible.

- execute
- turn into an interactive terminal
- provide prompt completion to commands
- a background service to allow connection via IDE

## The Future

The future is bright as long as `truncate ec2_instance` doesn&#39;t become a thing. 😀

## Further Resources

If you want to explore the available schema, check out the thorough docs.

- [AWS Tables List](https://hub.steampipe.io/plugins/turbot/aws/tables) shows `212` tables of metadata currently available.
- Use [Named queries](https://steampipe.io/docs/using-steampipe/writing-queries) to build a library of easy queries to call on demand such as `ami.aging_instances`.
- Use [Mods](https://hub.steampipe.io/mods/turbot/aws_thrifty/controls) to download a set of named queries and controls to validate things like security and compliance.
- [Query multiple connections at once](https://steampipe.io/docs/using-steampipe/managing-connections)
- [Design Principles](https://steampipe.io/docs/develop/architecture)

