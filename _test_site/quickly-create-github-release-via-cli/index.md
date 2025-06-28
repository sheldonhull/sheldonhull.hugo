# Quickly Create Github Release via Cli


## Intro

I&#39;ve been trying to improve modularization with Terraform.
Using Terraform Cloud, you get a private module repository.
The modules are linked to tags in git.

I&#39;ve wanted additionally to specifically create releases for the versions in addition to the tags, to make tracking of usable versions a little cleaner.

There are several ways to do this, including using the GitHub API, npm modules, and more.
I wanted a simple CLI tool to do this and ran across this great Go utility that worked seamlessly for me.

I&#39;ve used the [Hub cli](http://bit.ly/2w1fZYu) but the create release syntax never really worked for me.

## github-release

[Github-release](http://bit.ly/32qoDM9) is a simple golang cli that worked great for me.
Note that this is a fork.
This fork is more up to date than the original.

With go installed just run this to get it installed and available in `PATH`.

```powershell
go get github.com/itchio/gothub
```

To simplify GitHub access, ensure you set an environment variable for your user called GITHUB_TOKEN.

With PowerShell you can do it quickly like this (you might need to close and reopen vscode/terminal for this to be recognized)

```powershell
    [System.Environment]::SetEnvironmentVariable(&#39;GITHUB_TOKEN&#39;,&#39;tokenhere&#39;,&#39;User&#39;)
```

## Usage

To use this, you can chain together some steps and see how it can save you time on creating a GitHub release.

{{&lt; gist sheldonhull  &#34;53055bbff368a4ebe4e0794076a56c37&#34; &gt;}}

This helped me get moving faster ⚡ on using Github releases without the tedious work to create.
If this helped you or have any feedback, drop a comment below and let me know!
The comments are powered by Utterances which will open a Github issue to discuss further. 👍

