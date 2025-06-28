# Go R1 Day 60


## progress

- Finished up the basics of dependency injection and how this helps with testable code.
- Worked through concurrency test using channels and go routines.
This will take a bit more to get comfortable with as there is a variety of concepts here.
My initial attempts finally started working using an anonymous function, but couldn&#39;t finalize due to some issue with launching the parallel executable being called.
Not sure why the `--argname` seemed to be trimming the first dash from the argument when using `args = append(args,&#34;--argname 5&#34;)`.

I sure enjoy the visuals from pterm library.
When not using the `-debug` flag, the concurrent counter reported a nice increase of total threads and then exited upon failure of any goroutine.

