# Go R1 Day 10


## Day 10 of 100

## progress

- Experimented with CLI tool using go-prompt
- Customized initial options
- OS independent call to get user home directory.
- Iterated through a directory listing
- Used path join to initialize path for directory search.
- One challenge in working with structs being returned was figuring out how to print the values of the struct.
Initially, I only had pointers to the values coming back.
This made sense, though, as I watched a tutorial this weekend on slices, and better understand that a slice is actually a small data structure being described by: pointer to the location in memory, length, and the capacity of the slice.
Without this tutorial, I think seeing the pointer addresses coming through would have been pretty confusing.
- In reading StackOverflow, I realized it&#39;s a &#34;slice of interfaces&#34;.
- Worked with apex logger and moved some of the log output to debug level logging.
- Final result

{{&lt; asciinema id=&#34;uAGRQLD2Tuj3NVgDePMGqVnT1&#34; &gt;}}

## links

- [apex-log](https://github.com/apex/log)
- [prettyslice](https://github.com/inancgumus/prettyslice)
- [go-prompt](https://github.com/c-bata/go-prompt)

## source

{{&lt; gist sheldonhull  &#34;709b7cf02c40863c3c845de9b4fb6d5a&#34; &gt;}}

