# Go R1 Day 66


## progress

This wasn&#39;t specific to Go, but was the first step towards using Go in a distributed test.

### Dapr

I had an interesting project today with my first development level effort using Kubernetes.
Here&#39;s my log of attempting to use [Getting started with Dapr | Dapr Docs](https://docs.dapr.io/getting-started/) and getting two Go APIs to talk to each other with it.

First, what is Dapr?

&gt; Dapr is a portable, event-driven runtime that makes it easy for any developer to build resilient, stateless and stateful applications that run on the cloud and edge and embraces the diversity of languages and developer frameworks. [^dapr-overview]
&gt; ... Dapr codifies the best practices for building microservice applications into open, independent building blocks that enable you to build portable applications with the language and framework of your choice. Each building block is completely independent and you can use one, some, or all of them in your application.

From this, it sounds like Dapr helps solve issues by abstracting the &#34;building blocks&#34; away from the business logic.
Rather than focusing on the implementation level concern of how to talk from service to service, Dapr can help with this.

Instead of relying on provider specific key-value store, such as AWS SSM Parameter store, Dapr abstracts that too.

It&#39;s interesting as this concept of abstraction on a service level is something new to me.
Good abstractions in software are hard but critical to maintainability long-term.
Provider-level abstractions are something on an entirely different scale.

### Setup

- Enable Kubernetes on Docker Desktop.
- Install Lens: `brew install lens`
- Pop this open and `Cmd&#43;,` to get to settings.
- Add dapr helm charts: `https://dapr.github.io/helm-charts/`
- Connect to local single-node Kubernetes cluster and open the charts section in Lens.
- Install Dapr charts.
- Celebrate your master of all things Kubernetes.

![Master Of Kubernetes](/images/2021-08-12-k8-mastery.jpg &#34;Master of Kubernetes&#34;)

I think I&#39;ll achieve the next level when I don&#39;t do this in Lens.
I&#39;ll have to eventually use some cli magic to deploy my changes via helm or level-up to Pulumi. 😀
Until then, I&#39;ll count myself as victorious.

#### A Practical Test

- Install [Dapr - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-dapr)

## links

[^dapr-overview]: [Overview | Dapr Docs](https://docs.dapr.io/concepts/overview/)

