package main

import (
	"context"
	"dagger.io/dagger"
)

type Site struct{}

// dag is the global Dagger client, initialized by the Dagger runtime
var dag *dagger.Client

func main() {
	// This main function is for build verification only
	// Dagger handles the actual execution
}

// Build the site using Quartz
func (m *Site) Build(
	ctx context.Context,
	// +optional
	// +default="."
	source *dagger.Directory,
) *dagger.Directory {
	return dag.Container().
		From("node:22").
		WithWorkdir("/app").
		WithDirectory("/app", source).
		WithExec([]string{"npm", "ci"}).
		WithExec([]string{"npx", "quartz", "build", "--directory", "content"}).
		Directory("/app/public")
}

// Serve the site for preview using Quartz
func (m *Site) Serve(
	ctx context.Context,
	// +optional
	// +default="."
	source *dagger.Directory,
) *dagger.Service {
	return dag.Container().
		From("node:22").
		WithWorkdir("/app").
		WithDirectory("/app", source).
		WithExec([]string{"npm", "ci"}).
		WithExec([]string{"npx", "quartz", "build", "--serve", "--directory", "content"}).
		WithExposedPort(8080).
		AsService()
}

// Check the code (TypeScript and formatting)
func (m *Site) Check(
	ctx context.Context,
	// +optional
	// +default="."
	source *dagger.Directory,
) *dagger.Container {
	return dag.Container().
		From("node:22").
		WithWorkdir("/app").
		WithDirectory("/app", source).
		WithExec([]string{"npm", "ci"}).
		WithExec([]string{"tsc", "--noEmit"}).
		WithExec([]string{"npx", "prettier", ".", "--check"})
}

// Format the code using Prettier
func (m *Site) Format(
	ctx context.Context,
	// +optional
	// +default="."
	source *dagger.Directory,
) *dagger.Directory {
	return dag.Container().
		From("node:22").
		WithWorkdir("/app").
		WithDirectory("/app", source).
		WithExec([]string{"npm", "ci"}).
		WithExec([]string{"npx", "prettier", ".", "--write"}).
		Directory("/app")
}