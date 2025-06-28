# Using AWS SDK With Go for EC2 AMI Metrics


## Source

The source code for this repo is located here:

&lt;div class=&#34;github-card&#34; data-github=&#34;sheldonhull/go-aws-ami-metrics&#34; data-width=&#34;400&#34; data-height=&#34;&#34; data-theme=&#34;default&#34;&gt;&lt;/div&gt;
&lt;script src=&#34;//cdn.jsdelivr.net/github-cards/latest/widget.js&#34;&gt;&lt;/script&gt;

## What This Is

This is a quick overview of some AWS SDK Go work, but not a detailed tutorial.
I&#39;d love feedback from more experienced Go devs as well.

Feel free to submit a PR with tweaks or suggestions, or just comment at the bottom (which is a GitHub issue powered comment system anyway).

## Image Age

Good metrics can help drive change. If you identify metrics that help you quantify areas of progress in your DevOps process, you&#39;ll have a chance to show the progress made and chart the wins.

Knowing the age of the image underlying your instances could be useful if you wanted to measure how often instances were being built and rebuilt.

I&#39;m a big fan of making instances as immutable as possible, with less reliance on changes applied by configuration management and build oriented pipelines, and more baked into the image itself.

Even if you don&#39;t build everything into your image and are just doing &#34;golden images&#34;, you&#39;ll still benefit from seeing the average age of images used go down.
This would represent more continual rebuilds of your infrastructure.
Containerization removes a lot of these concerns, but not everyone is in a place to go straight to containerization for all deployments yet.

## What Using the SDK Covers

I decided this would be a good chance to use Go as the task is relatively simple and I already know how I&#39;d accomplish this in PowerShell.

If you are also on this journey, maybe you&#39;ll find this detail inspiring to help you get some practical application in Go.

There are a few steps that would be required:

1. Connection &amp; Authorization
1. Obtain a List of Images
    1. Filtering required
1. Obtain List of Instances
1. Match Images to Instances where possible
1. Produce artifact in file form

Warning... I discovered that the SDK is pretty noisy and probably makes things a bit tougher than just plain idiomatic Go.

If you want to learn pointers and derefrencing with Go... you&#39;ll be a pro by the time you are done with it 😂

![Everyone Gets a Pointers According to SpongeBob](/images/12-03-10-19-40-pointers-for-everyone.png)

## Why This Could Be Useful In Learning More Go

I think this is a pretty great small metric oriented collector focus as it ties in with several areas worth future versions.

Since the overall logic is simple there&#39;s less need to focus on understanding AWS and more on leveraging different Go features.

1. Version 1: MVP that just products a JSON artifact
1. Version 2: Wrap up in lambda collector and product s3 artifact
1. Version 3: Persist metrics to Cloudwatch instead as a metric
1. Version 4: Datadog or Telegraf plugin

From the initial iteration I&#39;ll post, there&#39;s quite a bit of room for even basic improvement that my quick and dirty solution didn&#39;t implement.

1. Use channels to run parallel sessions to collect multi-region metrics in less time
1. Use sorting with the structs properly would probably cut down on overhead and execution time dramatically.
1. Timeseries metrics output for Cloudwatch, Datadog, or Telegraf

## Caveat

1. Still learning Go. Posting this up and welcome any pull requests or comments (comments will open GitHubub issue automatically).
1. There is no proper isolation of functions and tests applied. I&#39;ve determined it&#39;s better to produce and get some volume under my belt that focus on immediately making everything best practices.
Once I&#39;ve gotten more familiar with Go proper structure, removing logic from `main()` and more will be important.
1. This is not a complete walkthrough of all concepts, more a few things I found interesting along the way.

## Some Observations &amp; Notes On V1 Attempt

### omitempty

Writing to JSON is pretty straight forward, but what I found interesting was handling null values.

If you don&#39;t want the default initialized value from the data type to be populated, then you need to specific additional attributes in your struct to let it know how to properly serialize the data.

For instance, I didn&#39;t want to populate a null value for `AmiAge` as `0` would mess up any averages you were trying to calculate.

