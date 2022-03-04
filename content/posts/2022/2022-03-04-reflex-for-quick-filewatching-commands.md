---

date: 2022-03-04T22:40:24+0000
title: Reflex for Quick Filewatching Commands
slug: reflex-for-quick-filewatching-commands
tags:

- tech
- development
- microblog

# images: [/images/]

typora-root-url: ../../../static
typora-copy-images-to:  ../../../static/images
---

```shell
go install github.com/cespare/reflex@latest
```

Then you can run a command like:

```shell
reflex -r 'nginx.conf' -- curl -v -L http://127.0.0.1:8080 2>&1 | grep -i "^< location:\|HTTP/1.1"
```

You should see triggered output from the command whenever the file is saved.

Nice work @cespare. Found this pretty useful to speed up testing cycles with some cli tools.

Follow: [Caleb](https://github.com/cespare) and [twitter](https://twitter.com/calebspare) for more cool Go magic.
