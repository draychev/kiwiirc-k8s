#!/bin/bash

# shellcheck disable=SC1091
source .env

NS_POD=$(kubectl get pods -A --no-headers --selector app=kiwiirc | awk '{print $1 " " $2}')

kubectl port-forward -n "$NS_POD" 8888:80
