#!/bin/bash

# shellcheck disable=SC1091
source .env

NAME="ing"
ingr=$(helm list -n "$KIWIIRC_NAMESPACE" -q | grep -c "$NAME")

if [[ "$ingr" -eq "1" ]]; then
    echo "AGIC ""$KIWIIRC_NAMESPACE/$NAME"" already installed"
else
    helm repo add application-gateway-kubernetes-ingress https://appgwingress.blob.core.windows.net/ingress-azure-helm-package/

    helm repo update

    helm uninstall "$NAME" -n "$KIWIIRC_NAMESPACE" || true

    SECRET_JSON=$(az ad sp create-for-rbac --sdk-auth | base64 -w0)

    helm install "$NAME" application-gateway-kubernetes-ingress/ingress-azure \
         --namespace "$KIWIIRC_NAMESPACE" \
         --debug \
         --set appgw.name=demo-1H20 \
         --set appgw.resourceGroup=demo-1H20 \
         --set appgw.subscriptionId=d664a618-e0fd-447e-a2cf-e0ca50ef6456 \
         --set appgw.shared=false \
         --set armAuth.type=servicePrincipal \
         --set armAuth.secretJSON="$SECRET_JSON" \
         --set rbac.enabled=true \
         --set verbosityLevel=5 \
         --set kubernetes.watchNamespace="$KIWIIRC_NAMESPACE"
fi
