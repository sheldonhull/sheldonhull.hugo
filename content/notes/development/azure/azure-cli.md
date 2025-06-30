---
title: Azure CLI
date: 2024-03-11T16:45:00
tags:
  - azure
lastmod: 2024-03-11T16:45:00
toc: true
layout: wide
---


> [!info] Requirements
>
> - Azure CLI
> - [gum](https://github.com/charmbracelet/gum)



## Azure CLI

I prefer the PowerShell module, but the azure CLI is pretty solid for those times when something with .NET just won't cooperate...

## Storage for State Files

I found the need to create storage buckets pretty important if running pulumi or terraform.
Makes sense to do this via the CLI for basic usage as it's a chicken or the egg problem.

Start with `az login`.

### Inputs

This assumes you'll place the storage account in an existing resource group.

```shell
AZURE_SUBSCRIPTION_ID="$(gum input --header 'Subscription ID')"
az account set --subscription="${AZURE_SUBSCRIPTION_ID}"
RESOURCE_GROUP_NAME="$(gum input --header 'Resource Group name')"
STORAGE_ACCOUNT_NAME="$(gum input --header 'Storage Account Name (will have random suffix added)')${RANDOM}"
CONTAINER_NAME="$(gum input --header 'Container name in the storage account')"
CONTINUE=1
```

### Create the storage account

```shell
az storage account create \
    --resource-group "$RESOURCE_GROUP_NAME" \
    --name "$STORAGE_ACCOUNT_NAME" \
    --sku Standard_LRS \
    --encryption-services blob \
    --min-tls-version "TLS1_2"'
az storage container create --name "${CONTAINER_NAME}" --account-name "${STORAGE_ACCOUNT_NAME}"
```

### Assign permissions

This is assuming the email is the principal lookup value.

```shell
PRINCIPAL_EMAIL="$(gum input --header 'Enter the principal email you want to give access')"
PRINCIPAL_ID="$(az ad user list --query "[?mail=='${PRINCIPAL_EMAIL}'].id" -o tsv)"

if [[ -z "${PRINCIPAL_ID}" ]]; then
    echo "No user found with email: '${PRINCIPAL_EMAIL}'"
    gum confirm 'continue?' || CONTINUE=0
else
    CONTINUE=1
    echo "👍 found user with email: '${PRINCIPAL_EMAIL}' and id: ${PRINCIPAL_ID}"
fi

if [[ "$CONTINUE" -ne 1 ]]; then
    echo "❌ can't continue"
else
    STORAGE_ACCOUNT_ID=$(az storage account show --name "${STORAGE_ACCOUNT_NAME}" --resource-group "${RESOURCE_GROUP_NAME}" --query id --output tsv)
    echo "The storage account id is ${STORAGE_ACCOUNT_ID}"
    az role assignment create --assignee "${PRINCIPAL_ID}" --role "Storage Blob Data Contributor" --scope "${STORAGE_ACCOUNT_ID}"
fi
```

### Copy Terraform State File Up

If you need to migrate terraform storage from Terraform Cloud to azure storage, then you can jump start by grabbing the keys here:

```shell
AZURE_ACCOUNT_ID="$(az account show --subscription "${AZURE_SUBSCRIPTION_ID}" --query 'id' --output tsv)"
gum format "AZURE_ACCOUNT_ID='${AZURE_ACCOUNT_ID}'"
gum format '## azure storage keys, use to migrate backend if required'
gum format '> export ARM_ACCESS_KEY='
az storage account keys list --resource-group "${RESOURCE_GROUP_NAME}" --account-name "${STORAGE_ACCOUNT_NAME}" | gum format --type code --language 'json'

gum format '### If you need to migrate your state from Terraform Cloud, try this approach'
gum format --language 'shell' --type code <<EOF
mkdir -p terraform.tfstate.d
terraform state pull > terraform.tfstate.d/terraform.tfstate
mv .terraform/terraform.tfstate .terraform/terraform.tfstate.old
az storage blob upload \\
    --account-name "${STORAGE_ACCOUNT_NAME}" \\
    --container-name "${CONTAINER_NAME}" \\
    --name terraform.tfstate --type block \\
    --file terraform.tfstate.d/terraform.tfstate
terraform init
EOF
```

### Add Terraform Version & Provider Files

Finally, update your terraform files with some pre-built snippets nicely formatted in your terminal.

```shell

gum format '`## backend.tf`'
gum format --type code --language="HCL2" <<EOF
terraform {
  backend "azurerm" {
    resource_group_name  = "${RESOURCE_GROUP_NAME}"
    storage_account_name = "${STORAGE_ACCOUNT_NAME}"
    container_name       = "${CONTAINER_NAME}"
    key                  = "terraform.tfstate"
  }
}
EOF

gum format '`## versions.tf`'
gum format '`# include the provider in versions.tf`'
gum format --type code --language="HCL2" <<EOF
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.88.0"
    }
  }
}
EOF

```
