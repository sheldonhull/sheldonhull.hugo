# Go R1 Day 57


## progress

- Did some adhoc work in this repo (the hugo repo that contains this blog) testing out Mage, which is a Go based Make alternative.
- Generated dynamic target directory for hugo posts using stringify for kebab case.
- Unexpected behavior when generating dynamic file path including date.

```go
year, month, day := time.Now().Date()
str := stringy.New(title)
slugTitle := strings.Join([]string{string(year), string(month), string(day), str.KebabCase(&#34;?&#34;, &#34;&#34;).ToLower()}, &#34;-&#34;)
```

The output failed to handle the year, resulting in some odd `\x18` path generation.

In reviewing the values from returned from `time.Now().Date`, I realized it wasn&#39;t an int value being returned.

To work through the definition, I figured this would be a good chance to use the cli only to find the docs.

```shell
go doc &#39;time.Now&#39;
```

returned the following:

```text
package time // import &#34;time&#34;

func Now() Time
    Now returns the current local time.
```

To get the source code for the function:

- `go doc -src &#39;time.Now&#39;`
- `go doc -src &#39;time.Date&#39;`

This shows the return value of `Date()` is actually `time` type, not int.

Still couldn&#39;t see where the multiple return parameters were defined so I ran:

```shell
go install golang.org/x/tools/cmd/godoc@latest
godoc --http 127.0.0.1:3030
```

Ok... Figured it out. I was looking at the `func Date()`.
However, what I should have been looking at was the exported method `func (Time) Date`.
This correctly shows:

```text
func (t Time) Date() (year int, month Month, day int)
```

I still couldn&#39;t figure this out until I tried running it in the playground.

{{&lt; fa-icon solid  play &gt;}} [Playground - Demonstrate Problem](https://play.golang.org/p/eVT1Qbnyzgb)

```log
./prog.go:11:37: conversion from int to string yields a string of one rune, not a string of digits (did you mean fmt.Sprint(x)?)
```

Runes.
Strings.
I know folks say it boils down to 1&#39;s and 0&#39;s, but dang it... seems like my life always boils down to strings. 😆

{{&lt; fa-icon solid  play &gt;}} [Playground - Fixed The Problem](https://play.golang.org/p/_GX1pYQIySx)

Finally got it all working.

Strongly typed languages are awesome, but this type of behavior is not as easy to figure out coming from a background with dynamic languages. I

In contrast, PowerShell would be: `Get-Date -Format &#39;yyyy&#39;`.

Here&#39;s an example of the Mage command then to generate a blog post with a nice selection and prompt.

```go
// calculatePostDir calculates the post directory based on the post title and the date.
func calculatePostDir(title string) string {
 year, month, day := time.Now().Date()
 str := stringy.New(title)
 kebabTitle := str.KebabCase().ToLower()
 slugTitle := strings.Join(string(year), string(month), string(day),kebabTitle, &#34;-&#34;) ///stringy.ToKebabCase(title)

 pterm.Success.Printf(&#34;Slugify Title: %s&#34;, slugTitle)
 filepath := filepath.Join(contentDir, string(year), slugTitle)
 pterm.Success.Printf(&#34;calculatePostDir: %s&#34;, slugTitle)
 return filepath
}
```

Then creation of the post:

```go
// New namespace groups the new post generatation commands.
type New mg.Namespace
// NewPost creates a new post in the Hugo format.
func (New) Post() error {
 prompt := promptui.Select{
  Label: &#34;Select Type of Post j/k to navigate&#34;,
  Items: []string{&#34;100DaysOfCode&#34;, &#34;microblog&#34;, &#34;blog&#34;},
 }
 _, result, err := prompt.Run()
 if err != nil {
  pterm.Success.Printf(&#34;Prompt failed %v\n&#34;, err)
  return err
 }
 pterm.Success.Printf(&#34;New Post: [%s]&#34;, result)
 promptTitle := promptui.Prompt{
  Label: &#34;Enter Title&#34;,
 }
 title, err := promptTitle.Run()
 if err != nil {
  pterm.Error.Printf(&#34;Prompt failed %v\n&#34;, err)
  return err
 }
 // the archetype in archtytpes directory to use
 var kind string

 switch result {
 case &#34;100DaysOfCode&#34;:
  kind = &#34;code&#34;
 default:
  kind = result
 }
 fileName := calculatePostDir(title)
 if err := sh.RunV(&#34;hugo&#34;, &#34;new&#34;, fileName, &#34;--kind&#34;, kind); err != nil {
  return err
 }
 return nil
}
```

## links

- [GitHub - gobeam/stringy: Convert string to camel case, snake case, kebab case / slugify, custom delimiter, pad string, tease string and many other functionalities with help of by Stringy package.](https://github.com/gobeam/stringy)
- [Mage · GitHub](https://github.com/magefile/)

