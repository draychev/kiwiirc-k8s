#!/bin/bash



# This script performs a rolling restart of the deployments listed below.
# This is part of the OSM Bookstore demo helper scripts.



set -aueo pipefail

# shellcheck disable=SC1091
source .env

NAMESPACE=kiwiirc

kubectl rollout restart deployment kiwiirc -n "$NAMESPACE"
