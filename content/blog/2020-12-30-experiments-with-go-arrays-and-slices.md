---
date: 2020-12-30T21:44:34Z
title: Experiments With Go Arrays and Slices
slug: experiments-with-go-arrays-and-slices
excerpt:
  Some ramblings as I worked through working with arrays and slices with Go
tags:
  - powershell
  - tech
  - golang
  - development
toc: true
---

## Simplicity Over Syntactic Sugar

As I've been learning Go, I've grown to learn that many decisions to simplify the language have removed many features that provide more succinct expressions in languages such as Python, PowerShell, C#, and others.
The non-orthogonal features in the languages result in many expressive ways something can be done, but at a cost, according to Go's paradigm.

My background is also heavily focused in relational databases and set based work, so I'm realizing as I study more programming paradigms seperate from any database involvement, that it's a fundamental difference in the way a database developer and a normal developer writing backend code look at this.
Rather than declarative based syntax, you need to focus a lot more on iterating through collections and manipulating these.

As I explored my assumptions, I found that even in .NET Linq expressions are abstracting the same basic concept of loops and iterations away for simpler syntax, but not fundamentally doing true set selections.
In fact, in some cases I've read that Linq performance is often worse than a simple loop (see this interesting [stack overflow answer](https://stackoverflow.com/q/3156059/68698))
The catch to this is that the Linq expression might be more maintainable in an enterprise environment at the cost of some degraded performance (excluding some scenarios like deferred execution).

For example, in PowerShell, you can work with arrays in a multitude of ways.

```powershell
$array[4..10] | ForEach-Object {}
# or
foreach($item in $array[$start..$end]){}
```

This syntactic sugar provides brevity, but as two ways among many I can think of this does add such a variety of ways and performance considerations.
Go strips this cognitive load away by giving only a few ways to do the same thing.

## Using For Loop

This example is just int slices, but I'm trying to understand the options as I `range` through a struct as well.

When working through these examples for this question, I discovered thanks to the [Rubber Duck debugging](https://rubberduckdebugging.com), that you can simplify slice selection using `newSlice := arr[2:5]`.

### Simple Loop

As an example: [Goplay Link To Run](https://goplay.tools/snippet/w6mGwJyz2C2)

```go
package main
import "fmt"

func main() {
	startIndex := 2
	itemsToSelect := 3
	arr := []int{10, 15, 20, 25, 35, 45, 50}
	fmt.Printf("starting: arr: %v\n", arr)

	newCollection := []int{}
	fmt.Printf("initialized newCollection: %v\n", newCollection)
	for i := 0; i < itemsToSelect; i++ {
		newCollection = append(newCollection, arr[i+startIndex])
		fmt.Printf("\tnewCollection: %v\n", newCollection)
	}
	fmt.Printf("= newCollection: %v\n", newCollection)
	fmt.Print("expected: 20, 25, 35\n")
}```

This would result in:

```text
starting: arr: [10 15 20 25 35 45 50]
initialized newCollection: []
	newCollection: [20]
	newCollection: [20 25]
	newCollection: [20 25 35]
= newCollection: [20 25 35]
expected: 20, 25, 35
```

### Moving Loop to a Function

Assuming there are no more effective selection libraries in Go, I'm assuming I'd write functions for this behavior such as [Goplay Link To Run](https://goplay.tools/snippet/BzQkSif0Vs_s).

```go
package main

import "fmt"

func main() {
	startIndex := 2
	itemsToSelect := 3
	arr := []int{10, 15, 20, 25, 35, 45, 50}
	fmt.Printf("starting: arr: %v\n", arr)
	newCollection := GetSubselection(arr, startIndex, itemsToSelect)
	fmt.Printf("GetSubselection returned: %v\n", newCollection)
	fmt.Print("expected: 20, 25, 35\n")
}

func GetSubselection(arr []int, startIndex int, itemsToSelect int) (newSlice []int) {
	fmt.Printf("newSlice: %v\n", newSlice)
	for i := 0; i < itemsToSelect; i++ {
		newSlice = append(newSlice, arr[i+startIndex])
		fmt.Printf("\tnewSlice: %v\n", newSlice)
	}
	fmt.Printf("= newSlice: %v\n", newSlice)
	return newSlice
}
```

which results in:

```text
starting: arr: [10 15 20 25 35 45 50]
newSlice: []
	newSlice: [20]
	newSlice: [20 25]
	newSlice: [20 25 35]
= newSlice: [20 25 35]
GetSubselection returned: [20 25 35]
expected: 20, 25, 35
```

Trimming this down further I found I could use the slice syntax (assuming the consecutive range of values) such as:
[Goplay Link To Run](https://goplay.tools/snippet/y2GJXcO3uLZ)

```
func GetSubselection(arr []int, startIndex int, itemsToSelect int) (newSlice []int) {
	fmt.Printf("newSlice: %v\n", newSlice)
	newSlice = arr[startIndex:(startIndex + itemsToSelect)]
	fmt.Printf("\tnewSlice: %v\n", newSlice)
	fmt.Printf("= newSlice: %v\n", newSlice)
	return newSlice
}
```

### Range

The `range` expression gives you both the index and value, and it works for maps and structs as well.

Turns outs you can also work with a subselection of a slice in the `range` expression.

```go
package main

import "fmt"

func main() {
	startIndex := 2
	itemsToSelect := 3
	arr := []int{10, 15, 20, 25, 35, 45, 50}
	fmt.Printf("starting: arr: %v\n", arr)

	fmt.Printf("Use range to iterate through arr[%d:(%d + %d)]\n", startIndex, startIndex, itemsToSelect)
	for i, v := range arr[startIndex:(startIndex + itemsToSelect)] {
		fmt.Printf("\ti: %d v: %d\n", i, v)
	}
	fmt.Print("expected: 20, 25, 35\n")
}
```

## Slices

While the language is simple, understanding some behaviors with slices caught me off-guard.

First, I needed to clarify my language.
Since I was looking to have a subset of an array, slices were the correct choice.
For a fixed set with no changes, a standard array would be used.

[Tour On Go](https://tour.golang.org/moretypes/7) says it well with:

> An array has a fixed size.
> A slice, on the other hand, is a dynamically-sized, flexible view into the elements of an array.
> In practice, slices are much more common than arrays.

For instance, I tried to think of what I would do to scale performance on a larger array, so I used a pointer to my int array.
However, I was using a `slice`.

This means that using a pointer wasn't valid.
This is because whenever I pass the slice it is a pass by reference already, unlike many of the other types.

```go
newCollection := GetSubSelection(&arr,2,3)

func GetSubSelection(arr *[]int){ ...
```

I think some of these behaviors aren't quite intuitive to a new Gopher, but writing them out helped clarify the behavior a little more.

## Resources

This is a bit of a rambling about what I learned so I could solidify some of these discoveries by writing them down. #learninpublic

For some great examples, look at some examples in:

- [A Tour Of Go - Slices](https://tour.golang.org/moretypes/7)
- [Go By Example](https://gobyexample.com/slices)
- [Prettyslice GitHub Repo](https://github.com/inancgumus/prettyslice)

If you have any insights, feel free to drop a comment here (it's just a GitHub powered comment system, no new account required).
