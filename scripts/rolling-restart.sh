#!/bin/bash

set -aueo pipefail

# shellcheck disable=SC1091
source .env

kubectl rollout restart deployment kiwiirc -n "$KIWIIRC_NAMESPACE"
