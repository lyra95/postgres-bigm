SHELL:=/bin/bash

TARGET=
BASE=
TAG=
NEW_TAG=

.PHONY: build
build: check-args
	docker build --target="$(TARGET)" --build-arg IMAGE_BASE="$(BASE):$(TAG)" -f Dockerfile . -t "lyra95/postgres-bigm:$(NEW_TAG)"

.PHONY: push
push: check-args
	docker push "lyra95/postgres-bigm:$(NEW_TAG)"

.PHONY: check-args
check-args:
	@if [ -z "$(BASE)" ]; then\
		exit 1;\
	elif [ -z "$(TAG)" ]; then\
		exit 1;\
	elif [ -z "$(NEW_TAG)" ]; then\
		exit 1;\
	elif [ -z "$(TARGET)" ]; then\
		exit 1;\
	fi

lint:
	npx dprint check
	npx prettier -c .

fmt:
	npx dprint fmt
	npx prettier -w .
