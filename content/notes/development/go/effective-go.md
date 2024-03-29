---
title: Effective Go
---

## Top Reference Material

Here's the reference material I use to help guide me on basic style, design, and general idiomatic Go practices.

| Resource                                                                                                            | Description                                                                 |
| ------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------- |
| [Go Style Guide](https://golang.org/doc/style.html)                                                                 | A guide to writing Go code.                                                 |
| [Uber Go Styleguide](https://github.com/uber-go/guide/blob/master/style.md)                                         | A thorough stylistic guide (opinionated, but great explanations on why)     |
| [Practical Go - Dave Cheney](https://dave.cheney.net/practical-go/presentations/qcon-china.html#_identifier_length) | A great practical guide from a well-respected authority in the Go community |

## Effective Go

Principles I've gleaned over time and am quoting or bookmarking.

### Don't hide the cost

> Source: Bill Kennedy in Ultimate Go [^readability]

If we are doing construction on a variable, we use value construction.
Avoid pointer semantic construction if it's not being returned.

Example:

```go
// Clearly visible cost of the allocation by value construction and passing of pointer back up the call stack
func createSomething() *something {
  u := something{
    name: "example",
  }
  return &u // <-- This makes clear the cost and allocation back up the callstack.
}
// The cost is obscured by construction being a pointer
// and returning a value that is not clear to the reader if it's a value or pointer
func createSomething() *something {
  u := &something{
    name: "example",
  }
  return u // <-- Not good. Hides the cost, and requires reading the function further to find out that this is a pointer.
}
```

Making the cost obvious and visible is a high priority for creating readable, maintainable code in a team context.
