#!/bin/bash

set -aueo pipefail

# shellcheck disable=SC1091
source .env


K8S_NAMESPACE="${K8S_NAMESPACE:-osm-system}"

osm namespace remove "$KIWIIRC_NAMESPACE" --mesh-name "${MESH_NAME:-osm}"

kubectl apply -f - <<EOF
apiVersion: v1
kind: ConfigMap

metadata:
  name: osm-config
  namespace: $K8S_NAMESPACE

data:

  permissive_traffic_policy_mode: "true"

EOF


./scripts/rolling-restart.sh
