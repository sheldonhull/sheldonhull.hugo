# Azure CLI


{{&lt; admonition type=&#34;info&#34; title=&#34;Requirements&#34; &gt;}}

- Azure CLI
- [gum](https://github.com/charmbracelet/gum)

{{&lt; /admonition &gt;}}

## Azure CLI

I prefer the PowerShell module, but the azure CLI is pretty solid for those times when something with .NET just won&#39;t cooperate...

## Storage for State Files

I found the need to create storage buckets pretty important if running pulumi or terraform.
Makes sense to do this via the CLI for basic usage as it&#39;s a chicken or the egg problem.

Start with `az login`.

### Inputs

This assumes you&#39;ll place the storage account in an existing resource group.

```shell
AZURE_SUBSCRIPTION_ID=&#34;$(gum input --header &#39;Subscription ID&#39;)&#34;
az account set --subscription=&#34;${AZURE_SUBSCRIPTION_ID}&#34;
RESOURCE_GROUP_NAME=&#34;$(gum input --header &#39;Resource Group name&#39;)&#34;
STORAGE_ACCOUNT_NAME=&#34;$(gum input --header &#39;Storage Account Name (will have random suffix added)&#39;)${RANDOM}&#34;
CONTAINER_NAME=&#34;$(gum input --header &#39;Container name in the storage account&#39;)&#34;
CONTINUE=1
```

### Create the storage account

```shell
az storage account create \
    --resource-group &#34;$RESOURCE_GROUP_NAME&#34; \
    --name &#34;$STORAGE_ACCOUNT_NAME&#34; \
    --sku Standard_LRS \
    --encryption-services blob \
    --min-tls-version &#34;TLS1_2&#34;&#39;
az storage container create --name &#34;${CONTAINER_NAME}&#34; --account-name &#34;${STORAGE_ACCOUNT_NAME}&#34;
```

### Assign permissions

This is assuming the email is the principal lookup value.

```shell
PRINCIPAL_EMAIL=&#34;$(gum input --header &#39;Enter the principal email you want to give access&#39;)&#34;
PRINCIPAL_ID=&#34;$(az ad user list --query &#34;[?mail==&#39;${PRINCIPAL_EMAIL}&#39;].id&#34; -o tsv)&#34;

if [[ -z &#34;${PRINCIPAL_ID}&#34; ]]; then
    echo &#34;No user found with email: &#39;${PRINCIPAL_EMAIL}&#39;&#34;
    gum confirm &#39;continue?&#39; || CONTINUE=0
else
    CONTINUE=1
    echo &#34;👍 found user with email: &#39;${PRINCIPAL_EMAIL}&#39; and id: ${PRINCIPAL_ID}&#34;
fi

if [[ &#34;$CONTINUE&#34; -ne 1 ]]; then
    echo &#34;❌ can&#39;t continue&#34;
else
    STORAGE_ACCOUNT_ID=$(az storage account show --name &#34;${STORAGE_ACCOUNT_NAME}&#34; --resource-group &#34;${RESOURCE_GROUP_NAME}&#34; --query id --output tsv)
    echo &#34;The storage account id is ${STORAGE_ACCOUNT_ID}&#34;
    az role assignment create --assignee &#34;${PRINCIPAL_ID}&#34; --role &#34;Storage Blob Data Contributor&#34; --scope &#34;${STORAGE_ACCOUNT_ID}&#34;
fi
```

### Copy Terraform State File Up

If you need to migrate terraform storage from Terraform Cloud to azure storage, then you can jump start by grabbing the keys here:

```shell
AZURE_ACCOUNT_ID=&#34;$(az account show --subscription &#34;${AZURE_SUBSCRIPTION_ID}&#34; --query &#39;id&#39; --output tsv)&#34;
gum format &#34;AZURE_ACCOUNT_ID=&#39;${AZURE_ACCOUNT_ID}&#39;&#34;
gum format &#39;## azure storage keys, use to migrate backend if required&#39;
gum format &#39;&gt; export ARM_ACCESS_KEY=&#39;
az storage account keys list --resource-group &#34;${RESOURCE_GROUP_NAME}&#34; --account-name &#34;${STORAGE_ACCOUNT_NAME}&#34; | gum format --type code --language &#39;json&#39;

gum format &#39;### If you need to migrate your state from Terraform Cloud, try this approach&#39;
gum format --language &#39;shell&#39; --type code &lt;&lt;EOF
mkdir -p terraform.tfstate.d
terraform state pull &gt; terraform.tfstate.d/terraform.tfstate
mv .terraform/terraform.tfstate .terraform/terraform.tfstate.old
az storage blob upload \\
    --account-name &#34;${STORAGE_ACCOUNT_NAME}&#34; \\
    --container-name &#34;${CONTAINER_NAME}&#34; \\
    --name terraform.tfstate --type block \\
    --file terraform.tfstate.d/terraform.tfstate
terraform init
EOF
```

### Add Terraform Version &amp; Provider Files

Finally, update your terraform files with some pre-built snippets nicely formatted in your terminal.

```shell

gum format &#39;`## backend.tf`&#39;
gum format --type code --language=&#34;HCL2&#34; &lt;&lt;EOF
terraform {
  backend &#34;azurerm&#34; {
    resource_group_name  = &#34;${RESOURCE_GROUP_NAME}&#34;
    storage_account_name = &#34;${STORAGE_ACCOUNT_NAME}&#34;
    container_name       = &#34;${CONTAINER_NAME}&#34;
    key                  = &#34;terraform.tfstate&#34;
  }
}
EOF

gum format &#39;`## versions.tf`&#39;
gum format &#39;`# include the provider in versions.tf`&#39;
gum format --type code --language=&#34;HCL2&#34; &lt;&lt;EOF
terraform {
  required_providers {
    azurerm = {
      source  = &#34;hashicorp/azurerm&#34;
      version = &#34;3.88.0&#34;
    }
  }
}
EOF

```

