# Go R1 Day 65


## progress

- Built mage tasks for go formatting and linting.

Using this approach, you can now drop a `magefile.go` file into a project and set the following:

```go
// &#43;build mage

package main

import (

	&#34;github.com/magefile/mage/mg&#34;
	&#34;github.com/pterm/pterm&#34;

	// mage:import
	&#34;github.com/sheldonhull/magetools/gotools&#34;
)
```

Calling this can be done directly now as part of a startup task.

```go
// Init runs multiple tasks to initialize all the requirements for running a project for a new contributor.
func Init() error {
	fancy.IntroScreen(ci.IsCI())
	pterm.Success.Println(&#34;running Init()...&#34;)
	mg.Deps(Clean, createDirectories)
	if err := (gotools.Golang{}.Init()); err != nil {  // &lt;----- From another package.
		return err
	}

	return nil
}
```

Additionally, handled some Windows executable path issues by making sure to wrap up the path resolution.

```go
// if windows detected, add the exe to the binary path
var extension string
if runtime.GOOS == &#34;windows&#34; {
  extension = &#34;.exe&#34;
}
toolPath := filepath.Join(&#34;_tools&#34;, item&#43;extension)
```

## Links

- [feat(gotools): ✨ add gotools for running go specific actions · sheldonhull/magetools@ef97514 · GitHub](https://github.com/sheldonhull/magetools/commit/ef9751455ea80321f197eca55b11126ea551371d)
- [refactor(gotools): 🚚 add namespace for Golang and update lint ci to d… · sheldonhull/magetools@51a9c3b · GitHub](https://github.com/sheldonhull/magetools/commit/51a9c3b1a2fbef3c794a41ecd2aa265d6c120326)
- [feat(gotools): 🎉 add go formatting and linting helpers · sheldonhull/magetools@541c2fc · GitHub](https://github.com/sheldonhull/magetools/commit/541c2fcb1eb2e4ffc647b65d407fbd48ee946ecc)
- [refactor(gotools): 🔨 windows support for executables · sheldonhull/magetools@d70712e · GitHub](https://github.com/sheldonhull/magetools/commit/d70712e87a94d5efc6e0f47652a0e61641005b12)

