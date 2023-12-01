---
title: kubernetes
description: A reference for Kubernetes
date: 2023-04-05 12:23
preview: ""
draft: false
tags:
  - kubernetes
categories: []
lastmod: 2023-04-05 12:31
---

## Deployment Tips

- What imagePullPolicy should I use?
  > The caching semantics of the underlying image provider make even imagePullPolicy: Always efficient, as long as the registry is reliably accessible.[image-policy]

## Troubleshooting

{{< admonition type="note" title="Error: ImagePullBackOff" open=false >}}

Thanks to a [Stack Overflow answer](https://stackoverflow.com/a/64003061/68698) I was pointed to the answer on [pre-pulled-images](https://kubernetes.io/docs/concepts/containers/images/#pre-pulled-images).

This is a great example of the challenges of abstraction with tools.
The declared image policies have more impact on the behavior than I originally thought.

> By default, the kubelet tries to pull each image from the specified registry. However, if the imagePullPolicy property of the container is set to IfNotPresent or Never, then a local image is used (preferentially or exclusively, respectively).

To load an image you can run a command like this: `minikube image load --profile myprofile 'image:latest'`.

{{< /admonition >}}

[image-policy]: https://kubernetes.io/docs/concepts/containers/images/#image-pull-policy
