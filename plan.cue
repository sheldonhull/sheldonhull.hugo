package main
import (
    "dagger.io/dagger"
  	"dagger.io/dagger/core"

    "universe.dagger.io/docker"
    "universe.dagger.io/yarn"

    "alpha.dagger.io/os"
)

// Build the source code using Yarn
app: yarn.#Package & {
    source: dagger.#Artifact & dagger.#Input
}

// package the static HTML from yarn into a Docker image
image: os.#Container & {
    image: docker.#Pull & {
        from: "nginx"
    }

    // app.build references our app key above
    // which infers a dependency that Dagger
    // uses to generate the DAG
    copy: "/usr/share/nginx/html": from: app.build
}

// push the image to a registry
push: docker.#Push & {
    // leave target blank here so that different
    // environments can push to different registries
    target: string

    // the source of our push resource
    // is the image resource we declared above
    source: image
}