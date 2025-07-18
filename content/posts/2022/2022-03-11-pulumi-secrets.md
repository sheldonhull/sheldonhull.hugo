---
date: 2022-03-11T23:49:22+0000
title: Pulumi Secrets
slug: pulumi-secrets
summary:
  Really appreciate the slick handling for stack level encrypted secrets.
tags:

- tech
- development
- pulumi
- go

toc: true
series:

- pulumi

---

## Chicken or The Egg

Secrets with infrastructure are a problem.

- I want to source control my secrets, and deploy via CD.
- I want to use infrastructure-as-code to define my configuration, including secrets.

But I don't want to expose the values at any stage during this.
I want to keep them in a secret store, and only expose them when I need them, but I still want to manage them via code.

For a while I've done a blend of loading local environment variables or creating manually in a vault, and then using in other ways.

Terraform makes this tricky IMO, as if you want to create a secret like an Azure DevOps library variable, SSM parameter, or other value, you need to go and add this into Terraform cloud as a secret value, use a third party cli that helps do this for you, or some other work around.

## Other alternatives

There are tools that allow you to encrypt your files in git, but it adds another layer of complexity, and often isn't cross-platform compatible.

## Pulumi Secret Encryption

Pulumi's solution seems like a non-brainer ingenious way to solve this.

When using their remote state storage, you can use the cli to easily flag a value as a secret, and the value is encrypted in your yaml configuration (you can configure one outside of the yaml too if you wish I think).

```shell
pulumi config set --secret --secret-key=my-secret-key my-secret-value
```

## Some Practical Examples

I wanted to embed some encrypted kubeconfigs for designated clusters to do deployments.

Assuming you have a directory of some service account kubeconfigs, you could run this shell script and add encrypted configurations for each of your clusters that pulumi could then read.

```shell
pulumicwd=pulumi/myfancyproject
pulumistack=myfancyproject/dev
ClusterIndex=0
for i in $(ls .mykubeconfigs/kubeconfig-svc-account--*.yaml); do
  echo "Processing $i: ClusterIndex: $ClusterIndex"
  kubecontent=$(cat $i | gojq --compact-output --yaml-input)
  clustername=$(echo $kubecontent | gojq '.clusters[0].name' --raw-output)
  pulumi --cwd $pulumicwd --stack $pulumistack config set --path "clusters[${ClusterIndex}].name"  $clustername
  cat $i | gojq --compact-output --yaml-input | pulumi --cwd $pulumicwd --stack $pulumistack config set --secret --path "clusters[${ClusterIndex}].kubeconfig"
  ClusterIndex=$((ClusterIndex+1))
done
echo "All done, the magic has been done, toast your kubeconfigs and send Sheldon a coffee. ☕ (and copilot for helping write this so quickly)"
```

This would result in the following pulumi yaml being part of your stack:

```yaml
---
config:
  myfancyproject:clusters:
    - clustername: clusteeeeergobrrrr01
      kubeconfig:
        secure: mumbojumbencryptedtexthere
    - clustername: clusteeeeergobrrrr02
      kubeconfig:
        secure: mumbojumbencryptedtexthere
```

## Consuming This in Go

What's cool is it's so freaking easy to work with it still in Pulumi.
Since the encryption is per stack, as long as you are in the right stack, and as long as you specify explicitly that the value you want to load is a secret, you can just work with it almost as usual.

In fact, all it takes is flipping `RequireObject` to `RequiredSecretObject`.

Not everything is easy in Pulumi... for sure, but they freaking nailed this.

### Create A Config Object

```go
type Clusters struct {
  Name       string `json:"name,omitempty"`
  Kubeconfig string `json:"kubeconfig,omitempty"`
}
```

### Use Structured Secret Configuration In Pulumi Plan

Now that we have a config object, use Pulumi's configuration package to load the config directly into a pointer to a struct.

