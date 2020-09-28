#!/bin/bash

kubectl logs -n kiwiirc --selector app=ingress-azure --tail=500 -f
