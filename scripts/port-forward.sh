#!/bin/bash

kubectl port-forward -n $(kubectl get pods -A --no-headers --selector app=kiwiirc | awk '{print $1 " " $2}') 8888:80
