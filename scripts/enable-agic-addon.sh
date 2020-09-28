#!/bin/bash

# This script install App Gateway Ingress Controller as an AKS add-on

AKS_CLUSTER_NAME="demo-1h20"
RESOURCE_GROUP="demo-1h20"
APP_GW_NAME="demo-1H20"

APP_GW=$(az network application-gateway show -n "$APP_GW_NAME" -g "$RESOURCE_GROUP" -o tsv --query "id")

echo "Application Gateway: $APP_GW"

az feature register --name AKS-IngressApplicationGatewayAddon --namespace Microsoft.ContainerService

az feature list -o table --query "[?contains(name, 'Microsoft.ContainerService/AKS-IngressApplicationGatewayAddon')].{Name:name,State:properties.state}"

az provider register --namespace Microsoft.ContainerService

az extension add --name aks-preview
az extension list

az aks enable-addons -n "$AKS_CLUSTER_NAME" -g "$RESOURCE_GROUP" -a ingress-appgw --appgw-id "$APP_GW"
