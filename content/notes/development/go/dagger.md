---
title: Dagger
slug: dagger
lastmod: 2023-03-21 13:44
date: 2023-03-07 19:20
tags:
  - containers
  - go
  - build-release-engineering
---

[Containerized magic with Go and BuildKit](https://dagger.io?ref=sheldonhull.com)

Will put some experience notes here soon as I've successfully built angular and nginx containers with it and overall was a great experience.
With the upcoming services support, I can see a whole lot more usage cases too.

{{< admonition type="example" title="Example Building An Angular Project" open=false >}}
Using mage, here's an example of how to invoke Mage to build an angular project without any angular tooling installed locally.

```go
const AngularVersion = "15"

// Build runs the angular build via Dagger.
func (Dagger) Build(ctx context.Context) error {
  client, err := dagger.Connect(ctx, dagger.WithLogOutput(os.Stdout))
  if err != nil {
    pterm.Error.Printfln("unable to connect to dagger: %s", err)
    return err
  }
  defer client.Close()

  homedir, err := os.UserHomeDir()
  if err != nil {
    return err
  }
  npm := client.Container().From("node:lts-alpine")
  npm = npm.WithMountedDirectory("/src", client.Host().Directory(".")).
    WithWorkdir("/src")

  path := "dist/"
  npm = npm.WithExec([]string{"npm", "install", "-g", fmt.Sprintf("@angular/cli@%s", AngularVersion)})
  npm = npm.WithExec([]string{"ng", "config", "-g", "cli.warnings.versionMismatch", "false"})
  npm = npm.WithExec([]string{"ng", "v"})
  npm = npm.WithExec([]string{"npm", "ci"})
  npm = npm.WithExec([]string{"ng", "build", "--configuration", "production"})

  // Copy "dist/" from container to host.
  _, err = npm.Directory(path).Export(ctx, path)
  if err != nil {
    return err
  }
  return nil
}
```

{{< /admonition >}}

{{< admonition type="example" title="example of handling both local and CI private npm auth" open=false >}}

Here you can handle both running in a CI context or a remote context by evaluting for a CI variable that would provide back a CI system generated `.npmrc`.
If this isn't provided, mount the file from the home directory into the build container.

Note this container isn't for publishing, it's a build container copying the `dist/` contents back to the project directory.

```go
npmrcFile := &dagger.Secret{}

// bypassing any mounting of npmrc, as CI tooling should update any private  inline with current file here
if os.Getenv("NPM_CONFIG_USERCONFIG") != "" {
  pterm.Info.Printfln("[OVERRIDE] NPM_CONFIG_USERCONFIG: %s", os.Getenv("NPM_CONFIG_USERCONFIG"))
  npmrcDir := filepath.Dir(os.Getenv("NPM_CONFIG_USERCONFIG"))
} else {
  // [DEFAULT] NPM config set from home/.npmrc
  npmrcFile = client.Host().Directory(homedir, dagger.HostDirectoryOpts{Include: []string{".npmrc"}}).File(".npmrc").Secret()

  // if npmrcFile doesn't exist output error
  if _, err := os.Stat(filepath.Join(homedir, ".npmrc")); os.IsNotExist(err) {
    return errors.New("missing npmrc file")
  }
  npm = npm.WithMountedSecret("/root/.npmrc", npmrcFile)
}
```

{{< /admonition >}}

{{< admonition type="example" title="Building a Go App with Caching" open=false >}}

Using Mage and the excellent chainguard go builder image, this shows building a binary for the current platform and architecture, while wrapping up the entire build process inside the Dagger engine.
The output goes to the standard `.artifacts` directory I include in all my projects, which should be ignored by git.

```go
package main

import (
  "context"
  "os"
  "path/filepath"
  "runtime"

  "dagger.io/dagger"
  "github.com/magefile/mage/mg"
  "github.com/pterm/pterm"
)

// Build contains all the build related mage targets.
type Build mg.Namespace


const (
  // ArtifactDirectory is a directory containing artifacts for the project and shouldn't be committed to source.
  ArtifactDirectory = ".artifacts"

  // PermissionUserReadWriteExecute is the permissions for the artifact directory.
  PermissionUserReadWriteExecute = 0o0700


)
// TargetBuildDirectory is the directory where the build artifacts will be placed.
var TargetBuildDirectory = filepath.Join(ArtifactDirectory, "builds")


// 🔨 MyAppName builds the service using Dagger for the current system architecture.
//
// Development notes: This is a fully containerized build, using Dagger. Requires Docker.
func (Build) MyAppName() error {

  ctx := context.Background()
  pterm.DefaultHeader.Println("Building with Dagger")

  buildThis := "./myApp/main.go" // this is the specific file to build, could be an input variable/slice though
  appName := "myApp"
  // make the target directory
  if err := os.MkdirAll(filepath.Join(TargetBuildDirectory, appName), PermissionUserReadWriteExecute); err != nil {
    return err
  }
  // initialize Dagger client
  client, err := dagger.Connect(ctx, dagger.WithLogOutput(os.Stdout))
  if err != nil {
    return err
  }
  defer client.Close()

  // get reference to the local project
  src := client.Host().Directory(".")
  cachedBuild := client.CacheVolume("go-build-cache")
  cachedMod := client.CacheVolume("go-mod-cache")

  modcache := "/nonroot/.cache/go-mod-cache"
  buildcache := "/nonroot/.cache/go-build-cache"

  // get `golang` image
  golang := client.Container().From("cgr.dev/chainguard/go:latest").
    WithEnvVariable("CGO_ENABLED", "0").
    WithEnvVariable("GOOS", runtime.GOOS).
    WithEnvVariable("GOARCH", runtime.GOARCH).
    WithEnvVariable("GOMODCACHE", modcache). // attempt to optimize mod and build caching
    WithEnvVariable("GOCACHE", buildcache)

  // mount cloned repository into `golang` image
  golang = golang.WithMountedDirectory("/src", src).
    WithWorkdir("/src").
    WithMountedCache(modcache, cachedMod).
    WithMountedCache(buildcache, cachedBuild)

  // define the application build command
  outputDirectory := filepath.Join(TargetBuildDirectory, appName)
  outputFile := filepath.Join(outputDirectory, fmt.Sprintf("%s-service",appName))
  golang = golang.WithExec([]string{"build", "-o", outputFile, "-ldflags", "-s -w", "-trimpath", buildThis}) // NOTE: target is preset for now

  // get reference to build output directory in container
  output := golang.Directory(outputDirectory).File(fmt.Sprintf("%s-service",appName)) // this is the specific  file rather than a mounted directory as we just want this one artifact

  // write contents of container build/ directory to the host
  _, err = output.Export(ctx, outputFile)
  if err != nil {
    return err
  }

  return nil
}

```

{{< /admonition >}}
