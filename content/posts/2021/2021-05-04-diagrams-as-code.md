---
date: 2021-05-04T07:00:00.000Z
title: Diagrams as Code
slug: diagrams-as-code
typora-root-url: ../../../static
summary: >-
  Generate diagrams as code using Python, if you prefer to have a bit more
  development oriented workflow for visualization.
typora-root-url: ../../../static
typora-copy-images-to:  ../../../static/images
tags:
  - tech
  - development
  - devops
  - python
toc: true
---

## Why

It's not for everyone.

I prefer to write diagrams out logically and then let the visual aspect be generated.

This helps me by making the visual presentation an artifact of what is basically a written outline.

## Presentation Matters

I've learned that communicating flows of information can often be better presented visually than trying to write them out, especially once it involves more than a few "nodes" of responsibility. Visualizing a complicated process can be done more easily in a visual way, as well as help expose some possible issues when ownership is transfered between lanes too many times.

## Options

LucidChart, Draw.io and other tools are great for a quick solution.

Mermaid also provides a nice simple text based diagramming tool that is integrated with many markdown tools.

For me, this just never fit. I like a bit of polish and beauty in a visual presentation and most of these are very utilitarian in their output.

I came across diagrams[^diagrams] and found it a perfect fit for intuitive and beautiful diagram rendering of cloud architecture, and figured it would be worth a blog post to share this.

## Getting Started

{{< admonition type="Warning" title="Name Of Project" open="true">}} Do not create a project named the same thing as your dependency, ie project name = diagrams for example.

This will error out and send you down a search in github issues to discover this issue.

{{< /admonition >}}

Install Poetry[^poetry] and create a new poetry project in your directory using `poetry init`.

Once it gets to the package additions add `diagrams` to your poetry file.

Run `poetry install`

Finally, create a new file called `diagram.py` in your directory.

Once you populate this file, you can run your diagram using the virtual env it manages by calling `poetry run python diagram.py`.

Additionally, any command line arguments you want to pass would just go through like `poetry run python diagram.py --outdirectory foobar`

## Diagrams

The documentation is pretty thorough, but detailed examples and shortcuts are very hard to find. You'll have to dig through the repo issues on occasion if you find yourself wanting to do something that isn't obvious. This project seems to be a wrapper around graphviz, so a lot of the documentation for parameters and customizations will be in it's documentation, not in this project.

To find available nodes and shapes, you'll need to look at the diagram docs[^diagram-docs]

## Simple Example

Using defaults you can create a simple diagram such as this:

![vpc-diagram-simple](/images/diagrams-as-code-01-diagram-vpc-example.png)

{{< gist sheldonhull "cc8abcb86c9463b0c74bb9e4d82ffac9" "01-diagram-vpc-example.py">}}

## Add Some Helpers

From the github issues and my own customizations, I added a few additions to make the edge (ie, lines) flow easier to work with.

![vpc-diagram-simple-with-helpers](/images/diagrams-as-code-02-aws-vpc-example-with-helper.png)

{{< gist sheldonhull "cc8abcb86c9463b0c74bb9e4d82ffac9" "02.helpers.py">}}

## A More Complex Example

I went through the AWS Reference Architecture Diagrams [^aws-diagrams] and used this to provide a more complex example.

Take a look at the AWS PDF[^pull-request-continuous-integration-reference-architecture] and compare.

![complex-example](/images/diagrams-as-code-03-complex.png)

{{< gist sheldonhull "cc8abcb86c9463b0c74bb9e4d82ffac9" "03-diagram-complex.py">}}

## Reference

| Graphviz Reference
| ------------------------------------------------------------------------------
| [Colors](https://www.graphviz.org/doc/info/attrs.html#d:color)
| [Available Nodes](https://diagrams.mingrammer.com/docs/nodes/aws)
| [Individual Node Edits](https://github.com/mingrammer/diagrams/issues/202)
| [Reference for Graph Attributes](https://www.graphviz.org/doc/info/attrs.html)

[^poetry]: [Introduction | Documentation | Poetry - Python dependency management and packaging made easy.](https://bit.ly/2PDy9tj)

[^diagrams]: [Diagram GitHub Project](https://bit.ly/3e4t2Mf)

[^aws-diagrams]: [AWS Reference Architecture Diagrams](https://amzn.to/3nBhSSc)

[^pull-request-continuous-integration-reference-architecture]: [Pull Request Continuous Integration Reference Architecture](https://bit.ly/3e6YrxD)

[^diagram-docs]: [Diagram Project - AWS Diagram Node List](https://bit.ly/3vzbuhe)
