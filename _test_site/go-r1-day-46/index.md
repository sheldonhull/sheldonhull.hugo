# Go R1 Day 46


## progress

- At `$work` I focused on dockertest.
- Modified the provided test statements to ensure autoremoval of container occurred on failure.
- Had packet issues I couldn&#39;t figure out this time, so shelved for now. `packets.go:37: unexpected eof`
- At home, I played with bubbleteam a bit, and decided while an epic TUI interface, the framework is far too involved for what I want to mess around with at this time.
For instance, it doesn&#39;t provide multi-select, instead much of that is manually written, requiring a lot of effort.
I&#39;ll look at another framework or `go-prompt` again, and just use something that provides selections out of the box.
- Further refined some goyek build statements, running docker compose multi-file based merging of docker-compose files enabled.

## links

- [charmbracelet/bubbletea](https://github.com/charmbracelet/bubbletea)
- [ory/dockertest](https://github.com/ory/dockertest)

