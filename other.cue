package main

// package main
//
// import (
// 	"dagger.io/dagger/core"
// )
//
// _source: core.#Source & {
// 	path: "cue.mod"
// 	exclude: [
// 		"ci",
// 		"node_modules",
// 		"cmd/dagger/dagger",
// 		"cmd/dagger/dagger-debug",
// 	]
// }



Registry: myrepo: Registration & {
  remote: "github.com/sheldonhull/sheldonhull.hugo"
  ref: "main" // branch, tag, or commit

  // examples using the available short codes
  cases: {
    cue:    { _cue: ["eval", "in.cue"], workdir: "/work/examples/cue" }
    hof:    { _script: "./test.sh", workdir: "/work/examples/hof" }
    goapi:  { _goapi: "go run main.go", workdir: "/work/examples/go" }
    dagger: { _dagger: "run", workdir: "/work/examples/dagger" }
    txtar:  { _testscript: "*.txt", workdir: "/work/examples/txtar" }
    script: {
      workdir: "/work/examples/script"
      _script: """
      #!/usr/bin/env bash
      set -euo pipefail

      echo "a bash script"
      pwd
      ls
      ./run.sh
      """
    }
  }
}