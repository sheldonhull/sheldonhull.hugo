# Go R1 Day 29


## progress

- Evaluated Mage as a replacement for bash/pwsh based tasks for automation with Azure Pipelines.
- Was able to get terraform to run with dynamic configuration using the following approach:

Install with

```shell
go get -u github.com/magefile/mage/mg
go mod init mage-build
go get github.com/magefile/mage/mg
go get github.com/magefile/mage/sh
go mod tidy
```

Then to get `mage-select` run:

```shell
GO111MODULE=off go get github.com/iwittkau/mage-select
cd $GOPATH/src/github.com/iwittkau/mage-select
mage install
```

Configure some constants, which I&#39;d probably do differently later.
For now, this is a good rough start.

```go
const (
	repo          = &#34;myrepopath&#34;
	name          = &#34;myreponame&#34;
	buildImage    = &#34;mcr.microsoft.com/vscode/devcontainers/base:0-focal&#34;
	terraformDir  = &#34;terraform/stack&#34;
	config_import = &#34;qa.config&#34;
)
```

```go
func TerraformInit() error {
	params := []string{&#34;-chdir=&#34; &#43; terraformDir}
	params = append(params, &#34;init&#34;)
	params = append(params, &#34;-input=false&#34;)
	params = append(params, &#34;-var&#34;, &#34;config_import=&#34;&#43;config_import&#43;&#34;.yml&#34;)

	// Backend location configuration only changes during the init phase, so you do not need to provide this to each command thereafter
	// https://github.com/hashicorp/terraform/pull/20428#issuecomment-470674564
	params = append(params, &#34;-backend-config=./&#34;&#43;config_import&#43;&#34;.tfvars&#34;)
	fmt.Println(&#34;starting terraform init&#34;)
	err := sh.RunV(&#34;terraform&#34;, params...)
	if err != nil {
		return err
	}
	return nil
}
```

Once terraform was initialized, it could be planned.

```go
func TerraformPlan() error {
	mg.Deps(TerraformInit)
	params := []string{&#34;-chdir=&#34; &#43; terraformDir}
	params = append(params, &#34;plan&#34;)
	params = append(params, &#34;-input=false&#34;)
	params = append(params, &#34;-var&#34;, &#34;config_import=&#34;&#43;config_import&#43;&#34;.yml&#34;)
	fmt.Println(&#34;starting terraform plan&#34;)
	err := sh.RunV(&#34;terraform&#34;, params...)
	if err != nil {
		return err
	}
	return nil
}

```

- Of interest as well was mage-select, providing a new gui option for easier running by others joining a project.

![mages-select-on-console](/images/r1-d029-mages.png)

## links

- [mage](https://bit.ly/2PIuI4e)
- [mage-select](https://bit.ly/3cza7bw)

