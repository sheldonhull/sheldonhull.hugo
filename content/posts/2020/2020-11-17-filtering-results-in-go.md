---
date: 2020-11-17T15:18:17-06:00
title: Filtering Results in Go
slug: filtering-results-in-go
summary:
  Comparing the basic filtering from PowerShell to syntax in Go
typora-root-url: ../../../static
typora-copy-images-to:  ../../../static/images
tags:
  - development
  - golang
  - tech
toc: true
---

## Where Filtering

I explored a bit on filtering objects with Go for the AWS SDK v1.

Coming from PowerShell, I'm used to a lot of one-liners that do a lot of magic behind the scenes, so Go is both refreshing in it's clarity, and a bit verbose at times since the language features are more sparse.

In PowerShell, you can filter results with a variety of methods, including examples like below (but not limited to)

- `$collection.Where{$_.Value -eq 'foo'}`
- `$collection | Where-Object {$_.Value -eq 'foo'}`
- `$collection | Where-Object Value -eq 'foo'`

When exploring the an unmarshalled result in Go, I found it a bit verbose compared to what I was used to, and wondered if there are no "Where" clause helper libraries that cut down on this verbosity, and also still considered idiomatic (Go's favorite word 😃).

## Scenario

Let's get all the EC2 Image results for a region and match these with all the EC2 instances running.
Filter down the results of this to only the ami matching what the EC2 instance is using.

In PowerShell this might look like `$AmiId = $Images.Where{$_.ImageId -eq $Search}.ImageId`.

As a newer gopher, this is what I ended up doing,and wondering at my solution.
This is without sorting optimization.

```go
amiCreateDate, ImageName, err := GetMatchingImage(resp.Images, inst.ImageId)
if err != nil {
  log.Err(err).Msg("failure to find ami")
}
```

Then I created a search function to iterate through the images for a match.
Yes, there was a lot of logging as I worked through this.

```go
// GetMatchingImage will search the ami results for a matching id
func GetMatchingImage(imgs []*ec2.Image, search *string) (parsedTime time.Time, imageName string, err error) {
	layout := time.RFC3339 //"2006-01-02T15:04:05.000Z"
	log.Debug().Msgf("searching for: %s", *search)
	// Look up the matching image
	for _, i := range imgs {
		log.Trace().Msgf("\t %s <--> %s", *i.ImageId, *search)
		if strings.ToLower(*i.ImageId) == strings.ToLower(*search) {
			log.Trace().Msgf("\t %s == %s", *i.ImageId, *search)

			p, err := time.Parse(layout, *i.CreationDate)
			if err != nil {
				log.Err(err).Msg("failed to parse date from image i.CreationDate")
			}
			log.Debug().Str("i.CreationDate", *i.CreationDate).Str("parsedTime", p.String()).Msg("ami-create-date result")
			return p, *i.Name, nil
			// break
		}
	}
	return parsedTime, "", errors.New("no matching ami found")
}
```

I was impressed with the performance without any optimization of the api calls, and could see that with a proper approach to sorting the image ids I could improve the performance further.
However, the verbosity of doing some filtering to find and return the object was surprising, so I wrote this up to get feedback from other gophers and see what other idiomatic approaches are a solid way to filter down matching properties from result set.

Is there any library used by many to do this type of filtering, or is my .NET background coloring my perspective with dreams of Linq?
