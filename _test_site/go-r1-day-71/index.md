# Go R1 Day 71


## progress

- Learn Go With Tests -&gt; Using `select` with channels to wait for multiple goroutines.
- Of particular interest is this:

&gt; Notice how we have to use make when creating a channel; rather than say var ch chan struct{}.
&gt; When you use var the variable will be initialised with the &#34;zero&#34; value of the type.
&gt; So for string it is &#34;&#34;, int it is 0, etc.
&gt; For channels the zero value is nil and if you try and send to it with &lt;- it will block forever because you cannot send to nil channels [select]

- Used `httptest` to create mock server for faster testing, and included wrapper around a calls to allow configuration for timeout.
This ensures that testing can handle in milliseconds, but default behavior in a deployment would be 10 seconds or more.

## links

- [select]
- [Go by Example: Select](https://gobyexample.com/select)
- [feat(11-select): 🎉 11-select initial framework without goroutines · sheldonhull/learn-go-with-tests-applied@b0a2641 · GitHub](https://github.com/sheldonhull/learn-go-with-tests-applied/commit/b0a26410b29ca9f7c8c316d60a523cfee56ae45c)
- [refactor(11-select): ♻️ refactor for DRY and better helper functions · sheldonhull/learn-go-with-tests-applied@1cf7092 · GitHub](https://github.com/sheldonhull/learn-go-with-tests-applied/commit/1cf7092c1e2f6f6373a5b5c57a422e76c415b8ec)
- [refactor(11-select): ♻️ add test case for error on timeout to avoid b… · sheldonhull/learn-go-with-tests-applied@77f01bd · GitHub](https://github.com/sheldonhull/learn-go-with-tests-applied/commit/77f01bd428b335b1ca65e9425b52429a2df56c01)
- [refactor(11-select): ♻️ refactor to allow configurable racer timeouts · sheldonhull/learn-go-with-tests-applied@65fe79c · GitHub](https://github.com/sheldonhull/learn-go-with-tests-applied/commit/65fe79ca9c02d483ab2c1d2c436377bc54c78129)

[select]: [go-fundamentals/select](https://quii.gitbook.io/learn-go-with-tests/go-fundamentals/select)

