# Go R1 Day 30


## progress

- Built some go functions for build tasks work with terraform and setup of projects using taskflow.

Learned one one to pass in arguments using slices.
I&#39;m pretty sure you can use some stringbuilder type functionality to get similar behavior, but this worked fine for my use case.

```go
cmdParams := []string{}
cmdParams = append(cmdParams, &#34;-chdir=&#34;&#43;tfdir)
cmdParams = append(cmdParams, &#34;init&#34;)
cmdParams = append(cmdParams, &#34;-input=false&#34;)
cmdParams = append(cmdParams, &#34;-backend=true&#34;)
cmdParams = append(cmdParams, &#34;-backend-config=&#34;&#43;tfconfig)
terraformCmd := tf.Cmd(terraformPath, cmdParams...)
if err := terraformCmd.Run(); err != nil {
  tf.Errorf(&#34;⭕ terraform init failed: [%v]&#34;, err)
  return
}
```

