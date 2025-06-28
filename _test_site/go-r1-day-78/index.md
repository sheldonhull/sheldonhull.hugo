# Go R1 Day 78


## progress

### Ultimate Go: 2.3.4 - Pointers-Part 4 (Stack Growth)

Scenario:

- 2k stack for each goroutine.
- 50,000 goroutines.
- Eventually, you&#39;ll want to make the function call and you&#39;ll want to grow the stack if the current stack limit is hit.
- We&#39;ll want to use contigous stacks.
- The new stack will be a new contigous allocated block of memory.
- The stack growth requires all the prior values to be moved over to the new doubled stack.

A goroutine can only share values from the heap.
This prevents the issues occuring from shared values in different stacks.

### Ultimate Go: 2.3.5 - Pointers-Part 5 (GC)

Mark and sweep collector.

We don&#39;t need to worry about the implementation.

However, this topic is useful to ensure we write code that is &#34;sympathetic&#34; to the GC.

At this point, I opted to come back to GC details and focus on some testing and package design principles.

