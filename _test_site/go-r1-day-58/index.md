# Go R1 Day 58


## progress

- Avoiding a panic in Go for missing dictionary match is very straight forward.
  The error pattern for failed conversions and out of range index matches is the same, with: `ok, err := action`.
- TODO: Figure out if ok to reference an error in a test by: `is.Equal(error.Error(),&#34;unable to find value in map&#34;)`.
Linter warns me with: `Method call &#39;err.Error()&#39; might lead to a nil pointer dereference`.
- Started work with dependency injection.

## links

- [Maps](https://quii.gitbook.io/learn-go-with-tests/go-fundamentals/maps)
- [tests: 🧪 007-maps · sheldonhull/learn-go-with-tests-applied@11cf197 · GitHub](https://github.com/sheldonhull/learn-go-with-tests-applied/commit/11cf19791b366df58456bde19466f42ebeac05af)
- [Dependency Injection](https://quii.gitbook.io/learn-go-with-tests/go-fundamentals/dependency-injection)
- [tests: 🧪 009-dependency-injection · sheldonhull/learn-go-with-tests-applied@33a17c3 · GitHub](https://github.com/sheldonhull/learn-go-with-tests-applied/commit/33a17c3174307681d14b3776ef66d77d1b4a8778)

