# Go R1 Day 3


## Day 3 of 100

## progress

- Learned about GOROOT, GOPATH and how to configure
- Ran into problems with Visual Studio code reporting:

```text
Failed to find the &#34;go&#34; binary in either GOROOT() or PATH(/usr/bin:/bin:/usr/sbin:/sbin. Check PATH, or Install Go and reload the window.
```

- After attempting solution with various profile files, I tried setting the setting: `&#34;go.goroot&#34;: &#34;/usr/local/opt/go/libexec/&#34;,` in `settings.json` and this resolved the issue.
- After it recognized this, I ran the `Go: Current GOPATH` from the command palette and it found it.
- Finally, after this it reporting back some feedback showing it was recognizing the latest version I was running.
- Initialized a new serverless framework project for `aws-go-mod` template using the following command: `serverless create --template aws-go-mod --path ./sqlserver` and the initial project layout was created.
- I&#39;m sure this will need to be improved as I go along, but since macOS failed on the go path setup, this resolved my problems for now.

```powershell

# GO: Make tools work in console sessions
$ENV:GOPATH = &#34;$ENV:HOME$($ENV:USERPROFILE)/go&#34;

if ($PSVersionTable.OS -match &#39;Darwin&#39;) {
    $ENV:GOROOT = &#34;/usr/local/opt/go/libexec&#34;
    $ENV:PATH &#43;= &#34;$ENV:PATH:$(go env GOPATH)/bin&#34;
    $ENV:GOBIN = &#34;$(go env GOPATH)/bin&#34;
}

```

## links

- [serverless aws-go-mod](https://www.serverless.com/framework/docs/providers/aws/examples/hello-world/go/)
- [serverless aws-go-mod github](https://github.com/serverless/serverless/tree/master/lib/plugins/create/templates/aws-go-mod)

