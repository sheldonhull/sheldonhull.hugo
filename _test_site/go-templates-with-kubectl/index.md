# Go Templates With Kubectl


An alternative to using jsonpath with kubectl is go templates!

Try switching this:

````shell
kubectl get serviceaccount myserviceaccount --context supercoolcontext --namespace themagicalcloud -o jsonpath=&#39;{.secrets[0].name}&#39;
```

To this and it should work just the same.
Since I know go templates pretty well, this is a good alternative for jsonpath syntax.

````shell
kubectl get serviceaccount myserviceaccount --context supercoolcontext --namespace themagicalcloud -o go-template=&#39;{{range .secrets }}{{.name}}{{end}}&#39;
```

Further reading:

- [List Container images using a go-template instead of jsonpath](https://kubernetes.io/docs/tasks/access-application-cluster/list-all-running-container-images/#list-container-images-using-a-go-template-instead-of-jsonpath)

