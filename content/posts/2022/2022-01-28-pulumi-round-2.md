---

date: 2022-01-28T19:40:41+0000
title: Pulumi Round 2
slug: Pulumi-round-2
tags:

- tech
- development
- microblog
- kubernetes
- go

typora-root-url: ../../../static
typora-copy-images-to:  ../../../static/images
series: ["pulumi"]
---

This is not a comprehensive article, but more a log of the issues and wins as I work through Pulumi adoption.

## tl;dr

- Pulumi is pretty powerful.
- Once you get beyond the basics, it requires a lot of effort since the tooling doesn't have as many examples as I'd hope.
This is especially true for Kubernetes.
It's a lot easier to get moving on other providers.
- It's more intensive of a pilot to do complex things IMO than Terraform, because you aren't getting pre-built modules that just have all the stack done automatically (at least in Go).[^crosswalk]
- Certain things that were painful in Terraform just work in Pulumi.
For example, renaming the underlying org was super easy, removing stuck items from state, and other actions that with Terraform are much trickier.

## Where I Started

- I have replicated basically what Helm gives you for an external api template out of the box and am doing this in Pulumi.
- This uses the Pulumi config and loads into a config struct.
- I'm running CICD with this to build and deploy a container, and finally run a task to run Pulumi against a Kubernetes cluster to apply an updated deployment based on that new semver tag.

## Challenge 1: Authenticating Via K8 Namespace Scoped Service Account

Figuring out the balance between default provider that inherits your Kubeconfig and being more explicit by configuring this myself has been a challenge.

