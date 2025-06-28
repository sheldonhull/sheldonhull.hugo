# Make Vscode Annoy Me When I Make a Typo


Not sure why, but I&#39;ve had 2 typos that keep plauging me.

- `ngnix` should be `nginx`
- `chocolatey` should be `chocolatey`

With Go, I get compile errors with typos, so no problem.
With PowerShell or Bash, this can be really annoying and waste time in debugging.

You can configure many autocorrect tools on a system level, but I wanted a quick solution for making it super obvious in my code as I typed without any new spelling extensions.

Install Highlight: `fabiospampinato.vscode-highlight` [^highlight]

Configure a rule like this:

```jsonc
&#34;highlight.regexes&#34;: {
    &#34;(ngnix)&#34;: [
            {
                &#34;overviewRulerColor&#34;: &#34;#ff0000&#34;,
                &#34;backgroundColor&#34;: &#34;#ff0000&#34;,
                &#34;color&#34;: &#34;#1f1f1f&#34;,
                &#34;fontWeight&#34;: &#34;bold&#34;
            },
            {
                &#34;backgroundColor&#34;: &#34;#d90000&#34;,
                &#34;color&#34;: &#34;#1f1f1f&#34;
            }
        ],
}
```

[^highlight]: [vscode-highlight](https://github.com/fabiospampinato/vscode-highlight)

