# Go R1 Day 31


## progress

- Learned a bit about idiomatic patterns wtih error handling.
- Learned about inline block intiailization of variables using `if err := method(); err != nil {...}` approach.
- Considered a bit more idiomatic patterns when I noticed excessibe nested if blocks.

```go
tfdir := tf.Params().String(&#34;tfdir&#34;)
if tfdir != &#34;&#34; {
  tf.Logf(&#34;tfdir set to: [%s]&#34;, tfdir)
} else {
  tf.Errorf(&#34;🧪 failed to get tfdir parameter: [%v]&#34;, tfdir)
}
```

This would probably be more in alignment with Go standards by writing as:

```go
tfdir := tf.Params().String(&#34;tfdir&#34;)
if tfdir == &#34;&#34; {
  tf.Errorf(&#34;🧪 failed to get tfdir parameter: [%v]&#34;, tfdir)
  return
}
tf.Logf(&#34;tfdir set to: [%s]&#34;, tfdir)
```

This reduces the noise and keeps things pretty flat.

## links

[When Should I Use One Liner if...else Statements in Go?](https://www.calhoun.io/one-liner-if-statements-with-errors/))

