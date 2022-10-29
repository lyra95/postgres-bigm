SHELL:=/bin/bash

BASE=
TAG=
NEW_TAG=
POSTGRESQL_BUILD_PKG_VERSION ?= all
ARCH=

.PHONY: build
build: check-args
	docker buildx build \
		--build-arg IMAGE_BASE="$(BASE):$(TAG)" \
		--build-arg POSTGRESQL_BUILD_PKG_VERSION="$(POSTGRESQL_BUILD_PKG_VERSION)" \
		-f Dockerfile . \
		-t "lyra95/postgres-bigm:$(NEW_TAG)" \
		--platform "$(ARCH)"

.PHONY: push
push: check-args
	docker buildx build \
		--build-arg IMAGE_BASE="$(BASE):$(TAG)" \
		--build-arg POSTGRESQL_BUILD_PKG_VERSION="$(POSTGRESQL_BUILD_PKG_VERSION)" \
		-f Dockerfile . \
		-t "lyra95/postgres-bigm:$(NEW_TAG)" \
		--platform "$(ARCH)" \
		--push

.PHONY: check-args
check-args:
	@if [ -z "$(BASE)" ]; then\
		exit 1;\
	elif [ -z "$(TAG)" ]; then\
		exit 1;\
	elif [ -z "$(NEW_TAG)" ]; then\
		exit 1;\
	elif [ -z "$(ARCH)" ]; then\
		exit 1;\
	fi

lint:
	npx dprint check
	npx prettier -c .

fmt:
	npx dprint fmt
	npx prettier -w .
