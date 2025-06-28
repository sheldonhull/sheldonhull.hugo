# Go R1 Day 16


## Day 16 of 100

## progress

- refactored AWS SDK call to export a named file using flags.
- Iterated through regions so cli call aggregated all results from all regions into single JSON.
- Working with v1 makes me want v2 so much more.
The level of pointers required is ridiculous.
At one point I had something like `&amp;*ec2` due to the SDK requirements.
Having to write a filter with: `Filters: { Name: aws.String(&#34;foo&#34;)}` is so clunky.
I believe in v2 this is greatly simplified, and the code is much cleaner.

## links

- [DescribeRegionsInput](https://pkg.go.dev/github.com/aws/aws-sdk-go@v1.35.31/service/ec2#DescribeRegionsInput.GoString)

