---

date: 2022-03-10T19:13:52+0000
title: Go Templates With Kubectl
slug: go-templates-with-kubectl
tags:

- tech
- development
- microblog
- go
- kubernetes

# images: [/images/]

typora-root-url: ../../../static
typora-copy-images-to:  ../../../static/images
---

An alternative to using jsonpath with kubectl is go templates!

Try switching this:

````shell
kubectl get serviceaccount myserviceaccount --context supercoolcontext --namespace themagicalcloud -o jsonpath='{.secrets[0].name}'
```

To this and it should work just the same.
Since I know go templates pretty well, this is a good alternative for jsonpath syntax.

````shell
kubectl get serviceaccount myserviceaccount --context supercoolcontext --namespace themagicalcloud -o go-template='{{range .secrets }}{{.name}}{{end}}'
```

Further reading:

- [List Container images using a go-template instead of jsonpath](https://kubernetes.io/docs/tasks/access-application-cluster/list-all-running-container-images/#list-container-images-using-a-go-template-instead-of-jsonpath)
