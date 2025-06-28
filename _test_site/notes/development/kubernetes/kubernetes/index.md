# kubernetes


## Deployment Tips

- What imagePullPolicy should I use?
  &gt; Even if the imagePullPolicy property is set to Always, it&#39;s still efficient, provided the registry is reliably accessible, due to the caching semantics of the underlying image provider.[image-policy]

## Troubleshooting

{{&lt; admonition type=&#34;note&#34; title=&#34;Error: ImagePullBackOff&#34; open=false &gt;}}

As elucidated in a [Stack Overflow answer](https://stackoverflow.com/a/64003061/68698), [pre-pulled-images](https://kubernetes.io/docs/concepts/containers/images/#pre-pulled-images) were the solution to my problem.

Complexities can arise from using abstraction tools. The predefined image policies exert a greater influence on the behavior than initially expected.

&gt; The kubelet, by default, tries to pull each image from the specified registry. Nevertheless, if the imagePullPolicy property of the container is set to IfNotPresent or Never, a local image is used (preferentially or exclusively, respectively).

To load an image, execute a command like this: `minikube image load --profile myprofile &#39;image:latest&#39;`.

{{&lt; /admonition &gt;}}

[image-policy]: https://kubernetes.io/docs/concepts/containers/images/#image-pull-policy


