# Dagger


[Containerized magic with Go and BuildKit](https://dagger.io?ref=sheldonhull.com)

I will soon put some experience notes here, as I&#39;ve successfully built Angular and Nginx containers with it, which was a great experience.
With the upcoming service support, I can foresee even more use cases.

{{&lt; admonition type=&#34;example&#34; title=&#34;Example of Building an Angular Project&#34; open=false &gt;}}
Using mage, here&#39;s a demonstration of invoking Mage to build an Angular project without any Angular tooling installed locally.

```go
const AngularVersion = &#34;15&#34;

// Build runs the Angular build via Dagger.
func (Dagger) Build(ctx context.Context) error {
  client, err := dagger.Connect(ctx, dagger.WithLogOutput(os.Stdout))
  if err != nil {
    pterm.Error.Printfln(&#34;unable to connect to dagger: %s&#34;, err)
    return err
  }
  defer client.Close()

  homedir, err := os.UserHomeDir()
  if err != nil {
    return err
  }
  npm := client.Container().From(&#34;node:lts-alpine&#34;)
  npm = npm.WithMountedDirectory(&#34;/src&#34;, client.Host().Directory(&#34;.&#34;)).
    WithWorkdir(&#34;/src&#34;)

  path := &#34;dist/&#34;
  npm = npm.WithExec([]string{&#34;npm&#34;, &#34;install&#34;, &#34;-g&#34;, fmt.Sprintf(&#34;@angular/cli@%s&#34;, AngularVersion)})
  npm = npm.WithExec([]string{&#34;ng&#34;, &#34;config&#34;, &#34;-g&#34;, &#34;cli.warnings.versionMismatch&#34;, &#34;false&#34;})
  npm = npm.WithExec([]string{&#34;ng&#34;, &#34;v&#34;})
  npm = npm.WithExec([]string{&#34;npm&#34;, &#34;ci&#34;})
  npm = npm.WithExec([]string{&#34;ng&#34;, &#34;build&#34;, &#34;--configuration&#34;, &#34;production&#34;})

  // Copy &#34;dist/&#34; from container to host.
  _, err = npm.Directory(path).Export(ctx, path)
  if err != nil {
    return err
  }
  return nil
}
```

{{&lt; /admonition &gt;}}

{{&lt; admonition type=&#34;example&#34; title=&#34;Example of handling both local and CI private npm auth&#34; open=false &gt;}}

This demonstrates how to handle both running in a CI context and a remote context by evaluating for a CI variable. If provided, this will return a CI system-generated `.npmrc`.
If not provided, the file from the home directory will be mounted into the build container.

Please note that this container is not for publishing; it&#39;s a build container which copies the `dist/` contents back to the project directory.

```go
npmrcFile := &amp;dagger.Secret{}

// Bypass any mounting of npmrc, as CI tooling should update any private inline with current file here
if os.Getenv(&#34;NPM_CONFIG_USERCONFIG&#34;) != &#34;&#34; {
  pterm.Info.Printfln(&#34;[OVERRIDE] NPM_CONFIG_USERCONFIG: %s&#34;, os.Getenv(&#34;NPM_CONFIG_USERCONFIG&#34;))
  npmrcDir := filepath.Dir(os.Getenv(&#34;NPM_CONFIG_USERCONFIG&#34;))
} else {
  // [DEFAULT] NPM config set from home/.npmrc
  npmrcFile = client.Host().Directory(homedir, dagger.HostDirectoryOpts{Include: []string{&#34;.npmrc&#34;}}).File(&#34;.npmrc&#34;).Secret()

  // Output error if npmrcFile doesn&#39;t exist
  if _, err := os.Stat(filepath.Join(homedir, &#34;.npmrc&#34;)); os.IsNotExist(err) {
    return errors.New(&#34;missing npmrc file&#34;)
  }
  npm = npm.WithMountedSecret(&#34;/root/.npmrc&#34;, npmrcFile)
}
```

{{&lt; /admonition &gt;}}

{{&lt; admonition type=&#34;example&#34; title=&#34;Building a Go App with Caching&#34; open=false &gt;}}

Using Mage and the excellent Chainguard Go builder image, this example shows how to build a binary for the current platform and architecture, while wrapping up the entire build process inside the Dagger engine.
The output goes to the standard `.artifacts` directory, which is typically included in all projects, and should be ignored by Git.

```go
package main

import (
  &#34;context&#34;
  &#34;os&#34;
  &#34;path/filepath&#34;
  &#34;runtime&#34;

  &#34;dagger.io/dagger&#34;
  &#34;github.com/magefile/mage/mg&#34;
  &#34;github.com/pterm/pterm&#34;
)

type Build mg.Namespace  // Build contains all the build-related Mage targets.


const (
  ArtifactDirectory = &#34;.artifacts&#34;  // ArtifactDirectory is a directory for project artifacts, and shouldn&#39;t be committed to source.
  PermissionUserReadWriteExecute = 0o0700  // PermissionUserReadWriteExecute is the permissions for the artifact directory.
)

var TargetBuildDirectory = filepath.Join(ArtifactDirectory, &#34;builds&#34;)  // TargetBuildDirectory is the directory where the build artifacts will be placed.

// 🔨 MyAppName builds the service using Dagger for the current system architecture.
//
// Development notes: This is a fully containerized build, using Dagger. Requires Docker.
func (Build) MyAppName() error {

  ctx := context.Background()
  pterm.DefaultHeader.Println(&#34;Building with Dagger&#34;)

  buildThis := &#34;./myApp/main.go&#34; // This is the specific file to build, could be an input variable/slice though
  appName := &#34;myApp&#34;
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
  src := client.Host().Directory(&#34;.&#34;)
  cachedBuild := client.CacheVolume(&#34;go-build-cache&#34;)
  cachedMod := client.CacheVolume(&#34;go-mod-cache&#34;)

  modcache := &#34;/nonroot/.cache/go-mod-cache&#34;
  buildcache := &#34;/nonroot/.cache/go-build-cache&#34;

  // get `golang` image
  golang := client.Container().From(&#34;cgr.dev/chainguard/go:latest&#34;).
    WithEnvVariable(&#34;CGO_ENABLED&#34;, &#34;0&#34;).
    WithEnvVariable(&#34;GOOS&#34;, runtime.GOOS).
    WithEnvVariable(&#34;GOARCH&#34;, runtime.GOARCH).
    WithEnvVariable(&#34;GOMODCACHE&#34;, modcache). // Attempt to optimize mod and build caching
    WithEnvVariable(&#34;GOCACHE&#34;, buildcache)

  // mount cloned repository into `golang` image
  golang = golang.WithMountedDirectory(&#34;/src&#34;, src).
    WithWorkdir(&#34;/src&#34;).
    WithMountedCache(modcache, cachedMod).
    WithMountedCache(buildcache, cachedBuild)

  // define the application build command
  outputDirectory := filepath.Join(TargetBuildDirectory, appName)
  outputFile := filepath.Join(outputDirectory, fmt.Sprintf(&#34;%s-service&#34;,appName))
  golang = golang.WithExec([]string{&#34;build&#34;, &#34;-o&#34;, outputFile, &#34;-ldflags&#34;, &#34;-s -w&#34;, &#34;-trimpath&#34;, buildThis})

  // get reference to build output directory in container
  output := golang.Directory(outputDirectory).File(fmt.Sprintf(&#34;%s-service&#34;,appName))

  // write contents of container build/ directory to the host
  _, err = output.Export(ctx, outputFile)
  if err != nil {
    return err
  }

  return nil
}

```

{{&lt; /admonition &gt;}}

