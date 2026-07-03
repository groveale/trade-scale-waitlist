#!/usr/bin/env bash
set -euo pipefail

# Retrieves the deployment token for GitHub Actions or other CI/CD use.

APP_NAME="${APP_NAME:-trade-scale-waitlist}"
RESOURCE_GROUP="${RESOURCE_GROUP:-${APP_NAME}-rg}"

usage() {
  cat <<'EOF'
Usage:
  APP_NAME=<static-web-app-name> \
  RESOURCE_GROUP=<resource-group-name> \
  ./deployment/azure/02-get-deploy-token.sh

Defaults:
  APP_NAME=trade-scale-waitlist
  RESOURCE_GROUP=<APP_NAME>-rg
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

TOKEN=$(az staticwebapp secrets list \
  --name "$APP_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --query properties.apiKey \
  --output tsv)

echo ""
echo "Deployment token for '$APP_NAME':"
echo "$TOKEN"
echo ""
echo "Store this in GitHub Actions as AZURE_STATIC_WEB_APPS_API_TOKEN."
