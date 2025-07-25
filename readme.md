# sheldonhull.hugo

<img width="200" height="200" src="static/images/sheldon-avatar.jpg" alt="Sheldon Hull Gopher Avatar" />

## Overview

This blog has gone through several phases: Wordpress, Jekyll, Ghost, and Hugo.
This site has also used a mix of themes at times as the desire to change things up hit me.

Prior theme is in history for [Hermit](https://themes.gohugo.io/hermit/)

At this time, I've migrated to using [Codeit](https://codeit.suntprogramator.dev/).

Why?

- Still being developed/maintained with some active contributors.
- Minimal UI/theme
- Very good formatting and table of contents for docs and long-form content.
- Algolia integration already handled beautifully.
- My preferred comment system of utterances is natively supported as well.
- Beautiful admonition formatting, which I really like including in posts.

## install

- Open in codespaces or in local docker container and then run `npm ci` to ensure all tooling is initialized
- ✨ *NEW 2025-01*: Use Dagger for build automation. Run `dagger call build` to build the site or `dagger call serve` to preview.

## Building & Tooling

- Uses Netlify for builds with Quartz static site generator
- The core logic for building and previews is handled via [Dagger](https://dagger.io/) functions in `.dagger/main.go`
- Available Dagger functions:
  - `dagger call build` - Build the static site
  - `dagger call serve` - Serve the site for preview
  - `dagger call check` - Check TypeScript and formatting
  - `dagger call format` - Format code with Prettier
- Codespaces supported natively, so all the required tooling is ready to run in cloud for editing.
- Secrets for Algolia Admin key are in Github Secrets with repo and loaded as well via devcontainer. Set this variable in your local environment if running only locally. See the `Taskfile.yml` for naming/details.
- Automatic PR update of dependencies via renovate
- Automatic PR via ImgBot PR for image optimization
- I've adapted permalinks to support me putting content in yearly archive directories, but *not* include them in the url. This reduces noise when creating/editing recent posts.

## Editing/Blogging

At this time, I use VSCode primarily.
I've tried many other approaches, but can't get clean and simple workflow even if the UI (like Typora) is better.
Using VSCode also lets me automate with InvokeBuild to make it quick to create new posts of different types.

You can also use "task explorer" extension which should be setup in this codespace, and it will give you buttons to trigger the tasks.

## Errors

## Environment Variables

```bash
# In profile
export ALGOLIA_APP_ID=04HSGXXQD5
export ALGOLIA_ADMIN_KEY=
export ALGOLIA_INDEX_NAME=sheldonhull.com
export ALGOLIA_INDEX_FILE=_site/algolia.json
```

```powershell
[System.Environment]::SetEnvironmentVariable('ALGOLIA_APP_ID', '04HSGXXQD5','User')
[System.Environment]::SetEnvironmentVariable('ALGOLIA_ADMIN_KEY', $(Read-Host 'Enter Admin Key'),'User')
[System.Environment]::SetEnvironmentVariable('ALGOLIA_INDEX_NAME', 'sheldonhull.com','User')
[System.Environment]::SetEnvironmentVariable('ALGOLIA_INDEX_FILE', '_site/algolia.json','User')
```

## Codeit Theme Reference

- [The Default Yaml Frontmatter Options](https://codeit.suntprogramator.dev/theme-documentation-content/#front-matter)

## My Customization

The primary changes I've made that I couldn't easily contribute back upstream...

- Docs section list only and sorted by lastmod date
- Microblog section with customized list for display of posts entire content in section view.
- Creative section for photo gallery
- Neon glow effect
- More shortcodes
- Draft Go project in this repo for replacing atomic-algolia with my own Go CLI. On hold till I need/have time to experiment more with this. I got the npm package to run for atomic-algolia so this isn't a priority right now.
- Custom layouts/Shortcodes (leveraging others work across the web):
  - Series support so I can bind together an automatic index of linked posts with a header at the top.
  - Mailbrew embed/subscription based form (really great service!) so I can send weekly newsletters.
  - Custom implementation of [fancybox](http://fancyapps.com/fancybox/3/) which provides a really nice slick UI for photo gallery. Only 2 galleries right now but maybe will expand more as photo interest increases. Not doing a lot of photography right now.
  - mermaid diagram embed
  - asciicinema embed. Limited use so far, but really like it for demonstrating automation and terminal work in comparison to gifs.
  - Rendering the site locally for dev work shows colorful tags for future scheduled/draft posts to make them pop out when I'm reviewing content.

## Things I Want to Do With Site Still

### Cheatsheets

I'm really inspired by the layouts and clean look of devhints.io.
I'd like to customize a layout for the theme that helps align multiple column based flex layouts with more of a "cheatsheet" look like devhints.
Currently, my docs page works, but it's not as much of a cheatsheet format as I'd like.

### Go Atomic Algolia

Replace atomic-algolia npm package with an efficient Go based tool.
Put on hold for now, but plan on addressing someday when I'm a bit better at Go.

## Gist Data Source Shortcode

I'd like to have a new shortcode that extracts the content of a target gist and then renders the markdown/code blocks as if I put the contents in the markdown file itself.
Would be interesting to promote the possibility of more reference/cheatsheets as gists, while still rendering and presenting in full on blog, not just as a gist embedded javascript widget.

## Closing

If you looked through this congrats. 👏

I put this updated readme out since there may be some folks new to Hugo and curious about how a repo like this can be used.
Maybe you'll find it inspiring as a jump start of your own.

Regardless, hope you have a good journey with it yourself.
I've had since 2013 blogging now and it's pretty cool to see how things have evolved over time.

## WSL2

In WSL2:

    sudo apt-get install build-essential
    echo "Brew install in ubuntu might take 5 or more minutes"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/shull/.zprofile
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    brew install gcc
    brew install hugo
    source ~/.zshrc

## Docker

Preliminary docker support for running hugo this way instead of brew install can be done with:

      HUGO_VERSION=0.82 \
    && docker-compose -f "docker-compose.hugo.yml" down --remove-orphans --volumes \
    && docker-compose -f "docker-compose.hugo.yml" build --build-arg HUGO_VERSION=$HUGO_VERSION \
    && docker-compose -f "docker-compose.hugo.yml" up

## Other Tools

Use `brew install exiftool` for editing image `EXIF` data so image gallery doesn't have to read from sidecar files.

## Troubleshooting

### Devcontainers

### Go Compile Version Does Not Match Go Tool Version

Probably because I'm using `linuxbrew` mixed in with other docker/goup scripts.

- Use linuxbrew version: `export GOROOT=/home/linuxbrew/.linuxbrew/opt/go/libexec`
- Otherwise, remove Go from linux brew setup. (recommended, but no time)

## Other Credits
