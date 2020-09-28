#!/bin/bash

set -aueo pipefail

# shellcheck disable=SC1091
source .env

osm namespace add "$KIWIIRC_NAMESPACE" --mesh-name "${MESH_NAME:-osm}" --enable-sidecar-injection


kubectl apply -f - <<EOF
apiVersion: v1
kind: ConfigMap

metadata:
  name: osm-config
  namespace: osm-system

data:
  permissive_traffic_policy_mode: "true"

EOF


sleep 3


./scripts/rolling-restart.sh
