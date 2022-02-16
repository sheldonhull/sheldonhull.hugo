---
title: precommit
date: 2021-06-16
summary: A cheatsheet for various pre-commit hooks and things that help with linting, formatting, code scans and more. These all help "shift left" the review to eliminate more issues in the development workflow, rather than providing feedback only once the CI system is involved.
slug: precommit
permalink: /docs/precommit
comments: true
tags:

- development
- devops
- linting
- automation
toc:
  enable: true
  keepStatic: false
  auto: true
typora-root-url: ../../static
typora-copy-images-to:  ../../static/images

---

A cheatsheet for various pre-commit hooks and things that help with linting, formatting, code scans and more. These all help "shift left" the review to eliminate more issues in the development workflow, rather than providing feedback only once the CI system is involved.

## The Frameworks

- [GitHub - evilmartians/lefthook: Fast and powerful Git hooks manager for any type of projects.](https://github.com/evilmartians/lefthook/) is a newer project based in Go.
- [pre-commit](https://pre-commit.com/) is python based, very mature and supported.

## Precommit

### Install Precommit

A bit more complicated, depending on the Docker image used and the python tooling installed.
Assuming you have pip installed, then run `pip install pre-commit --user`

Here's some examples to get you started.

## Skipping A Precommit Hook

The pre-commit tasks can be overridden on a case by case basis.

The syntax for skipping is simple, just run the task with the name of the hook excluded like this:

      Don't commit to main.....................................................Passed
      check json5..........................................(no files to check)Skipped
      go-fmt...................................................................Passed
      golangci-lint...........................................................Skipped
      go-test-all..............................................................Failed
      - hook id: gotest 👈👈👈👈👈👈👈👈  # Use the hook id, not the text of the title
      - duration: 8.9s
      - exit code: 2

- To skip the example above: `SKIP='gotest' git commit -am"feat(fancy): my title" -m"- My Message Body" && git pull --rebase && git push`.
- To skip multiple: `SKIP='gotest,go-fmt' git myaction`.

## Lefthook

A great tool, but requires more work and not as fully featured as pre-commit.
In most cases, I'd recommend pre-commit tooling over Lefthook.

If you are just starting out this requires more hands on, but can result in faster checks and commits.

My advice would be to maybe start with pre-commit if you want plug and play, and lefthook if you want to control the pre-commits explicitly and optimize for performance.

As long as you have the Go SDK installed, just run `go install github.com/evilmartians/lefthook@master`.

This framework is a little "rougher" and less supported than pre-commit framework, but for simple self-maintained hooks I've preferred this as it much faster, and so I end up using it more.

Other installation methods are located at the installation guide [^lefthook-fullguide]

### Lefhook Tips

- Originally I broke out lefthook into multiple files, so I could drop them into a directory, but now I stick with one.
Since it still requires editing the main file to extend and point to another file, I've found a single file simplier to maintain.
- Disable parallel for anything formatting files or possible not thread safe.
While parallel seems great, most of the pre-commit tasks should run quickly, and formatting and linting files at the same time could lead into conflicts or problems.
Use parallel for seperate language test runs perhaps, like running Python tests and Go tests since those shouldn't conflict.
- `piped: true` is useful but hides the underlying tasks in the summary, so I suggest avoid unless you have tasks that really should step by step feed into each other.
In this case, maybe you should have this just be part of your task run, such as `mage lint fmt` rather than 2 seperate pre-commit hooks.

### Using Lefthook

Here's some updated configurations I've started using.

#### Output

Reduce the noise:

    skip_output:
      - meta
      - success
    # - summary
    skip:
      - merge
      - rebase

#### Pre-commit Checks

These are basic quick checks for markdown (docs as code).
This illustrates one of the challenges in pre-commit framework tooling.

Ideally, you want the pre-commit checks to only touch the files that changed to make things quick, but this requires some work-arounds, since not all tools support a comma delimited list of files passed in.

One big improvement to lefthook, would be supporting `for_each` operator, so that cross-platform looping on matched files could be run, instead of having to parse inside the script here.
I'm pretty sure that this would be more compatible with various platforms as well, since this I believe uses your native shell, so you'd have to be in WSL2 in Windows, for example, for the bash-like syntax to work.

See [ci-configuration-files](https://github.com/sheldonhull/ci-configuration-files/.markdownlint-cli2.yaml) for markdown lint config examples.

Install `gojq` or replace with `jq` if you have it.

    pre-commit:
      tags: markdown fmt
      parallel: false
      commands:
        markdownlintfix:
          files: git diff-index --name-only HEAD
          exclude: '.licenses/*'
          glob: '*{.md}'
          run: |
            echo "⚡ markdownlint on: {files}"
            for file in {files}
            do
              echo "🔨 markdownlint: $file"
              docker run --rm -v ${PWD}:/workdir --entrypoint="markdownlint-cli2-fix" davidanson/markdownlint-cli2:latest "$file"
            done
        markdownlintcheck:
          files: git diff-index --name-only HEAD
          exclude: '_licenses/*'
          # exclude: '_licenses/*'
          # files: git diff-index --name-only HEAD #git ls-files **/*.md -m #git diff-index --name-only HEAD #git ls-files **/*/*.md  -m
          glob: '*{.md}'
          run: |
            echo "⚡ markdownlint on: {files}"
            for file in {files}
            do
              echo "🔨 markdownlint: $file"
              docker run --rm -v ${PWD}:/workdir --entrypoint="markdownlint-cli2" davidanson/markdownlint-cli2:latest "$file"
            done
        # REQUIREMENTS: go install github.com/itchyny/gojq/cmd/gojq@latest # cross platform alternative to jq
        shellcheck:
          tags: gotool gojq
          name: shellcheck
          files: git diff-index --name-only HEAD
          exclude: '.licenses/*'
          glob: '*.sh'
          run: docker run --rm -v ${PWD}:/mnt koalaman/shellcheck:stable --format=json {files}  | gojq
        # REQUIREMENTS: npm install --global prettier
        yamlfmt:
          files: git diff-index --name-only HEAD
          glob: '*.yaml|*.yml'
          exclude: '.licenses/*'
          skip_empty: false
          run: prettier --loglevel warn --no-error-on-unmatched-pattern --write "{.yaml,.yml}"
        # REQUIREMENTS: go install go.atrox.dev/sync-dotenv@latest
        # used to sync default dotenv files to an example file to avoid commits on main .env
        envfile:
          name: update env.example file
          files: '*.env'
          exclude: '.licenses/*'
          run: |
            cd env
            touch .env
            sync-dotenv
        # REQUIREMENTS: Mage Tasks Built (See github.com/sheldonhull/magetools)
        # CI=1 helps reduce formatting output to minimal
        # MAGEFILE_HASHFAST improves speed of calling mage by assuming your tasks haven't changed
        go:
          piped: true
          tags: go lint fmt
          files: git diff-index --name-only HEAD
          exclude: '.licenses/*'
          glob: '*.{go,mod,sum}' #'*.go|*.mod|*.sum'
          commands:
            fmt:
              run: CI=1 MAGEFILE_HASHFAST=1 mage fmt
            lint:
              run: CI=1 MAGEFILE_HASHFAST=1 mage lint

#### Pre-Push Checks

Most of these Mage oriented tasks from my magetools repo.

Note that while they filter based on the files being Go related, they run against the entire repo.

    pre-push:
      parallel: false
      commands:
        fmt:
          files: git diff-index --name-only HEAD
          exclude: '.licenses/*'
          glob: '*.{go,mod,sum}'
          # run: CI=1 MAGEFILE_HASHFAST=1 mage fmt      # alias for task that can contain formatting for all fmt tasks if you wish
          # run: CI=1 MAGEFILE_HASHFAST=1 mage go:fmt   # gofumpt based formatting
          run: CI=1 MAGEFILE_HASHFAST=1 mage go:wrap  # golines based formatting
        lint:
          files: git diff-index --name-only HEAD
          exclude: '.licenses/*'
          glob: '*.{go,mod,sum}'
          run: CI=1 MAGEFILE_HASHFAST=1 mage lint
        test:
          files: git diff-index --name-only HEAD
          exclude: '.licenses/*'
          glob: '*.{go,mod,sum}'
          run: CI=1 MAGEFILE_HASHFAST=1 GOTEST_FLAGS='-tags integration' mage go:test
        gitleaks:
          tags: security gotool linux macos nowindows
          run: CI=1 MAGEFILE_HASHFAST=1 mage secrets:check

<!-- links -->

[^lefthook-fullguide]: [lefthook/full_guide.md at master · evilmartians/lefthook · GitHub](https://github.com/evilmartians/lefthook/blob/master/docs/full_guide.md#installation)
