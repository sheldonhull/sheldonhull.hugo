# Go R1 Day 35


## progress

- Worked with Taskflow a bit more.
- Need to identify better error handling pattern on when to resolve vs handle internal to a function, as it feels like I&#39;m doing needless error checking.
- Wrote func to run terraform init, plan, and apply.
- This takes dynamical inputs for vars and backend file.
- Also dynamically switches terraform versions by running tfswitch.

Definitely more verbose code than powershell, but it&#39;s a good way to get used to Go while achieving some useful automation tasks I need to do.

Example of some code for checking terraform path.

```go
func terraformPath(tf *taskflow.TF) (terraformPath string, err error) {
	terraformPath = path.Join(toolsDir, &#34;terraform&#34;)
	if _, err := os.Stat(terraformPath); os.IsNotExist(err) {
		tf.Errorf(&#34;❗ cannot find terraform at: [%s] -&gt; [%v]&#34;, terraformPath, err)
		return &#34;&#34;, err
	}
	tf.Logf(&#34;✅ found terraform at: [%s]&#34;, terraformPath)
	return terraformPath, nil
}
```

```go
terraformPath, err := terraformPath(tf)
if err != nil {
  tf.Errorf(&#34;❗ unable to proceed due to not finding terraform installed [%v]&#34;, err)
  return
}
```

However, once I call this, I&#39;m see more effort in handling, which feels like I&#39;m double double work at times.

