---

date: 2021-07-13T19:10:50-05:00
title: My First Vscode Extension Pack for Go
slug: my-first-vscode-extension-pack-for-go
tags:
- tech
- development
- microblog
- vscode
- golang
images: [/images/2021-07-13-19.05.49-vscode-extension-pack.png]
typora-root-url: ../../../static
typora-copy-images-to:  ../../../static/images
---

Took a swing at creating my own extension pack for Go.

> :(fab fa-github fa-fw):  [sheldonhull/extension-pack-go - GitHub](https://github.com/sheldonhull/extension-pack-go)

This was a good chance to familarize myself with the eco-system and simplify sharing a preset group of extensions.

Setup the repo with a `Taskfile.yml` to simplify running in the future.
If frequent updates needed to happen, it would be easy to plug this into GitHub actions with a dispatch event and run on demand or per merge to main.

Here's the marketplace link if you want to see what it looks like: [Marketplace - extension-pack-go](https://marketplace.visualstudio.com/items?itemName=sheldon-hull.extension-pack-go)

I could see this process being improved in the future with GitHub only requirements.
At this time, it required me to use my personal Azure DevOps org to configure access and publishing.

## Resources

[Publishing Extensions](https://code.visualstudio.com/api/working-with-extensions/publishing-extension)
