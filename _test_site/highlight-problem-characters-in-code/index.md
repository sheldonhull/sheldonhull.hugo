# Highlight Problem Characters in Code


Use [Vscode Gremlins](https://github.com/nhoizey/vscode-gremlins) to help flag characters that shouldn&#39;t be in your code.

## Specifying a Range of Invalid Characters

You can give a range to flag multiple characters with a single rule.

For example, if using macOS and the option key is set to a modifier, it&#39;s easy to accidentally include a [Latin-1 Supplemental Character](https://unicode-table.com/en/blocks/latin-1-supplement/) that can be difficult to notice in your code.

To catch the entire range, the Latin-1-Supplement link provided shows a unicode range of: `0080—00FF`

Configure a rule like this:

```jsonc
&#34;gremlins.characters&#34;: {
    &#34;0080-00FF&#34;: {
        &#34;level&#34;: &#34;error&#34;,
        &#34;zeroWidth&#34;: false,
        &#34;description&#34;: &#34;Latin-1 Supplement character identified&#34;,
        &#34;overviewRulerColor&#34;: &#34;rgba(255,127,80,1)&#34;,
    },
}
```

I submitted this as a [PR](https://github.com/nhoizey/vscode-gremlins/pull/185) to project repo but figured I&#39;d document here as well in case it takes a while to get merged.

