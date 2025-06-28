# Go R1 Day 28


## progress

- Solved [Hamming Distance] on [exercism.io](exercism.io)
- Simple problem, but reminded me of how to use string split.

```go
diffCount := 0
aString := strings.Split(a, &#34;&#34;)
bString := strings.Split(b, &#34;&#34;)

for i, x := range aString {
  if x != bString[i] {
    diffCount&#43;&#43;
  }
}
```

- Reviewed other solutions, and found my first attempt to split the string wasn&#39;t necessary.
Looks like I can just iterate on the string directly.
I skipped this as it failed the first time.
The error is: `invalid operation: x != b[i] (mismatched types rune and byte)`.

This threw me for a loop initially, as I&#39;m familar with .NET `char` datatype.

&gt; Golang doesn&#39;t have a char data type. It uses byte and rune to represent character values. The byte data type represents ASCII characters and the rune data type represents a more broader set of Unicode characters that are encoded in UTF-8 format. [Go Data Types](https://www.callicoder.com/golang-basic-types-operators-type-conversion/#integer-type-aliases)

Explictly casting the data types solved the error.
This would be flexibly for UTF8 special characters.

```go
for i, x := range a {
  if rune(x) != rune(b[i]) {
    diffCount&#43;&#43;
  }
}
```

With this simple test case, it&#39;s it&#39;s subjective if I&#39;d need `rune` instead of just the plain ascii `byte`, so I finalized my solution with `byte(x)` instead.

```go
for i, x := range a {
  if byte(x) != byte(b[i]) {
    diffCount&#43;&#43;
  }
}
```

## links

- [hamming-solution](https://github.com/sheldonhull/algorithmswithgo.com/tree/master/exercism.io/hamming)

