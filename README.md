# Meshed IRC Client (Kiwi)

This demo uses the [Kiwi IRC](https://kiwiirc.com/) [client](https://github.com/kiwiirc/kiwiirc). The Docker container in this repo is based on the [Dockerfile originally created by @chesty](https://github.com/chesty/docker-kiwiirc).

Enable App Gateway Ingress Controller:
```sh
az feature register --name AKS-IngressApplicationGatewayAddon --namespace Microsoft.ContainerService
```

1. Setup required environment variables in .env. See .env.example.
2. Create a container registry. Log-in to it: `az acr login --name osmci`
3. Create the Docker image for the KiwiIRC pod: `make docker-build-push`
4. Deploy the newly created Docker containers: `make deploy`
5. Install [App Gateway Ingress Controller (AGIC)](https://github.com/Azure/application-gateway-kubernetes-ingress): `./scripts/install-agic.sh`
5. See the logs of the KiwiIRC container: `./scripts/tail-logs.sh`
6. See the logs of the App Gateway Ingres Controller: `./scripts/tail-ingress-logs.sh`
