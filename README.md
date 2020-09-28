# OSM Demo: Web IRC Client (KiwiIRC)

This is a demo of [Open Service Mesh](https://openservicemesh.io/),
which installs the [Kiwi IRC](https://kiwiirc.com/) [client](https://github.com/kiwiirc/kiwiirc).
The Docker image in this repo is based on the [Dockerfile originally created by @chesty](https://github.com/chesty/docker-kiwiirc).

This repo relies on a `Makefile` and quite a few bash scripts in `./scripts` directory.

## Steps
1. Setup required environment variables in `.env`. Copy `.env.example` into `.env` and modify `.env` for your environment.
  ```sh
  cat .env.example > .env
  ```
2. Create a container registry, such as [Azure Container Registry](https://azure.microsoft.com/en-us/services/container-registry/) and authenticate with it:
  ```sh
  az acr login --name osmci
  ```
3. Create the Docker image for the KiwiIRC pod: `make docker-build-push`
4. Deploy the newly created Docker containers:
   ```sh
   make deploy
   ```
   This will create:
       - Kubernetes Service Account
       - Kubernetes Service
       - Ingress Resource

5. Install [App Gateway Ingress Controller (AGIC)](https://github.com/Azure/application-gateway-kubernetes-ingress): `./scripts/install-agic.sh`
    1. Alternatively AGIC can be easily [enabled as an AKS add-on](https://docs.microsoft.com/en-us/azure/application-gateway/tutorial-ingress-controller-add-on-new)
6. Enable [Let's Encrypt](https://letsencrypt.org/): `./scripts/enable-letsencrypt.sh`
7. See the logs of the KiwiIRC container: `./scripts/tail-logs.sh`
8. See the logs of the App Gateway Ingres Controller: `./scripts/tail-ingress-logs.sh`
