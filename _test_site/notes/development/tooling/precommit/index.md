# precommit


A cheatsheet for various pre-commit hooks and things that help with linting, formatting, code scans and more. These all help &#34;shift left&#34; the review to eliminate more issues in the development workflow, rather than providing feedback only once the CI system is involved.

## The Frameworks

- [GitHub - evilmartians/lefthook: Fast and powerful Git hooks manager for any type of projects.](https://github.com/evilmartians/lefthook/) is a newer project based in Go.
- [pre-commit](https://pre-commit.com/) is python-based, very mature and supported.

## Precommit

### Install Precommit

A bit more complicated, depending on the Docker image used and the python tooling installed.
Assuming you have pip installed, then run `pip install pre-commit --user`

Here are some examples to get you started.

## Skipping A Precommit Hook

The pre-commit tasks can be overridden on a case-by-case basis.

The syntax for skipping is simple, just run the task with the name of the hook excluded like this:

      Don&#39;t commit to main.....................................................Passed
      check json5..........................................(no files to check)Skipped
      go-fmt...................................................................Passed
      golangci-lint...........................................................Skipped
      go-test-all..............................................................Failed
      - hook id: gotest 👈👈👈👈👈👈👈👈  # Use the hook id, not the text of the title
      - duration: 8.9s
      - exit code: 2

- To skip the example above: `SKIP=&#39;gotest&#39; git commit -am&#34;feat(fancy): my title&#34; -m&#34;- My Message Body&#34; &amp;&amp; git pull --rebase &amp;&amp; git push`.
- To skip multiple: `SKIP=&#39;gotest,go-fmt&#39; git myaction`.

## Filtering &amp; Triggering Tricks

Let&#39;s say you have a document directory and want to trigger a report or doc generation if anything in that changes.

You can do this pretty elegantly with pre-commit.

For example, let&#39;s add a mage task to generate docs when something in the package directory for go is updated.

    repos:
      # for specific updates that should result in an update to matched directories or files.
      - repo: local
        hooks:
          - id: docs:generate
            name: docs:generate
            entry: mage docs:generate
            language: system
            files: ^pkg/
            types: [file, go]

The types are pretty useful, not just to try and match on file names.

Use `identify-cli` which is a python cli and package included when you install pre-commit.

Run it against a directory or file and you&#39;ll get the outputs that pre-commit will accept.

For example, against a markdown file: `identify-cli README.md` and you should get: `[&#34;file&#34;, &#34;markdown&#34;, &#34;non-executable&#34;, &#34;text&#34;]`. Any of these (or all) can be used to filter when the hook runs.

Against a Go file: `[&#34;file&#34;, &#34;go&#34;, &#34;non-executable&#34;, &#34;text&#34;]`.

{{&lt; admonition type=&#34;info&#34; title=&#34;LeftHook&#34; open=true &gt;}}

Using pre-commit framework heavily, and no longer relying on Lefthook.

{{&lt; /admonition &gt;}}

## Lefthook

A great tool, but requires more work and is not as fully featured as pre-commit.
In most cases, I&#39;d recommend pre-commit tooling over Lefthook.

If you are just starting out, this requires more hands-on work but can result in faster checks and commits.

My advice would be to start with pre-commit if you want plug and play, and lefthook if you want to control the pre-commits explicitly and optimize for performance.

As long as you have the Go SDK installed, just run `go install github.com/evilmartians/lefthook@master`.

This framework is a little &#34;rougher&#34; and less supported than pre-commit framework, but for simple self-maintained hooks, I&#39;ve preferred this as it is much faster, and so I end up using it more.

Other installation methods are located at the installation guide [^lefthook-fullguide]

### Lefhook Tips

- Originally, I broke out lefthook into multiple files so I could drop them into a directory, but now I stick with one.
  Since it still requires editing the main file to extend and point to another file, I&#39;ve found a single file simpler to maintain.
- Disable parallel operation for anything formatting files or possibly not thread safe.
  While parallel operation seems great, most of the pre-commit tasks should run quickly, and formatting and linting files at the same time could lead to conflicts or problems.
  Use parallel operation for separate language test runs perhaps, like running Python tests and Go tests since those shouldn&#39;t conflict.
- `piped: true` is useful but hides the underlying tasks in the summary, so I suggest avoid unless you have tasks that really should feed into each other step by step.
  In this case, maybe you should have this just be part of your task run, such as `mage lint fmt` rather than two separate pre-commit hooks.

### Using Lefthook

Here are some updated configurations I&#39;ve started using.

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

Ideally, you want the pre-commit checks to only touch the files that changed to make things quick, but this requires some workarounds, since not all tools support a comma-delimited list of files passed in.

One big improvement to lefthook would be supporting a `for_each` operator, so that cross-platform looping on matched files could be run, instead of having to parse inside the script here.
I&#39;m pretty sure that this would be more compatible with various platforms as well, since this I believe uses your native shell, so you&#39;d have to be in WSL2 in Windows, for example, for the bash-like syntax to work.

See [ci-configuration-files](https://github.com/sheldonhull/ci-configuration-files/.markdownlint-cli2.yaml) for markdown lint config examples.

Install `gojq` or replace with `jq` if you have it.

    pre-commit:
      tags: markdown fmt
      parallel: false
      commands:
        markdownlintfix:
          files: git diff-index --name-only HEAD
          exclude: &#39;.licenses/*&#39;
          glob: &#39;*{.md}&#39;
          run: |
            echo &#34;⚡ markdownlint on: {files}&#34;
            for file in {files}
            do
              echo &#34;🔨 markdownlint: $file&#34;
              docker run --rm -v ${PWD}:/workdir --entrypoint=&#34;markdownlint-cli2-fix&#34; davidanson/markdownlint-cli2:latest &#34;$file&#34;
            done
        markdownlintcheck:
          files: git diff-index --name-only HEAD
          exclude: &#39;_licenses/*&#39;
          glob: &#39;*{.md}&#39;
          run: |
            echo &#34;⚡ markdownlint on: {files}&#34;
            for file in {files}
            do
              echo &#34;🔨 markdownlint: $file&#34;
              docker run --rm -v ${PWD}:/workdir --entrypoint=&#34;markdownlint-cli2&#34; davidanson/markdownlint-cli2:latest &#34;$file&#34;
            done
        shellcheck:
          tags: gotool gojq
          name: shellcheck
          files: git diff-index --name-only HEAD
          exclude: &#39;.licenses/*&#39;
          glob: &#39;*.sh&#39;
          run: docker run --rm -v ${PWD}:/mnt koalaman/shellcheck:stable --format=json {files}  | gojq
        # REQUIREMENTS: npm install --global prettier
        yamlfmt:
          files: git diff-index --name-only HEAD
          glob: &#39;*.yaml|*.yml&#39;
          exclude: &#39;.licenses/*&#39;
          skip_empty: false
          run: prettier --loglevel warn --no-error-on-unmatched-pattern --write &#34;{.yaml,.yml}&#34;
        # REQUIREMENTS: go install go.atrox.dev/sync-dotenv@latest
        # used to sync default dotenv files to an example file to avoid commits on main .env
        envfile:
          name: update env.example file
          files: &#39;*.env&#39;
          exclude: &#39;.licenses/*&#39;
          run: |
            cd env
            touch .env
            sync-dotenv
        # REQUIREMENTS: Mage Tasks Built (See github.com/sheldonhull/magetools)
        # CI=1 helps reduce formatting output to minimal
        # MAGEFILE_HASHFAST improves speed of calling mage by assuming your tasks haven&#39;t changed
        go:
          piped: true
          tags: go lint fmt
          files: git diff-index --name-only HEAD
          exclude: &#39;.licenses/*&#39;
          glob: &#39;*.{go,mod,sum}&#39;
          commands:
            fmt:
              run: CI=1 MAGEFILE_HASHFAST=1 mage fmt
            lint:
              run: CI=1 MAGEFILE_HASHFAST=1 mage lint

#### Pre-Push Checks

Most of these Mage-oriented tasks are from my magetools repo.

Note that while they filter based on the files being Go-related, they run against the entire repo.

    pre-push:
      parallel: false
      commands:
        fmt:
          files: git diff-index --name-only HEAD
          exclude: &#39;.licenses/*&#39;
          glob: &#39;*.{go,mod,sum}&#39;
          run: CI=1 MAGEFILE_HASHFAST=1 mage go:wrap
        lint:
          files: git diff-index --name-only HEAD
          exclude: &#39;.licenses/*&#39;
          glob: &#39;*.{go,mod,sum}&#39;
          run: CI=1 MAGEFILE_HASHFAST=1 mage lint
        test:
          files: git diff-index --name-only HEAD
          exclude: &#39;.licenses/*&#39;
          glob: &#39;*.{go,mod,sum}&#39;
          run: CI=1 MAGEFILE_HASHFAST=1 mage go:test
        gitleaks:
          tags: security gotool linux macos nowindows
          run: CI=1 MAGEFILE_HASHFAST=1 mage secrets:check

&lt;!-- links --&gt;

[^lefthook-fullguide]: [lefthook/full_guide.md at master · evilmartians/lefthook · GitHub](https://github.com/evilmartians/lefthook/blob/master/docs/full_guide.md#installation)

