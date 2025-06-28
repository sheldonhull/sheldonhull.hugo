# Using Randomization for Pulumi Kubernetes Resources


## Logical Names

Pulumi requires unique logical names (URN) for tracking the state of resources.
I ran into an issue with this once I expanded to a multi-cluster deployment since Pulumi began erroring on the logical name not being unique.
Let&#39;s say you are defining a service:

```go
_, err = corev1.NewService(
		ctx,
		&#34;myservice&#34;, // 👈👈👈👈 this is the logical name
        &amp;corev1.ServiceArgs{
            ApiVersion: pulumi.String(&#34;v1&#34;),
            Kind:       pulumi.String(&#34;Service&#34;),
            Metadata:	&amp;metav1.ObjectMetaArgs{
                Namespace: pulumi.String(myNamespace),
                Name:      pulumi.String(myAppName), // 👈👈👈👈 This is the physical name
            },
)
```

You can normally omit the `Metadata.Name` and Pulumi will autogenerate this with a randomized suffix for you.
This allows a style of &#34;create before destroy&#34; deployments you don&#39;t get with native kubectl apply style commands.
Things get a little messy here as overriding the logical name requires a normal `String`.

To allow maximum uniqueness, you can concatenate values in the logical name so that it&#39;s unique as you desire, such as `resourcename &#43; cluster` for example.

## Using Random

