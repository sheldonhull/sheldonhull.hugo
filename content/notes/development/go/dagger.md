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

I will soon put some experience notes here, as I've successfully built Angular and Nginx containers with it, which was a great experience.
With the upcoming service support, I can foresee even more use cases.

{{< admonition type="example" title="Example of Building an Angular Project" open=false >}}
Using mage, here's a demonstration of invoking Mage to build an Angular project without any Angular tooling installed locally.

```go
const AngularVersion = "15"

// Build runs the Angular build via Dagger.
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

{{< admonition type="example" title="Example of handling both local and CI private npm auth" open=false >}}

This demonstrates how to handle both running in a CI context and a remote context by evaluating for a CI variable. If provided, this will return a CI system-generated `.npmrc`.
If not provided, the file from the home directory will be mounted into the build container.

Please note that this container is not for publishing; it's a build container which copies the `dist/` contents back to the project directory.

```go
npmrcFile := &dagger.Secret{}

// Bypass any mounting of npmrc, as CI tooling should update any private inline with current file here
if os.Getenv("NPM_CONFIG_USERCONFIG") != "" {
  pterm.Info.Printfln("[OVERRIDE] NPM_CONFIG_USERCONFIG: %s", os.Getenv("NPM_CONFIG_USERCONFIG"))
  npmrcDir := filepath.Dir(os.Getenv("NPM_CONFIG_USERCONFIG"))
} else {
  // [DEFAULT] NPM config set from home/.npmrc
  npmrcFile = client.Host().Directory(homedir, dagger.HostDirectoryOpts{Include: []string{".npmrc"}}).File(".npmrc").Secret()

  // Output error if npmrcFile doesn't exist
  if _, err := os.Stat(filepath.Join(homedir, ".npmrc")); os.IsNotExist(err) {
    return errors.New("missing npmrc file")
  }
  npm = npm.WithMountedSecret("/root/.npmrc", npmrcFile)
}
```

{{< /admonition >}}

{{< admonition type="example" title="Building a Go App with Caching" open=false >}}

Using Mage and the excellent Chainguard Go builder image, this example shows how to build a binary for the current platform and architecture, while wrapping up the entire build process inside the Dagger engine.
The output goes to the standard `.artifacts` directory, which is typically included in all projects, and should be ignored by Git.

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

type Build mg.Namespace  // Build contains all the build-related Mage targets.


const (
  ArtifactDirectory = ".artifacts"  // ArtifactDirectory is a directory for project artifacts, and shouldn't be committed to source.
  PermissionUserReadWriteExecute = 0o0700  // PermissionUserReadWriteExecute is the permissions for the artifact directory.
)

var TargetBuildDirectory = filepath.Join(ArtifactDirectory, "builds")  // TargetBuildDirectory is the directory where the build artifacts will be placed.

// 🔨 MyAppName builds the service using Dagger for the current system architecture.
//
// Development notes: This is a fully containerized build, using Dagger. Requires Docker.
func (Build) MyAppName() error {

  ctx := context.Background()
  pterm.DefaultHeader.Println("Building with Dagger")

  buildThis := "./myApp/main.go" // This is the specific file to build, could be an input variable/slice though
  appName := "myApp"
  // create the target directory
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
    WithEnvVariable("GOMODCACHE", modcache). // Attempt to optimize mod and build caching
    WithEnvVariable("GOCACHE", buildcache)

  // mount cloned repository into `golang` image
  golang = golang.WithMountedDirectory("/src", src).
    WithWorkdir("/src").
    WithMountedCache(modcache, cachedMod).
    WithMountedCache(buildcache, cachedBuild)

  // define the application build command
  outputDirectory := filepath.Join(TargetBuildDirectory, appName)
  outputFile := filepath.Join(outputDirectory, fmt.Sprintf("%s-service",appName))
  golang = golang.WithExec([]string{"build", "-o", outputFile, "-ldflags", "-s -w", "-trimpath", buildThis})

  // get reference to build output directory in container
  output := golang.Directory(outputDirectory).File(fmt.Sprintf("%s-service",appName))

  // write contents of container build/ directory to the host
  _, err = output.Export(ctx, outputFile)
  if err != nil {
    return err
  }

  return nil
}

```

{{< /admonition >}}
