# sheldonhull.hugo

## Setup on mac

> ❗️ As of 2020-07, there are issues with the template that fail on later version of hugo.

## install

- Windows: `choco install-hugo-extended --version 0.69.2`
- On macOS, run: `brew install https://raw.githubusercontent.com/Homebrew/homebrew-core/5c50ad9cf3b3145b293edbc01e7fa88583dd0024/Formula/hugo.rb`

## Common Commands

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


## Algolia
Tutorial here:
[search-with-algolia-in-hugo](https://forestry.io/blog/search-with-algolia-in-hugo/)
```
npm install atomic-algolia
``


## Errors

## Windows Environment Variables

```powershell
[System.Environment]::SetEnvironmentVariable('ALGOLIA_APP_ID', '04HSGXXQD5','User')
[System.Environment]::SetEnvironmentVariable('ALGOLIA_ADMIN_KEY', $(Read-Host 'Enter Admin Key'),'User')
[System.Environment]::SetEnvironmentVariable('ALGOLIA_INDEX_NAME', 'sheldonhull','User')
[System.Environment]::SetEnvironmentVariable('ALGOLIA_INDEX_FILE', '_site/algolia.json','User')
```
