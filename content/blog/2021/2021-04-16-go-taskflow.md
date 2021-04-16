---
date: 2021-04-16T16:57:07-05:00
title: Go Taskflow
slug: go-taskflow
summary:
  Foo
tags:
  - tech
  - development
  - azure-devops
  - powershell
  - devops
draft: true
toc: true
series: ["Development Workflow Tooling"]
---

## Taskflow

I've been working with Go in my new role and figured one area I could use to improve my Go chops while accomplishing some devops style tasks would be using a Go based task runner.

I worked with Mage a bit, which was pretty awesome!
After trying that out I started using Taskflow, which is my current go to.

<div class="github-card" data-github="pellared/taskflow" data-width="400" data-height="296" data-theme="medium"></div>
<script src="//cdn.jsdelivr.net/github-cards/latest/widget.js"></script>

## Basics

I'm only going to go over some basics and examples here, as the docs on the github project would be better to review for more detailed insight.

## Example Tasks

Here's a task where I try several methods for getting the terraform binary path.
I wanted to have flexibility to use the terraform found in path, but also allow using a locally provided binary that perhaps tfswitch symlinked into the current directory.

```go
func getTerraformPath(tf *taskflow.TF) (terraformPath string) {
	terraformPath, err := filepath.Abs(path.Join(toolsDir, "terraform"))
	if err != nil {
		tf.Logf("🔄 skipcannot resolve realpath of terraformPath at: [%s] -> [%v]\n", terraformPath, err)
		tf.SkipNow()
	}
	if _, err := os.Stat(terraformPath); os.IsNotExist(err) {
		tf.Logf("❗ cannot find terraform at: [%s] -> [%v]\n", terraformPath, err)
		tf.SkipNow()
	}
	pterm.Success.Printf("✅ found terraform at: [%s]\n", terraformPath)
	sb := &strings.Builder{}
	tfVersion := tf.Cmd(terraformPath, "--version", "-json")
	tfVersion.Stdout = io.MultiWriter(sb)
	if err := tfVersion.Run(); err != nil {
		pterm.Error.Printf("❗ terraform --version: [%s]\n", err)
		tf.FailNow()
	}
	ver := TerraformVersion{}
	s := sb.String()
	err = json.Unmarshal([]byte(s), &ver)
	if err != nil {
		pterm.Error.Println("❗ was not able to parse terraform version")
		tf.Fail()
	}
	pterm.Success.Printf("✅ terraform version: [%s]\n", ver.TerraformVersion)

	return terraformPath
}


```

## My Findings

I still use Task [^go-task] when exploring simple make style tool running, and InvokeBuild [^InvokeBuild] for the seamless cli and VSCode task integration.
I find that Go doesn't quite lend itself to the random exploration of commands that you get with PowerShell, for example, and wants you to have a better idea of what you expect to do.

Would I recommend anyone else run Taskflow or Mage?

- If you are a Go developer and prefer to stay with your main tools, yes.
- If you want to have the power of interacting with some of your packages and business logic, for sure!
- If you are exploring various tasks and automating basic cli activity, then though it works, it's a lot more work in my opinion.

[^go-task]: [2020-11-03-improving-local-development-workflow-with-go-task]({{< relref "2020-11-03-improving-local-development-workflow-with-go-task" >}} "2020-11-03-improving-local-development-workflow-with-go-task")
[^InvokeBuild]: [InvokeBuild](https://github.com/nightroman/Invoke-Build)
