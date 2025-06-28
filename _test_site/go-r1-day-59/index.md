# Go R1 Day 59


## progress

- Built some Mage tasks for setup of local projects.
- Used retool post from Nate Finch with Mage project and found it promising to vendor Go based tooling into a local project and not rely on the global package library.
- Created `magetools` repo to house some basic general mage tasks I could share with other projects.

```go
year, month, day := time.Now().Date()
dateString := fmt.Sprintf(&#34;%d-%02d-%d&#34;, year, month, day)
```

Use padding in the `Sprintf` call to ensure a date comes back with `07` instead of `7`.

## links

- [Retooling Retool &amp;middot; npf.io](https://npf.io/2019/05/retooling-retool/)
- [GitHub - sheldonhull/magetools: General tooling helpers for simplifying cross repository automation using Mage](https://github.com/sheldonhull/magetools)

