# Go R1 Day 52


## progress

- published extension pack for Go[^ext]
- Learned about magic number linter in `golanglint-ci`.
For instance this would be flagged as a bad practice (while not applicable for a simple test like this, having a const makes sense in almost all other cases).

```go
func Perimeter(width float64, height float64) float64 {
	return 2 * (width &#43; height)
}
```

- Learned a few extra linter violations and how to exclude including:
    - `lll`: for maximum line length
    - `packagetest`: for emphasizing blackbox testing.
    - `gochecknoglobals`: for ensuring global variables aren&#39;t used
    - `nlreturn`: for returning without a black line before.
    That&#39;s a &#34;nit&#34;, but nice for consistency (though I&#39;d like to see this as an autoformatted rule with fix applied.)

## links

[feat: structs-methods-and-interfaces -&gt; initial functions without str… · sheldonhull/learn-go-with-tests-applied@be9ce01 · GitHub](https://github.com/sheldonhull/learn-go-with-tests-applied/commit/be9ce01ea566c8e75d74f2fb7a0d7a91dd648d00)

[^ext]: [Extension Pack for Go]({{&lt; relref &#34;2021-07-13-my-first-vscode-extension-pack-for-go&#34; &gt;}} &#34;My First Vscode Extension Pack for Go&#34;))

