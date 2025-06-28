# Reflex for Quick Filewatching Commands


```shell
go install github.com/cespare/reflex@latest
```

Then you can run a command like:

```shell
reflex -r &#39;nginx.conf&#39; -- curl -v -L http://127.0.0.1:8080 2&gt;&amp;1 | grep -i &#34;^&lt; location:\|HTTP/1.1&#34;
```

You should see triggered output from the command whenever the file is saved.

Nice work @cespare. Found this pretty useful to speed up testing cycles with some cli tools.

Follow: [Caleb](https://github.com/cespare) and [twitter](https://twitter.com/calebspare) for more cool Go magic.

