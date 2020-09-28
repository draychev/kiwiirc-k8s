#!/bin/bash

# shellcheck disable=SC1091
source .env

POD=$(kubectl get pods -n osm-system --selector app=osm-controller --no-headers | awk '{print $1}' | head -n1)

kubectl logs -n osm-system "$POD" -f
