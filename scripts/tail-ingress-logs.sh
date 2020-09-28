#!/bin/bash

# shellcheck disable=SC1091
source .env

kubectl logs -n "$KIWIIRC_NAMESPACE" --selector app=ingress-azure --tail=500 -f
