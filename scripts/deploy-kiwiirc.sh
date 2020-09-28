#!/bin/bash

set -aueo pipefail

# shellcheck disable=SC1091
source .env
ENABLE_EGRESS="${ENABLE_EGRESS:-false}"
NAMESPACE=kiwiirc

# kubectl delete namespace kiwiirc --ignore-not-found
kubectl create namespace kiwiirc || true

kubectl delete deployment kiwiirc -n kiwiirc  --ignore-not-found

./scripts/create-container-registry-creds.sh $NAMESPACE

echo -e "Deploy KiwiIRC Service Account"
kubectl apply -f - <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: kiwiirc
  namespace: $NAMESPACE
EOF

echo -e "Deploy KiwiIRC Service"
kubectl delete service -n "$NAMESPACE" kiwiirc --ignore-not-found
kubectl apply -f - <<EOF
apiVersion: v1
kind: Service
metadata:
  name: kiwiirc
  namespace: $NAMESPACE
  labels:
    app: kiwiirc
spec:
  ports:
  - port: 80
    name: web
  selector:
    app: kiwiirc
EOF

echo -e "Deploy KiwiIRC Deployment"
kubectl delete deployment -n "$NAMESPACE" kiwiirc --ignore-not-found
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: kiwiirc
  namespace: $NAMESPACE
spec:
  replicas: 1
  selector:
    matchLabels:
      app: kiwiirc
  template:
    metadata:
      labels:
        app: kiwiirc
        version: v1
    spec:
      serviceAccountName: kiwiirc

      containers:
        # Main container with APP
        - name: kiwiirc
          image: osmci.azurecr.io/delyan-osm-a/kiwiirc:latest
          imagePullPolicy: Always

      imagePullSecrets:
        - name: "$CTR_REGISTRY_CREDS_NAME"
EOF


echo "Create KiwiIRC Ingress Resource"
kubectl apply -f - <<EOF
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: kiwiirc
  namespace: $NAMESPACE
  annotations:
    kubernetes.io/ingress.class: azure/application-gateway
spec:
  rules:
  - host: "kiwi.mis.li"
    http:
      paths:
      - path: /
        backend:
          serviceName: kiwiirc
          servicePort: 80
EOF


kubectl get pods      --no-headers -o wide --selector app=kiwiirc -n "$NAMESPACE"
kubectl get endpoints --no-headers -o wide --selector app=kiwiirc -n "$NAMESPACE"
kubectl get service                -o wide                        -n "$NAMESPACE"

for x in $(kubectl get service -n "$NAMESPACE" --selector app=kiwiirc --no-headers | awk '{print $1}'); do
    kubectl get service "$x" -n "$NAMESPACE" -o jsonpath='{.status.loadBalancer.ingress[*].ip}'
done