```go
type ReportAmiAging struct {
	Region             string     `json:&#34;region&#34;`
	InstanceID         string     `json:&#34;instance-id&#34;`
	AmiID              string     `json:&#34;image-id&#34;`
	ImageName          *string    `json:&#34;image-name,omitempty&#34;`
	PlatformDetails    *string    `json:&#34;platform-details,omitempty&#34;`
	InstanceCreateDate *time.Time `json:&#34;instance-create-date&#34;`
	AmiCreateDate      *time.Time `json:&#34;ami-create-date,omitempty&#34;`
	AmiAgeDays         *int       `json:&#34;ami-age-days,omitempty&#34;`
}
```

In this case, I just set `omitempty` and it would set to null if I passed in a pointer to the value. For a much more detailed walk-through of this:  [Go&#39;s Emit Empty Explained](https://www.sohamkamani.com/golang/2018-07-19-golang-omitempty/)

### Multi-Region

Here things got a little confusing as I wanted to run this concurrently, but shelved that for v1 to deliver results more quickly.

To initialize a new session, I provided my starting point.

```go
sess, err := session.NewSession(&amp;aws.Config{
		Region: aws.String(&#34;eu-west-1&#34;),
		},
)
if err != nil {
    log.Err(err)
}
log.Info().Str(&#34;region&#34;, string(*sess.Config.Region)).Msg(&#34;initialized new session successfully&#34;)
```

Next, I had to gather all the regions.
In my scenario, I wanted to add flexibility to ignore regions that were not opted into, to allow less regions to be covered when this setting was correctly used in AWS.

```go
// Create EC2 service client
client := ec2.New(sess)
regions, err := client.DescribeRegions(&amp;ec2.DescribeRegionsInput{
    AllRegions: aws.Bool(true), Filters: []*ec2.Filter{
        {
            Name:   aws.String(&#34;opt-in-status&#34;),
            Values: []*string{aws.String(&#34;opted-in&#34;), aws.String(&#34;opt-in-not-required&#34;)},
        },
    },
},
                                      )
if err != nil {
    log.Err(err).Msg(&#34;Failed to parse regions&#34;)
    os.Exit(1)
}
```

The filter syntax is pretty ugly.
Due to the way the SDK works, you can&#39;t just pass in `*[]string{&#34;opted-in&#34;,&#34;opt-in-not-required}` and then reference this.
Instead, you have to set the AWS functions to create pointers to the strings and then dereference.
Deep diving into this further was beyond my time allotted, but made my first usage feel somewhat clunky.

After gathering the regions you&#39;d iterate and create a new session per region similar to this.

```go
for _, region := range regions.Regions {
		log.Info().Str(&#34;region&#34;, *region.RegionName).Msg(&#34;--&gt; processing region&#34;)
		client := ec2.New(sess, &amp;aws.Config{Region: *&amp;region.RegionName})
    // Do your magic
}
```

### Structured Logging

I&#39;ve blogged about this before (mostly on microblog).

As a newer gopher, I&#39;ve found that [zerolog](https://github.com/rs/zerolog) is pretty intuitive.

Structured logging is really important to being able to use log tools and get more value out of your logs in the future, so I personally like the idea of starting with them from the beginning.

Here you could see how you can provide name value pairs, along with the message.

```go
log.Info().Int(&#34;result_count&#34;, len(respInstances.Reservations)).Dur(&#34;duration&#34;, time.Since(start)).Msg(&#34;\tresults returned for ec2instances&#34;)
```

Using this provided some nice readable console feedback, along with values that a tool like Datadog&#39;s log parser could turn into values you could easily make metrics from.

### Performance In Searching

From my prior blog post [Filtering Results In Go]({{&lt; relref &#34;2020-11-17-filtering-results-in-go.md&#34; &gt;}} &#34;Filtering Results In Go&#34;) I also talked about this.

The lack of syntactic sugar in Go means this seemed much more verbose than I was expecting.

A few key things I observed here were:

1. Important to set your default layout for time if you want any consistency.
1. Sorting algorithms, or even just basic sorting, would likely reduce the overall cost of a search like this (I&#39;m better pretty dramatically)
1. Pointers. Everywhere. Coming from a dynamic scripting language like PowerShell/Python, this is a different paradigm.
I&#39;m used to isolated functions which have less focus on passing values to modify directly (by value).
In .NET you can pass in variables by reference, which is similar in concept, but it&#39;s not something I found a lot of use for in scripting.
I can see the massive benefits when at scale though, as avoiding more memory grants by using existing memory allocations with pointers would be much more efficient. Just have to get used to it!

```go

// GetMatchingImage will search the ami results for a matching id
func GetMatchingImage(imgs []*ec2.Image, search *string) (parsedTime time.Time, imageName string, platformDetails string, err error) {
	layout := time.RFC3339 //&#34;2006-01-02T15:04:05.000Z&#34;
	log.Debug().Msgf(&#34;\t\t\tsearching for: %s&#34;, *search)
	// Look up the matching image
	for _, i := range imgs {
		log.Trace().Msgf(&#34;\t\t\t%s &lt;--&gt; %s&#34;, *i.ImageId, *search)
		if strings.ToLower(*i.ImageId) == strings.ToLower(*search) {
			log.Trace().Msgf(&#34;\t\t\t %s == %s&#34;, *i.ImageId, *search)

			p, err := time.Parse(layout, *i.CreationDate)
			if err != nil {
				log.Err(err).Msg(&#34;\t\t\tfailed to parse date from image i.CreationDate&#34;)
			}
			log.Debug().Str(&#34;i.CreationDate&#34;, *i.CreationDate).Str(&#34;parsedTime&#34;, p.String()).Msg(&#34;\t\t\tami-create-date result&#34;)
			return p, *i.Name, *i.PlatformDetails, nil
			// break
		}
	}
	return parsedTime, &#34;&#34;, &#34;&#34;, errors.New(&#34;\t\t\tno matching ami found&#34;)
}

```

### Multiple Return Properties

While this can be done in PowerShell, I rarely did it in the manner Go does.

```go
amiCreateDate, ImageName, platformDetails, err := GetMatchingImage(respPrivateImages.Images, inst.ImageId)
if err != nil {
    log.Err(err).Msg(&#34;failure to find ami&#34;)
}
```

## Feedback Welcome

As stated, feedback welcome from any more experienced Gophers would be welcome.
Anything for round 2.

Goals for that will be at a minimum:

1. Use `go test`  to run.
1. Isolate main and build basic tests for each function.
1. Decide to wrap up in lambda or plugin.

