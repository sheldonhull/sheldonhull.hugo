# Filtering Results in Go


## Where Filtering

I explored a bit on filtering objects with Go for the AWS SDK v1.

Coming from PowerShell, I&#39;m used to a lot of one-liners that do a lot of magic behind the scenes, so Go is both refreshing in it&#39;s clarity, and a bit verbose at times since the language features are more sparse.

In PowerShell, you can filter results with a variety of methods, including examples like below (but not limited to)

- `$collection.Where{$_.Value -eq &#39;foo&#39;}`
- `$collection | Where-Object {$_.Value -eq &#39;foo&#39;}`
- `$collection | Where-Object Value -eq &#39;foo&#39;`

When exploring the an unmarshalled result in Go, I found it a bit verbose compared to what I was used to, and wondered if there are no &#34;Where&#34; clause helper libraries that cut down on this verbosity, and also still considered idiomatic (Go&#39;s favorite word 😃).

## Scenario

Let&#39;s get all the EC2 Image results for a region and match these with all the EC2 instances running.
Filter down the results of this to only the ami matching what the EC2 instance is using.

In PowerShell this might look like `$AmiId = $Images.Where{$_.ImageId -eq $Search}.ImageId`.

As a newer gopher, this is what I ended up doing,and wondering at my solution.
This is without sorting optimization.

```go
amiCreateDate, ImageName, err := GetMatchingImage(resp.Images, inst.ImageId)
if err != nil {
  log.Err(err).Msg(&#34;failure to find ami&#34;)
}
```

Then I created a search function to iterate through the images for a match.
Yes, there was a lot of logging as I worked through this.

```go
// GetMatchingImage will search the ami results for a matching id
func GetMatchingImage(imgs []*ec2.Image, search *string) (parsedTime time.Time, imageName string, err error) {
	layout := time.RFC3339 //&#34;2006-01-02T15:04:05.000Z&#34;
	log.Debug().Msgf(&#34;searching for: %s&#34;, *search)
	// Look up the matching image
	for _, i := range imgs {
		log.Trace().Msgf(&#34;\t %s &lt;--&gt; %s&#34;, *i.ImageId, *search)
		if strings.ToLower(*i.ImageId) == strings.ToLower(*search) {
			log.Trace().Msgf(&#34;\t %s == %s&#34;, *i.ImageId, *search)

			p, err := time.Parse(layout, *i.CreationDate)
			if err != nil {
				log.Err(err).Msg(&#34;failed to parse date from image i.CreationDate&#34;)
			}
			log.Debug().Str(&#34;i.CreationDate&#34;, *i.CreationDate).Str(&#34;parsedTime&#34;, p.String()).Msg(&#34;ami-create-date result&#34;)
			return p, *i.Name, nil
			// break
		}
	}
	return parsedTime, &#34;&#34;, errors.New(&#34;no matching ami found&#34;)
}
```

I was impressed with the performance without any optimization of the api calls, and could see that with a proper approach to sorting the image ids I could improve the performance further.
However, the verbosity of doing some filtering to find and return the object was surprising, so I wrote this up to get feedback from other gophers and see what other idiomatic approaches are a solid way to filter down matching properties from result set.

Is there any library used by many to do this type of filtering, or is my .NET background coloring my perspective with dreams of Linq?

