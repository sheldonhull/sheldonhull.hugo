# Go R1 Day 5


## Day 5 of 100

## progress

- I created my first unit test for go
- It&#39;s a bit interesting coming from a background with PowerShell and Pester as my primary unit test framework. For instance, in Pester you&#39;d declare the anything, but autodiscovery works with `*.tests.ps1`, being the normal convention.
- There is no pointer value providing the test package, it&#39;s just other PowerShell calling PowerShell.
- I&#39;m biased I know, but the first test condition being like below seems clunky. I was hoping for something that was more like Pester with `test.Equals(got, want,&#34;Error message&#34;)` as the syntax is more inline to what I&#39;d expect. I haven&#39;t dived in further so this is just a thought, hoping this is just the newbie 101 test case example and there are more succinct comparison and test methods available.

```go
package main

import &#34;testing&#34;

func TestHello(t *testing.T) {
	got := Hello()
	want := &#34;Hello, world&#34;
	if got != want {
		t.Errorf(&#34;got %q want %q&#34;, got, want)
	}
}

```

- Update: Good article explaining the opinionated approach with testing and reasoning not to use assertions located at: _Golang basics - Writing Units Tests_. This is helpful to someone wanting to learn. I don&#39;t want to force my prior paradigms on the language, because basically the whole reason I decided on Go over python or other language was wanting to learn something that helped me think in a fundamentally different way than using dotnet/Powershell. Python is very similar to PowerShell syntax wise for example, while Go is forcing me to look at things from a completely different view.
- I&#39;ll stick with the default package while I&#39;m learning. However, there is a package called _Testify_ that is worth exploring if I find I still want assertions later on.

## links

- [learn-go-with-tests](https://quii.gitbook.io/learn-go-with-tests/go-fundamentals/hello-world)
- [golang-writing-unit-tests](https://blog.alexellis.io/golang-writing-unit-tests)
- [testify](https://github.com/stretchr/testify)

