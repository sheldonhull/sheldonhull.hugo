# Go R1 Day 62


## progress

- Worked with mocks.

Still using the `is` package to test.

```go
if !reflect.DeepEqual(want, spySleepPrinter.Calls) {
  t.Errorf(&#34;wanted calls %v got %v&#34;, want, spySleepPrinter.Calls)
}
```

was replaced with:

```go
is.Equal(spySleepPrinter.Calls, want) // spySleepPrinter shows correct order of calls
```

Go is messing with my head with how everything gets simplified to the lowest common interface when possible.
Instead of buffer, I&#39;d want to use `io.Writer` for example.
This abstraction is where there is so much power, but it requires a deeper understanding of following the dependency tree to know what properly satisfies the interface.
I&#39;m finding that one layer isn&#39;t enough sometimes with lower level interfaces, and requires getting comfortable with more low level packages from the standard library.
Pretty cool that I didn&#39;t need to do anything more complex to do a comparison.

### When To Use Mocking

&gt; Without mocking important areas of your code will be untested.
&gt; In our case we would not be able to test that our code paused between each print but there are countless other examples.
&gt; Calling a service that can fail?
&gt; Wanting to test your system in a particular state?
&gt; It is very hard to test these scenarios without mocking.
[^mocking]

### Other Good Insights

&gt; &#34;When to use iterative development? You should use iterative development only on projects that you want to succeed.&#34;
&gt; - Martin Fowler

I really agree with this next quote.
I&#39;ve seen this happen so often with the pressures of a project, and feel it&#39;s the excuse that causes the escalation of technical debt that becomes difficult to untangle retroactively.

&gt; Try to get to a point where you have working software backed by tests as soon as you can, to avoid getting in rabbit holes and taking a &#34;big bang&#34; approach. [^mocking]

## links

- [chore: formatting and devcontainer addition · sheldonhull/learn-go-with-tests-applied@9015a0b · GitHub](https://github.com/sheldonhull/learn-go-with-tests-applied/commit/9015a0b4b15d72c2523dd1c2136ed222d125d0ea)
- [chore: add extension · sheldonhull/learn-go-with-tests-applied@950ccd1 · GitHub](https://github.com/sheldonhull/learn-go-with-tests-applied/commit/950ccd16da38b29c7161b17e5bef622fe4d6c64d)
- [chore(docker): add bit cli to dockerfile · sheldonhull/learn-go-with-tests-applied@9be2573 · GitHub](https://github.com/sheldonhull/learn-go-with-tests-applied/commit/9be2573a6f6dc3643052248515f6c344b80fa74e)
- [refactor(009-mocking): use bytes for input · sheldonhull/learn-go-with-tests-applied@56b8740 · GitHub](https://github.com/sheldonhull/learn-go-with-tests-applied/commit/56b8740c64d508289c56125eaa82c3e989d91f1a)
- [refactor(009-mocking): refactored with constants · sheldonhull/learn-go-with-tests-applied@24a2709 · GitHub](https://github.com/sheldonhull/learn-go-with-tests-applied/commit/24a2709f0ac34487be60900f8c8d84ca023e361c)
- [refactor(009-mocking): add sleep for dramatic effect · sheldonhull/learn-go-with-tests-applied@fbb7d6d · GitHub](https://github.com/sheldonhull/learn-go-with-tests-applied/commit/fbb7d6dca28ee07276cd49387b4f72d5c88eb443)
- [refactor(009-mocking): add sleep interface and first mocking steps · sheldonhull/learn-go-with-tests-applied@74b975c · GitHub](https://github.com/sheldonhull/learn-go-with-tests-applied/commit/74b975cbc9b99abafb3cf87f898b986242c275a7)
- [refactor(009-mocking): mocking the order successfully · sheldonhull/learn-go-with-tests-applied@9cc2c7e · GitHub](https://github.com/sheldonhull/learn-go-with-tests-applied/commit/9cc2c7e96fbaa5b08792e318f739aba4de769401)

[^mocking]: [Mocking](https://quii.gitbook.io/learn-go-with-tests/go-fundamentals/mocking)

