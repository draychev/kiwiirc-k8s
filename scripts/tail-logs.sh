#!/bin/bash

# shellcheck disable=SC1091
source .env

POD=$(kubectl get pods --no-headers --selector app=kiwiirc -n "$KIWIIRC_NAMESPACE" | awk '{print $1}')

kubectl logs -n "$KIWIIRC_NAMESPACE" "$POD" -f
