#!/usr/bin/env bash
set -euo pipefail

# Provisions the Azure resources needed for this static waitlist site.
# Domain binding is intentionally excluded.

APP_NAME="${APP_NAME:-trade-scale-waitlist}"
RESOURCE_GROUP="${RESOURCE_GROUP:-${APP_NAME}-rg}"
LOCATION="${LOCATION:-uksouth}"
SKU="${SKU:-Free}"
TAGS="${TAGS:-project=trade-scale-waitlist env=prod}"
GITHUB_SOURCE="${GITHUB_SOURCE:-}"
GITHUB_BRANCH="${GITHUB_BRANCH:-main}"

usage() {
  cat <<'EOF'
Usage:
  APP_NAME=<static-web-app-name> \
  RESOURCE_GROUP=<resource-group-name> \
  LOCATION=<azure-region> \
  SKU=<Free|Standard|Dedicated> \
  GITHUB_SOURCE=<https://github.com/groveale/repo> \
  GITHUB_BRANCH=<branch-name> \
  ./deployment/azure/01-create-static-web-app.sh

Defaults:
  APP_NAME=trade-scale-waitlist
  RESOURCE_GROUP=<APP_NAME>-rg
  LOCATION=uksouth
  SKU=Free

Notes:
  - This script creates only Azure resources (no custom domain setup).
  - Optional: set GITHUB_SOURCE (+ GITHUB_BRANCH) to configure native SWA GitHub integration.
  - Run 'az login' first.
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

if ! command -v az >/dev/null 2>&1; then
  echo "Azure CLI not found. Install from: https://aka.ms/installazurecliosx"
  exit 1
fi

if ! az account show >/dev/null 2>&1; then
  echo "Not logged in. Run: az login"
  exit 1
fi

echo "Using subscription: $(az account show --query name -o tsv)"
echo "Ensuring resource group '$RESOURCE_GROUP' in '$LOCATION'..."
az group create \
  --name "$RESOURCE_GROUP" \
  --location "$LOCATION" \
  --tags $TAGS \
  --output none

if az staticwebapp show --name "$APP_NAME" --resource-group "$RESOURCE_GROUP" >/dev/null 2>&1; then
  echo "Static Web App '$APP_NAME' already exists in '$RESOURCE_GROUP'."
else
  echo "Creating Static Web App '$APP_NAME' (SKU: $SKU)..."
  if [[ -n "$GITHUB_SOURCE" ]]; then
    echo "Configuring native GitHub integration for '$GITHUB_SOURCE' on branch '$GITHUB_BRANCH'..."
    az staticwebapp create \
      --name "$APP_NAME" \
      --resource-group "$RESOURCE_GROUP" \
      --location "$LOCATION" \
      --sku "$SKU" \
      --source "$GITHUB_SOURCE" \
      --branch "$GITHUB_BRANCH" \
      --login-with-github \
      --tags $TAGS \
      --output none
  else
    az staticwebapp create \
      --name "$APP_NAME" \
      --resource-group "$RESOURCE_GROUP" \
      --location "$LOCATION" \
      --sku "$SKU" \
      --tags $TAGS \
      --output none
  fi
fi

DEFAULT_HOSTNAME=$(az staticwebapp show \
  --name "$APP_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --query defaultHostname \
  --output tsv)

echo ""
echo "Provisioning complete."
echo "Static Web App: $APP_NAME"
echo "Resource Group: $RESOURCE_GROUP"
echo "Default URL: https://$DEFAULT_HOSTNAME"
echo ""
if [[ -n "$GITHUB_SOURCE" ]]; then
  echo "Next: push to '$GITHUB_BRANCH' to trigger the auto-created GitHub Action workflow."
else
  echo "Optional next step: run ./deployment/azure/02-get-deploy-token.sh if using a custom GitHub Actions workflow."
fi
