# Common Commands

To Update submodules and download

```powershell
git submodule update --init --recursive
git submodule update --recursive
```

You can update a theme to the latest version by executing the following command in the root directory of your project: [ref](https://gohugo.io/hosting-and-deployment/hosting-on-netlify)

```
git submodule update --rebase --remote
```


to publish dev changes with interesting name... that doesn't have much value but entertainment. Run `install-module Nameit -scope currentuser` first and then run the following:

```powershell
git add . ; git commit -m "commit-$(invoke-generate '[adjective]-[noun]')"; git push
```


# Algolia
Tutorial here:
[search-with-algolia-in-hugo](https://forestry.io/blog/search-with-algolia-in-hugo/)
```
npm install atomic-algolia
```
