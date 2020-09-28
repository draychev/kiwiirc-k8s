#!/bin/bash

NAME="ing"
NAMESPACE="kiwiirc"
ingr=$(helm list -n "$NAMESPACE" -q | grep -w "$NAME" | wc -l)

if [[ "$ingr" -eq "1" ]]; then
    echo "AGIC $NAMESPACE/$NAME already installed"
else
    helm repo add application-gateway-kubernetes-ingress https://appgwingress.blob.core.windows.net/ingress-azure-helm-package/

    helm repo update

    helm uninstall "$NAME" -n kiwiirc || true

    helm install "$NAME" application-gateway-kubernetes-ingress/ingress-azure \
         --namespace "$NAMESPACE" \
         --debug \
         --set appgw.name=demo-1H20 \
         --set appgw.resourceGroup=demo-1H20 \
         --set appgw.subscriptionId=d664a618-e0fd-447e-a2cf-e0ca50ef6456 \
         --set appgw.shared=false \
         --set armAuth.type=servicePrincipal \
         --set armAuth.secretJSON=$(az ad sp create-for-rbac --sdk-auth | base64 -w0) \
         --set rbac.enabled=true \
         --set verbosityLevel=5 \
         --set kubernetes.watchNamespace=kiwiirc
fi