Having used Terraform&#39;s random provider in the past, and found it incredibly helpful to stop relying on the uniqueness of names that I have to manage, I tried initially to do this with the Pulumi terraform version of random.
It didn&#39;t work out too well.
In the end, I realized this is where just having the power of the language itself makes perfect sense.
I had a pointer from someone in this [github discussion](https://github.com/pulumi/pulumi/discussions/9207#discussioncomment-2372172) about using the `petname` package itself, but I didn&#39;t like that idea as it was a bit unwieldy and not designed for importing as a package.
Trying to use the resource results in a problem as `pulumi.StringOutput` can&#39;t be used with string concantenation.
Instead, you have to use the `ApplyT` and pass around the string output to other inputs accepting `pulumi.StringPtr` type.

```go
petname.ID().ApplyT(func(id pulumi.ID) string {
				return fmt.Sprintf(&#34;%v&#34;, id)
}).(pulumi.StringOutput)
```

This doesn&#39;t work because the output is still a `pulumi.StringOutput` and not a `string`.

This would work for things like the physical name, but you can&#39;t get the string output as it&#39;s to be considered like a &#34;promise&#34; and not resolved till the end of the plan.
Logical names require strings, not `pulumi.String`.

## Go Makes it Simple

I did a little searching for correctly converting strings into int hashes, and with the volume of deployments, a collision risk is ridiculously low (something like 1 in 1 billion?).

Here&#39;s how I went about it.
You can adapt this for your Pulumi plan.
I went back to one of my favorites, [gofakeit](https://github.com/brianvoe/gofakeit) which provides a fantastic package for generating data.
What&#39;s cool about this is that the generators offer a global `Seed` option so you can reliably regenerate the same random data.

### Setup

[@brianvoe on github](https://github.com/brianvoe) did a great job with this `gofakeit` package.

```shell
go get &#34;github.com/brianvoe/gofakeit/v6&#34;
```

Add this to your imports

```go
import (
	&#34;github.com/brianvoe/gofakeit/v6&#34;
)
```

Now for the hashing, I found a great MIT licensed library I grabbed two functions from here: [util](https://github.com/shomali11/util/blob/master/xhashes/xhashes.go) by [@shomali11 on github](https://github.com/shomali11)

```go
// FNV64a hashes using fnv64a algorithm
//
// Sourced from: https://github.com/shomali11/util/blob/master/xhashes/xhashes.go
func FNV64a(text string) uint64 {
	algorithm := fnv.New64a()
	return uint64Hasher(algorithm, text)
}

// uint64Hasher returns a uint64
//
// Sourced from: https://github.com/shomali11/util/blob/master/xhashes/xhashes.go
func uint64Hasher(algorithm hash.Hash64, text string) uint64 {
	algorithm.Write([]byte(text))
	return algorithm.Sum64()
}
```

I set up a few methods on a configuration struct.

```go
// Clusters returns a list of clusters.
type Clusters struct {
	Name string `json:&#34;name,omitempty&#34;`
}
// setSeed sets the gofakeit global state to a specific
// seed value based on the string input.
func setSeed(s string) {
	calcSeed := FNV64a(s)
	v := int64(calcSeed)
	gofakeit.Seed(v)
}
// animalString returns a string formatted with `{DescriptiveAdjective}-{Animal}`.
func animalString() string {
	animal := gofakeit.Animal()
	adjective := gofakeit.AdjectiveDescriptive()
	return strings.ToLower(strings.Join([]string{adjective, animal}, &#34;-&#34;))
}
```

Now, once you load a configuration into the struct using the Pulumi configuration package, you can obtain a randomized petname on demand, that will be repeatable and only change if the cluster name is different.

{{&lt; admonition type=&#34;Tip&#34; title=&#34;If your uniqueness requirements change...&#34; open=true &gt;}}

If your business requirements for uniqueness change, such as a combination of `resource&#43;cluster` now needing to be deployed in duplication across another namespace (for example for provisioning development environments on demand)... you can just change the input seed from cluster to a combination of other values and you&#39;ll generate new unique seeds from there.

{{&lt; /admonition &gt;}}

```go
// PetName returns a unique petname for logical resources to be uniquely named in the Pulumi state file.
// This is formatted as `adjective-animal`.
// For logical name purposes, use the PetNameSuffix method instead.
func (c *Clusters) PetName() string {
	// Calculate a seed value based on cluster name and then generate a random petname for the reosurces so that the logical names stay truly unique even in multi-cluster environments.
  setSeed(c.Name)
	randomPet := animalString() // Random based on seed, so should be repeatable for different deploys.
	return randomPet
}

// PetName returns a unique petname suffix for easy string concantenation for logical resources.
// This is formatted as `-adjective-animal` with a preceding.
// You&#39;d join like `_, err = appsv1.NewDeployment(ctx, &#34;myapp&#34; &#43; config.PetNameSuffix(), nil)
func (c *Clusters) PetNameSuffix() string {
	// Calculate a seed value based on cluster name and then generate a random petname for the reosurces so that the logical names stay truly unique even in multi-cluster environments.
  setSeed(c.Name)
	return &#34;-&#34; &#43; animalString() // Random based on seed, so should be repeatable for different deploys.
}

```

## Quick and Dirty Option

If you just want to do it all in `main()` and ignore the frowning of the &#34;best practice police&#34; just inline it.

```go
calcSeed := FNV64a(cluster.Name)
v := int64(calcSeed)
gofakeit.Seed(v)
animal := gofakeit.Animal()
adjective := gofakeit.AdjectiveDescriptive()
randomPetCalc := strings.ToLower(strings.Join([]string{adjective, animal}, &#34;-&#34;))
fmt.Printf(&#34;Random Pet Calculated at Runtime: %s\n&#34;, randomPetCalc)
```

## Using in Loop

Note that this would probably have issues if you were trying to update the seed in goroutines as I believe it&#39;s a global variable.
However, it works great when you need to do something like this:

```go
for _, cluster := range clusterList {
    suffix := cluster.PetNameSuffix()
    err = ingress.NetworkingIngress(ctx, suffix) // ... etc
}
```

## Wrap-Up

I got here thanks to the help of folks in the Pulumi slack &#43; Github discussions.
I&#39;ve found it&#39;s a common question.
I recommended they beef up some good examples of using the random provider like this.
However, I&#39;m not certain it fits Pulumi&#39;s &#34;promise&#34; model quite the same as it was with Terraform.
I&#39;m not versed enough in the architecture to understand why it worked for Terraform but not with Pulumi, but this &#34;workaround&#34; using normal Go code seems to work fine.
I&#39;m really appreciating the value of having access to a full fledged programming language in my infrastructure work, including Kubernetes, even if this entails a little more complexity up front.

## Further Reading

- [Using random resource in plans with Go? · Discussion #9207 · pulumi/pulumi · GitHub](https://github.com/pulumi/pulumi/discussions/9207)
- [How do you approach passing around ID&#39;s for resources without it becoming a hot mess? · Discussion #9205 · pulumi/pulumi · GitHub](https://github.com/pulumi/pulumi/discussions/9205)
- [Unique ComponentResource Names With Random Suffix · Discussion #9216 · pulumi/pulumi · GitHub](https://github.com/pulumi/pulumi/discussions/9216)
- [Using ComponentResource as logical namespace · Discussion #9250 · pulumi/pulumi · GitHub](https://github.com/pulumi/pulumi/discussions/9250)
- [Cannot use Output as logical resource name · Issue #5234 · pulumi/pulumi · GitHub](https://github.com/pulumi/pulumi/issues/5234#issuecomment-697966379)
- [Inputs and Outputs | Pulumi Docs](https://www.pulumi.com/docs/intro/concepts/inputs-outputs/)