I took two days to work through the proper Service account level authorization, but finally with the help of a little [Mage](https://github.com/magefile/mage) I have a running login task that wraps up a sequence of steps for me to authenticate purely based on K8 Service account credentials.

- TODO: Also plan on checking out the Azure Key Vault integration, as this is pretty neat. You can set it as the backend provider for your secret rather than Pulumi.

### Attempting to Embed Service Account Credentials in Stack

Pulumi does per stack level encryption of secrets, so I thought this might be really nice to setup and try.
This would mean any of my team could run the plan with the specific service account credentials already embedded to quickly apply a development fix or test against a development enviornment.

This is in constrast this to building a kubeconfig locally and pointing to that.
That works, but does feel more brittle.

I tried this:

    pulumi --cwd pulumi/myproject --stack=myorg/myproject/dev config set --secret --path 'kubernetes:kubeconfig' "$(cat /workspaces/myproject/.cached/.kube/tmp.kube.config)"

> NOTE: Optionally use without `--path`.

This temporary configuration I generated via the kubectl commands for setup.

Now I see:

    config:
        kubernetes:cluster: mycluster
        kubernetes:context: mycontext
        kubernetes:kubeconfig:
            secure: mysupersecretencryptedvaluebyPulumipus

Next I made some changes to the Pulumi plan that checked for `KUBECONFIG` and allowed the override as usual, however if not provided it defaulted to the value stored in the configuration.
Will think on that and probably remove the extra code later.

Didn't get this to work, so I reverted back to passing in the generated kubeconfig file instead.
This was set by a command like this:

    pulumi --cwd pulumi/myproject --stack=myorg/myproject/dev config set --path 'kubernetes:kubeconfig' /workspaces/myproject/.cached/.kube/tmp.kube.config

Failure.

I still kept getting the dreaded:

    configured Kubernetes cluster is unreachable: failed to parse kubeconfig data in kubernetes:config:kubeconfig

I tried `KUBECONFIG=/workspaces/myproject/.cached/.kube/tmp.kube.config pulumi --cwd pulumi/myproject --stack=myorg/myproject/dev up --diff` and it detected the new `kubernetes:kubeconfig` and put in the state.

✅ BOOM! Once I did this refresh of the state, it seemed to properly allow me to connect.

I found that ensuring `KUBECONFIG=path pulumi ...` helped a lot, but I think the KUBECONFIG path in the state file also mattered and had to be refreshed.

Ok... to ensure this was the issue I did this test:

1. Stop using my credential and point to the service account generated kubeconfig.
2. Run `KUBECONFIG={newkubeconfig} pulumi destroy`.
    1. It detected the change when running up, I just didn't apply.
3. Deletion worked.

To me this points towards the `KUBECONFIG` correctly being used when passed into the provider, so I can run without refreshing the state even though a refresh/up will indicated it detected the change.

I probably need to trim this code, but to support KUBECONFIG explicitly being provided I did something like this:

{{< gist sheldonhull 764d2702bf9e783fca0263bbabd598a7 >}}

## Challenge: Handle config values that change

I thought maybe I could dynamically set the kubeconfig at runtime using the `--config` flag.
I looked in the GitHub repo and couldn't find any examples, and the cli doesn't provide any I could see.

Here's a little taste of what I ran:

        Pulumi up --diff --refresh --config 'kubernetes:kubeconfig /workspaces/myproject/.cached/.kube/tmp.kube.config'
        Pulumi up --diff --refresh --config 'kubernetes:kubeconfig' '/workspaces/myproject/.cached/.kube/tmp.kube.config'
        Pulumi up --diff --refresh --config 'kubernetes:kubeconfig: /workspaces/myproject/.cached/.kube/tmp.kube.config'
        Pulumi up --diff --refresh --config 'kubernetes:kubeconfig','/workspaces/myproject/.cached/.kube/tmp.kube.config'
        Pulumi up --diff --refresh --config 'kubernetes:kubeconfig,/workspaces/myproject/.cached/.kube/tmp.kube.config'
        Pulumi up --diff --refresh --config 'kubernetes:kubeconfig' /workspaces/myproject/.cached/.kube/tmp.kube.config
        Pulumi up --diff --refresh --config '{ "kubernetes:kubeconfig": /workspaces/myproject/.cached/.kube/tmp.kube.config
        Pulumi up --diff --refresh --config '{ "kubernetes:kubeconfig": "/workspaces/myproject/.cached/.kube/tmp.kube.config" }'
        Pulumi up --diff --refresh --config '"kubernetes:kubeconfig": "/workspaces/myproject/.cached/.kube/tmp.kube.config"'
        Pulumi up --diff --refresh --config kubernetes:kubeconfig /workspaces/myproject/.cached/.kube/tmp.kube.config

The variety of changes this made the kubeconfig were entertaining at least.
I moved on, as this didn't seem to be a valid way to work.

Pretty sure the cli was laughing at me.

        config:
            kubernetes:cluster: mycluster
            kubernetes:context: mycluster
            kubernetes:kubeconfig,/workspaces/myproject/.cached/.kube/tmp.kube.config: ""
            kubernetes:namespace: mynamespace

## Challenge: How Do I Use Replace?

While mostly intuitive, the darn cli docs are missing some jump start examples.
I'm pretty sure most of us want examples, and I'd like to see exhaustive examples on the docs page.

I tried to force a replacement of a deployment:

        pulumi up --diff --replace 'myproject-dev-deployment'    ❌ NOT FOUND
        pulumi up --diff --replace 'kubernetes:apps:Deployment'  ❌ NOT FOUND

> `--replace stringArray` Specify resources to replace. Multiple resources can be specified using --replace urn1 --replace urn2 [pulumi up docs](https://www.pulumi.com/docs/reference/cli/pulumi_up/)

Not sure of the urn, as I couldn't find in the state file.
Decided to go with destroy 🔥 and redeploy to be (not)safe.
Hey it's a dev environment after all!

## Mapping from Yaml

Ran into an edge case. I set config values that had a slash.

    myconfig:
        subsection:
            io/foo: 123

This seemed to read all the zero values and couldn't obtain them.
I went and replaced all of these with a command like: `pulumi --cwd pulumi/myproject --stack=myorg/myproject/dev config set --path 'data.podannotations.myservice.myport' 80`.

No luck.
Figured it might be something to do with maps, but I couldn't find anything with Go having issues with the key value having a slash or such.

Gave this a shot and 🎉 it worked.

    type MyConfig struct {
        Onlyyaml          bool   `yaml:"onlyyaml"`
        SpecialNested     struct {
            Enabled              bool   `yaml:"enabled"`
        } `yaml:"specialnested,inline"` // 👈 inline is needed
    }

This parsed the value:

    config:
        specialnested:
            enabled: true

Now I know. I didn't see anything about using this when reading the docs, so that's another one that shows it requires expertise in both Pulumi + the native language to figure out what's wrong.

> Embedded structs are not treated as embedded in YAML by default. To do that add the ",inline" annotation below. [Unmarshal for yaml.v2](https://pkg.go.dev/gopkg.in/yaml.v2#Unmarshal)

I couldn't find the exact package being used due to time, but it's possible that this was forked off the original package here: [pulumi-go-yaml](https://pkg.go.dev/github.com/pulumi/go-yaml).

## Task Runner

I standardize all my projects, personal and work with Mage.

Was pretty easy to integrate with pulumi, even though their CLI is pretty awesome and easy to use..
However, I prefer all tools that aren't one off's have a simple standardized way to execute.

For me this entailed: `mage pulumi:diff myproject dev` and it ensured all the command line flags and such were setup.

I put some sample tasks on my magetools repo: [Magetools - Examples - Pulumi](https://github.com/sheldonhull/magetools/tree/main/examples/pulumi).

Some examples from that:

    // Pulumi namespace contains task to help with running Pulumi tools.
    type Pulumi mg.Namespace

    // Get returns the fully qualified Pulumi stack name, including the org, project, and stage.
    // This looks like `myorg/project/stage`.
    func GetPulumiStackName(project, stage string) string {
        mtu.CheckPtermDebug()
        return strings.Join([]string{PulumiOrg, project, stage}, "/")
    }


    // 🚀 Up 👉 Parameters(project, stack string): Eg: `mage pulumi:up myproject dev`.
    // Runs pulumi up/apply to target.
    //
    // Example: `mage pulumi:up myproject dev`.
    func (Pulumi) Up(project, stage string) error {
        mtu.CheckPtermDebug()
        return sh.RunV(
            "pulumi",
            "--cwd",
            filepath.Join(PulumiProjectDir, project),
            "--stack="+GetPulumiStackName(project, stage),
            "up",
            "--yes",
            "--emoji",
        )
    }

## My Feedback

- [ ] Provide several examples for using the flags, such as `--config` as I couldn't figure out how to pass the string array in a way that made sense.
- [ ] I've seen others post on issues as well about confusion with the provider. Much of the examples rely on the default provider.
For me that was problematic when I wanted to try and work locally but then use a service account credential only for pulumi to test.
Make some more examples on how to easily do that.
- [ ] Provide help on Stack Overflow, Github Discussions, or a dedicated discourse to promote visibility and knowledge resharing on solutions. Preference would be Github discussions as it's easy to find help inline with issues.
Slack is a terrible place to find info in comparison and responses can be erratic and slow (which I get considering how stretched everyone must be!)
- [ ] Maybe the logger makes sense for automation api or something else, but I'd love to see the default logger support structured logging (say through zerolog) or something a bit less clunky.
Having to replace the string values like this made from some clunky logging code. `_ = ctx.Log.Error(fmt.Sprintf("Unable to read Kubeconfig override: %q, %v", kubeConfigOverride, err), nil)`.
I'd like to just call: `pulumi.Log.Info().Str("myval",strval).Msg("this is important")`.

[^crosswalk]: They are making progress on this with Crosswalk, but Go isn't in there at this time.