```go
import 	(
	kubernetes "github.com/pulumi/pulumi-kubernetes/sdk/v3/go/kubernetes"
	pulumi "github.com/pulumi/pulumi/sdk/v3/go/pulumi"
  config "github.com/pulumi/pulumi/sdk/v3/go/pulumi/config"
)
func main() {
  pulumi.Run(func(ctx *pulumi.Context) error {
    configClusters := []Clusters{}
    // config.RequireObject("clusters", &configClusters) // wouldn't give encrypted values, so we do the next line
    config.RequireSecretObject("clusters", &configClusters) // wouldn't give encrypted values, so we do the next line

    for _, cluster := range configClusters {
      _ = ctx.Log.Info(fmt.Sprintf("starting up on cluster: %s... it go brrrr", cluster.Name), &pulumi.LogArgs{})
      pargs := &kubernetes.ProviderArgs{}
      pargs.Kubeconfig = cluster.Kubeconfig
      myProvider, err := kubernetes.NewProvider(ctx, "k8", pargs)
      // now pass this myProvider to resources as the provider to use.
    }
  }
}
```

Passing the provider is done per resources like this:

```go
_, err = appsv1.NewDeployment(
	ctx,
	"my-deployment-name",
	&appsv1.DeploymentArgs{},
	pulumi.Provider(prov),
)
```

## Security Is Per Stack

Now... let's say you get worried about someone cloning this file and doing some devious with it.

They go along and generate a new yaml file, grab your encrypted values, use pulumi to decrypt and then go and drop your cluster.

Ain't gonna happen.
The paranoid part of my DevOpsy brain thinks like this.

```text
error: failed to decrypt encrypted configuration value 'cluster:kubeconfig': [400] Message authentication failed
This can occur when a secret is copied from one stack to another. Encryption of secrets is done per-stack and
it is not possible to share an encrypted configuration value across stacks.
```

To me this felt like a failure I really was happy to see. Thank you Pulumi!

Best part is no freaking `echo $val | base64 -d`... `<looking at you kubernetes secret values>`.

## Side Note On Configuration

I used a more complex config struct for the main naming convention enforcement and it worked great to simplify naming consistency.
Might do an article on this sometime if anyone finds it useful.

Example:

```go
// ServiceDeployName returns a string formatted like `myapi-dev-myapp-{SUFFIX}` where suffix is provided on call.
func (d *SvcConfig) ServiceDeployName(sharedConfig *SharedConfig, suffix string) string {
	return strings.ToLower(
		strings.Join([]string{d.Rolename, sharedConfig.Environment, d.Deployment, suffix}, "-"),
	)
}
```

This provided solid intellisense all the way through it and made it really easy to refactor naming all by updating my config package.

## Disclaimer

I'm a fan of role based access like AWS Role assumption, using limited generated access tokens, etc (see [article on Leapp for a great example for local dev workflows]([[2021-06-28-simplify-aws-developer-security-with-leapp]] "simplify-aws-developer-security-with-leapp"))

However, practically, you might have services or apps that you need to manage that the cost of setting all that up is very high, for example you do the majority of your work in AWS, but you have a development Kubernetes cluster and want to setup a limited service account to do some Gitpod stuff.
You use this service account for limited scope permissions for deployments only, and this might be a great case of just embedding the kubeconfig directly into a Pulumi plan.

Maybe you need your PAT embedded for a provider, now just add as an encrypted value to your stack and get work shipped.

Improve later with more robust handling, but this will cut down the overhead of getting infra-as-code for a lot of the smaller projects!

## Futher Reading

- [Pulumi & Secrets](https://www.pulumi.com/docs/intro/concepts/secrets/)

## Tools Used Or Mentioned

- [Pulumi](https://www.pulumi.com/)
- [Gojq](https://github.com/itchyny/gojq)
- [Copilot - It actually wrote 50% of the shell script example. I ❤️ Copilot](https://copilot.github.com/)
- [base64 cli](https://linux.die.net/man/1/base64)
- [Kubernetes](https://kubernetes.io/)
- [Pulumi Structured Configuration](https://www.pulumi.com/docs/intro/concepts/config/#structured-configuration) & associated Go Package: [Config](https://github.com/pulumi/pulumi/tree/master/sdk/go/pulumi/config)
