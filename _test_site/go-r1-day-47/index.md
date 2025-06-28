# Go R1 Day 47


## progress

- worked with lefthook to run golang-lint tools and discovered how vast the configuration for this was, simplifying many of the other linting tools that was running seperately.
- created some goyek tasks for bringing up and down docker compose stacks.
- learned that `file.Close()` shouldn&#39;t be used with defer to avoid unsafe file handling operations.

```go
// taskComposeDestroy tears down the docker stack including volumes
// this is using goyek task framework for Make alternative
func taskComposeDestroy() goyek.Task {
  return goyek.Task{
    Name:  &#34;compose-destroy&#34;,
    Usage: &#34;remove stack with prejudice&#34;,
    Action: func(tf *goyek.TF) {
      dcBase := filepath.Join(BuildRoot, &#34;docker&#34;, &#34;docker-compose.myservice.yml&#34;)
      dcMySQL := filepath.Join(BuildRoot, &#34;docker&#34;, &#34;docker-compose.mysql.yml&#34;)
      compose := tf.Cmd(&#34;docker&#34;, &#34;compose&#34;, &#34;-f&#34;, dcBase, &#34;-f&#34;, dcMySQL, &#34;down&#34;, &#34;--volumes&#34;, &#34;--remove-orphans&#34;)
      if err := compose.Run(); err != nil {
        tf.Fatalf(&#34;:heavy_exclamation_mark: docker-compose down failed: [%v]&#34;, err)
      }
      tf.Log(&#34;:white_check_mark: docker-compose ran successfully&#34;)
    },
  }
}
```

