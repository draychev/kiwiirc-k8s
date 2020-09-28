#!/bin/bash



# This script joins the list of namespaces to the existing service mesh.
# This is a helper script part of brownfield OSM demo.



set -aueo pipefail

# shellcheck disable=SC1091
source .env

NAMESPACE=kiwiirc

osm namespace add "${NAMESPACE}"         --mesh-name "${MESH_NAME:-osm}" --enable-sidecar-injection


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


./rolling-restart.sh
