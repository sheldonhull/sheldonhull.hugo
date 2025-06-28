# Improving Local Development Workflow With Go Task


## Workflow Tooling

Development workflow, especially outside of a full-fledged IDE, is often a disjointed affair.
DevOps oriented workflows that often combine cli tools such as terraform, PowerShell, bash, and more all provide more complexity to getting up to speed and productive.

Currently, there is a variety of frameworks to solve this problem.
The &#34;gold standard&#34; most are familiar with in the open-source community would be [Make](https://www.gnu.org/software/make/manual/make.html).

## Considering Cross-Platform Tooling

This is not an exhaustive list, it&#39;s focused more on my journey, not saying that your workflow is wrong.

I&#39;ve looked at a variety of tooling, and the challenge has typically that most are very unintuitive and difficult to remember.

Make...it&#39;s everywhere. I&#39;m not going to argue the merits of each tool as I mentioned, but just bring up that while cMake is cross platform, I&#39;ve never considered Make a truly cross platform tool that is first class in both environments.

## InvokeBuild &amp; Psake

In the Windows world, my preferred framework would be [InvokeBuild](https://github.com/nightroman/Invoke-Build) or [PSake](https://github.com/psake/psake).

The thing is, not every environment will always have PowerShell, so I&#39;ve wanted to experiment with minimalistic task framework for intuitive local usage in a project when the tooling doesn&#39;t need to be complex.
While `InvokeBuild` is incredibly flexible and intuitive, there is an expectation of familarity with PowerShell to fully leverage.

If you want a robust framework, I haven&#39;t found anything better.
Highly recommend examining if you are comfortable with PowerShell.
You can generate VSCode tasks from your defined scripts and more.

`InvokeBuild` &amp; `Psake` aren&#39;t great for beginners just needing to run some tooling quickly in my experience.
The power comes with additional load for those not experienced in PowerShell.

If you are needing to interact with AWS.Tools SDK, complete complex tasks such as generating objects from parsing AST (Abstract Syntax Trees) and other, then I&#39;d lead towards `InvokeBuild`.

However, if you need to initialize some local dependencies, run a linting check, format your code, get the latest from main branch and rebase, and other tasks that are common what option do you have to get up and running more quickly on this?

## Task

[Go Task](https://taskfile.dev/#/)

I&#39;ve been pleasantly surprised by this cross-platform tool based on a simple `yaml` schema.
It&#39;s written in go, and as a result it&#39;s normally just a single line or two to immediately install in your system.

Here&#39;s why you might find some value in examining this.

1. Cross-platform syntax using this go interpreter [sh](https://github.com/mvdan/sh)
1. Very simple `yaml` schema to learn.
1. Some very nice features that make it easy to ignore already built assets, setup task dependencies (that run in parallel too!), and simple cli interactivity.

My experience has been very positive as I&#39;ve found it very intuitive to build out basic commands as I work, rather than having to deal with more more complex schemas.

## Get Started

```yaml
version: 3
tasks:
  default: task --list
  help: task --list

  fmt:
    desc: Apply terraform formatting
    cmds:
      - terraform fmt -recursive=true
```

The [docs](https://taskfile.dev/#/usage) are great for this project, so I&#39;m not going to try and educate you on how to use this, just point out some great features.

First, with a quick VSCodee snippet, this provides you a quick way to bootstrap a new project with a common interface to run basic commands.

Let&#39;s give you a scenario... assuming you aren&#39;t using an already built Docker workspace.

1. I need to initialize my 2 terraform directories.
1. I want to also ensure I get a few go dependencies for a project.
1. Finally, I want to validate my syntax is valid among my various directories, without using pre-commit.

This gets us started...

```yaml
version: 3
tasks:
```

Next, I threw together some examples here.

- Initialize commands for two separate directories.
- A `fmt` command to apply standardized formatting across all `tf` files.
- Finally, wrap up those commands with a `dep: []` value that will run the `init` commands in parallel, and once that is finished it will run `fmt` to ensure consistent formatting.

```yaml
version: &#39;3&#39;
env:
  TF_IN_AUTOMATION: 1
tasks:
  init-workspace-foo:
    dir: terraform/foo
    cmds:
      - terraform init
  init-workspace-bar:
    dir: terraform/bar
    cmds:
      - terraform init
  fmt:
    desc: Recursively apply terraform fmt to all directories in project.
    cmds:
      - terraform fmt -recursive=true
  init:
    desc: Initialize the terraform workspaces in each directory in parallel.
    deps: [init-workspace-foo,init-workspace-bar]
    cmds:
      - task: fmt
```

You can even add a task in that would give you a structured git interaction, and not rely on git aliases.

```yaml
  sync:
      desc: In GitHub flow, I should be getting lastest from main and rebasing on it so I don&#39;t fall behind
      cmds:
        - git town sync
```

## Why not just run manually

I&#39;ve seen many folks online comments about why even bother?
Can&#39;t the dev just run the commands in the directory when working through it and be done with it?

I believe tasks like this should be thrown into a task runner from the start.
Yes, it&#39;s very easy to just type `terraform fmt`, `go fmt`, or other simple commands... if you are the builder of that project.

However:

- it increases the cognitive load for tedious tasks that no one should have to remember each time the project grows.
- It makes your project more accessible to new contributors/teammates.
- It allows you to simply moving to automation by wrapping up some of these automation actions in GitHub Actions or equivalent, but simply having the CICD tooling chosen run the same task you can run locally.

Minimal effort to move it to automation from that point!

I think wrapping up things with a good task runner tools considers the person behind you, and prioritizes thinking of others in the course of development.
It&#39;s an act of consideration.

## Choose the Right Tooling

Here&#39;s how I&#39;d look at the choices:

- Run as much in Docker as you can.
- If simple actions, driven easily on cli such as build, formatting, validation, and other then start with `Task` from the beginning and make your project more accessible.
- If requirements grow more complex, with interactions with AWS, custom builds for Lambda, combined with other more complex interactions that can&#39;t easily be wrapped up in a few lines of shell scripting... use `InvokeBuild` or equivalent. This gives you access to the power of `.NET` and the large module collection provided.

Even if you don&#39;t really need it, think of the folks maintaining or enabling others to succeed with contributions more easily, and perhaps you&#39;ll find some positive wins there. 🎉

