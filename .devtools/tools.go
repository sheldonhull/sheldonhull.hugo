//nolint
//go:build tools
// +build tools

package tools

// Manage tool dependencies via go.mod.
//
// https://github.com/golang/go/wiki/Modules#how-can-i-track-tool-dependencies-for-a-module
// https://github.com/golang/go/issues/25922
import (
	_ "github.com/client9/misspell/cmd/misspell"
	_ "github.com/gechr/yamlfmt"
	_ "github.com/gobeam/stringy"
	_ "github.com/magefile/mage/mg"
	_ "github.com/magefile/mage/sh"
	_ "github.com/pterm/pterm"
	_ "github.com/sheldonhull/magetools/gittools"
	_ "github.com/sheldonhull/magetools/gotools"
	// _ "github.com/sunt-programator/CodeIT"
	// _ "github.com/dnb-org/debug"
)