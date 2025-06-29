---
title: kubernetes
description: A reference for Kubernetes
date: 2023-04-05T12:23:00
preview: ""
draft: false
tags:
  - kubernetes
categories: []
lastmod: 2023-04-05T12:31:00
---

## Deployment Tips

- What imagePullPolicy should I use?
  > Even if the imagePullPolicy property is set to Always, it's still efficient, provided the registry is reliably accessible, due to the caching semantics of the underlying image provider.[image-policy]

## Troubleshooting

{{< admonition type="note" title="Error: ImagePullBackOff" open=false >}}

As elucidated in a [Stack Overflow answer](https://stackoverflow.com/a/64003061/68698), [pre-pulled-images](https://kubernetes.io/docs/concepts/containers/images/#pre-pulled-images) were the solution to my problem.

Complexities can arise from using abstraction tools. The predefined image policies exert a greater influence on the behavior than initially expected.

> The kubelet, by default, tries to pull each image from the specified registry. Nevertheless, if the imagePullPolicy property of the container is set to IfNotPresent or Never, a local image is used (preferentially or exclusively, respectively).

To load an image, execute a command like this: `minikube image load --profile myprofile 'image:latest'`.

{{< /admonition >}}

[image-policy]: https://kubernetes.io/docs/concepts/containers/images/#image-pull-policy

