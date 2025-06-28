# Go R1 Day 84


## progress

Ultimate Syntax (Ardan Labs - Bill Kennedy) and went back through various topics such as:

- Pointers: One thing mentioned that resonated with me was the confusion regarding pointers in parameter declarations.
I also find the usage strange that the deference operator is used to denote a pointer value being dereferences in the parameter.
I&#39;d expect a pointer value to pass clearly with `func (mypointer &amp;int)` and not `func (mypointer int)` with a pointer call.
- Literal Structs: Great points on avoiding &#34;type exhaustion&#34; by using literal structs whenever the struct is not reused in multiple locations.
- Constants: Knowing that there is a parallel typing system for constants with &#34;kind&#34; vs &#34;type&#34; being significant helped me wrap my head around why constants often don&#39;t have explicit type definitions in their declaration.

### Iota

This is one of the most confusing types I&#39;ve used.

- Iota only works in a block declaration.

```go
const (
  a = iota &#43; 1  // Starts at 0
  b             // Starts at 1
  c             // Starts at 2
)
```

Also showed using `&lt;&lt; iota` to do bit shifting.
This is common in log packages (I&#39;ll have to look in the future, as bit shifting is something I&#39;ve never really done).

Become of kind system, you can&#39;t really make enumerators with constants.

## Best Practices

Don&#39;t use aliases for types like `type handle int` in an effort.
While it seems promising, it doesn&#39;t offer the protection thought, because of &#34;kind&#34; protection.

This is because &#34;kind promotion&#34;, it destroys the ability to truly have enumerations in Go by aliasing types.

I&#39;ve seen `stringer` used in some articles as well, but not certain yet if it&#39;s considered idiomatic to approach enum like generation this way.

