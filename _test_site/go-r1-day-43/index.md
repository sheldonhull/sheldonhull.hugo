# Go R1 Day 43


## progress

- Modified forked SharedBrain repo to use `yaml` parser instead of toml.
- Modified tests handle invalid casting of interface, which was causing a panic.

```go
otherDate, ok := otherDateInt.(time.Time)
if !ok {
  log.Printf(&#34;[time.Parse] probable invalid date format %s&#34;, plainFilename)
}
```

- Improved tests to align to markdown standard formatting.
- FOSS license scanned on 4 repos to test compliance of licensing for badge.
- Use goyek templates to build out initial go based build actions.

## links

- [GitHub - sheldonhull/goyek-tasks: Goyek pre-built tasks for CI/CD work](https://github.com/sheldonhull/goyek-tasks)
- [GitHub - sheldonhull/sharedbrain](https://github.com/sheldonhull/sharedbrain)
- [GitHub - dangoor/sharedbrain](https://github.com/dangoor/sharedbrain)

