#!/bin/bash

kubectl exec -it -n $(kubectl get pods -A --no-headers --selector app=kiwiirc | awk '{print $1 " " $2}') sh
