# Mage


## Using Go for Task Running &amp; Automation

My preferred tool at this time is Mage.

Mage replaces the need for Bash or PowerShell scripts in your repo for core automation tasks, and provides the benefits of Go (cross-platform, error handling paradigm, readability, performance, etc).

### Getting Started With Mage

#### Use Go

- Run `go install github.com/magefile/mage@latest`
- Run `go install github.com/iwittkau/mage-select@latest`
- For asdf: `asdf plugin-add mage &amp;&amp; asdf install mage latest &amp;&amp; asdf local mage latest`

#### Initialize a New Project

- [Scripts-To-Rule-Them-All-Go](https://github.com/sheldonhull/scripts-to-rule-them-all-go): A repo I&#39;ve set up as a quick start template for a Mage enabled repository with linting and core structure already in place.
- [Magetools](https://github.com/sheldonhull/magetools): Reusable packages that can be pulled in to jump-start common tasks or utilities.
  - Examples:
    - Enhanced go formatter with `mage go:wrap`.
    - Preinstall common Go tools such as the language server, dlv, gofumpt, golangci-lint, and more with `mage go:init`.
    - Provide a GitHub repo for a Go binary and use in tasks. If the binary isn&#39;t found, it will automatically grab it when invoked.
    - Pre-commit registration and tooling.
    - Install Git Town, Bit, and other cool git helpers with `mage gittools:init`.
    - Chain together all your core tasks with `mage init` to allow for a fully automated dev setup.

### Why Should I Care About Mage?

- I&#39;ve never felt my automation was as robust, stable, and easy to debug as when I&#39;ve used Mage.
- I&#39;ve done a lot of experimenting with others, and had primarily relied on `InvokeBuild` (PowerShell-based) in the past.
- Mage takes the prize for ease of use.
- You can migrate a make file relatively easily if you want to just call tools directly.
- You can benefit from using Go packages directly as you up your game.
  - Example: instead of calling kubectl directly, I&#39;ve used a Helm Go library that does actions like validation, linting, and templating directly from the same core code that kubectl itself uses.

### Mage Basics

- Mage is just Go code.
- It does a little &#34;magic&#34; by simply matching some functions that match a basic signature such as `error` output, like `func RunTests(dir string) error {...}`.
- You can get around needing Mage by creating Go files, but you&#39;d have to add basic args handling for the `main()` entry point, and help generation.
- Mage tries to simplify the CLI invocation by auto-discovering all the matched functions in your `magefiles` directory and providing as tasks.
- Mage does not currently support flags, though this is actively being looked at.
  - This means you are best served by keeping tasks very simple. For example, `mage deploy project dev` is about as complex as I&#39;d recommend.
  - Normally, you&#39;d invoke with `mytool -project ProjectName -env dev`, and positions wouldn&#39;t matter. With Mage, it&#39;s positional for simplicity, so it&#39;s best to keep it simple!

### My Mage Tips

- Use the pattern shown in my template repo above.
  - Use `magefiles` directory.
  - Provide a single `magefile.go` that does your imports and list basic commands. If it&#39;s a big project, then just have it import and put all your tasks in subdirectories that it imports.
- Provide a `magefiles/constants/constants.go &amp;&amp; vars.go` instead of worrying about globals.
  This is for build automation, and having a configured file with standards that can&#39;t change or global variables is a nice alternative to needing more yaml files.
- Use Pterm for enhanced logging experience, as it provides some beautiful output for users.
- For extra benefit, standardize with a `mage doctor` command in your project that validates issues experienced and gets added to over time.
  This can help troubleshoot any environment or project issues if you maintain and add a list of checks being run.
  Using Pterm, you can make this into a nice table output like this:

![Mage Doctor Output](/images/notes/2022-06-11-16.52.33-mage-doctor.png &#39;Mage Doctor Output&#39;)

