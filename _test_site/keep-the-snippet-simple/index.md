# Keep the Snippet Simple


I took a quick step back when too many parentheses started showing up.
If you question the complexity of your quick snippet, you are probably right that there is a much simpler way to do things.

I wanted to get a trimmed message of the results of `git status -s`.
As I worked on this snippet, I realized it was becoming way overcomplicated. 😆

```powershell
$(((git status -s) -join &#39;,&#39;) -split &#39;&#39;)[0..20] -join &#39;&#39;
```

I knew my experimentation was going down the wrong road, so I took a quick step back to see what someone else did.
Sure enough, [Stack Overflow](https://stackoverflow.com/a/30856340/68698) provided me a snippet.

```powershell
$(((git status -s) -join &#39;,&#39;))[0..20] -join &#39;&#39;     # returns the string &#39;12345&#39;
```

Moral of the story... there&#39;s always someone smarter on Stack Overflow. 😆

