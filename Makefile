#!make

include .env

.DEFAULT_GOAL := deploy

SHELL := bash -o pipefail

check-env:
ifndef CTR_REGISTRY
	$(error CTR_REGISTRY environment variable is not defined; see the .env.example file for more information; then source .env)
endif
ifndef CTR_TAG
	$(error CTR_TAG environment variable is not defined; see the .env.example file for more information; then source .env)
endif

.PHONY: docker-build-push
docker-build-push: check-env
	docker build -t $(CTR_REGISTRY)/kiwiirc:$(CTR_TAG) .
	docker push "$(CTR_REGISTRY)/kiwiirc:$(CTR_TAG)" || { echo "Error pushing images to container registry $(CTR_REGISTRY)/kiwiirc:$(CTR_TAG)"; exit 1; }

.PHONY: deploy
deploy: docker-build-push
	./scripts/deploy-kiwiirc.sh

.PHONY: install-agic
install-agic:
	./scripts/install-agic.sh

.PHONY: join-mesh
join-mesh:
	./scripts/join-namespaces.sh

.PHONY: all
all: deploy install-agic join-mesh

.PHONY: shellcheck
shellcheck:
	shellcheck -x $(shell find . -name '*.sh')
