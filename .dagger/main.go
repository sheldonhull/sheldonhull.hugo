package main

import (
	"context"
)

type Site struct{}

// Build the site using Quartz
func (m *Site) Build(
	ctx context.Context,
	// +optional
	// +default="."
	source *Directory,
) *Directory {
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
	source *Directory,
) *Service {
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
	source *Directory,
) *Container {
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
	source *Directory,
) *Directory {
	return dag.Container().
		From("node:22").
		WithWorkdir("/app").
		WithDirectory("/app", source).
		WithExec([]string{"npm", "ci"}).
		WithExec([]string{"npx", "prettier", ".", "--write"}).
		Directory("/app")
}