# Go R1 Day 68


## progress

- Did exercism.io for gigasecond puzzle.

```go
package gigasecond

// import path for the time package from the standard library
import (
	&#34;time&#34;
)

// gigasecond represents a very very very small portion of a second.
const gigasecond = 1000000000

// AddGigasecond adds a very very very small portion of a second called a gigasecond to a provided time input.
func AddGigasecond(t time.Time) time.Time {
	gcDuration := gigasecond * time.Second
	n := t.Add(gcDuration)
	return n
}

```

- Learned a bit more about using `Math.Pow()`, conversion of floats/ints, and dealing with time.Duration.
- Tried using `Math.Pow()` to work through the issue, but got mixed up when using `time.Duration()` which expects nanoseconds, and such.
Went ahead and just used a constant for the exercise as not likely to use gigaseconds anytime soon. 😀

## links

- [Gigasecond Solution](https://exercism.io/my/solutions/1731a96e6e5345129e2fb181f6f44821)
- [refactor: 🚚 move directories to support exercism cli · sheldonhull/algorithmswithgo.com@8890e57 · GitHub](https://github.com/sheldonhull/algorithmswithgo.com/commit/8890e576b13c5e063fe70da2a42a8826be222850)
- [feat: 🎉 submitted gigasecond solution · sheldonhull/algorithmswithgo.com@bbe62da · GitHub](https://github.com/sheldonhull/algorithmswithgo.com/commit/bbe62da3a721c935ff7cb79327d4cc158bc60e71)

