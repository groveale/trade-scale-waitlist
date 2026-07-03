# Azure Provisioning (Static Web App)

This folder contains Azure CLI scripts to provision the Azure resources for this Astro waitlist.

Custom domain setup is intentionally **not** included.

## Prerequisites

- Azure CLI installed
- Logged in: `az login`
- Correct subscription selected: `az account set --subscription "<subscription-id-or-name>"`

## 1) Create Azure resources

```bash
chmod +x deployment/azure/*.sh

APP_NAME=trade-scale-waitlist \
RESOURCE_GROUP=trade-scale-waitlist-rg \
LOCATION=uksouth \
SKU=Free \
./deployment/azure/01-create-static-web-app.sh
```

What this does:
- Creates (or updates) the resource group
- Creates the Static Web App (if it does not already exist)
- Prints the default Azure hostname

## 2) Optional: use native GitHub integration (recommended)

If you want Azure Static Web Apps to set up and manage deployment workflow automatically, create the app with repo integration:

```bash
APP_NAME=trade-scale-waitlist \
RESOURCE_GROUP=trade-scale-waitlist-rg \
LOCATION=uksouth \
SKU=Free \
GITHUB_SOURCE=https://github.com/<org-or-user>/<repo> \
GITHUB_BRANCH=main \
./deployment/azure/01-create-static-web-app.sh
```

This path usually means you do not need a deployment token script.

## 3) Optional: get deployment token (only for custom Actions workflows)

```bash
APP_NAME=trade-scale-waitlist \
RESOURCE_GROUP=trade-scale-waitlist-rg \
./deployment/azure/02-get-deploy-token.sh
```

Use the returned value in GitHub Actions as:
- `AZURE_STATIC_WEB_APPS_API_TOKEN`

## Notes

- Script is idempotent for resource creation.
- `02-get-deploy-token.sh` is only needed when you are using a custom CI workflow.
- Domain and DNS setup are handled manually outside this folder.
