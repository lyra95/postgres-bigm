SHELL:=/bin/bash

TARGET=
BASE=
TAG=
NEW_TAG=

.PHONY: build
build: check-args
	docker build --target="$(TARGET)" --build-arg IMAGE_BASE="$(BASE):$(TAG)" -f Dockerfile . -t "lyra95/postgres-bigm:$(NEW_TAG)"

.PHONY: run 
run: check-args
	docker run --name test -dp 5432:5432 -e POSTGRESQL_PASSWORD=1234 -e POSTGRES_PASSWORD=1234 "lyra95/postgres-bigm:$(NEW_TAG)"

.PHONY: push
push: check-args
	docker push "lyra95/postgres-bigm:$(NEW_TAG)"

.PHONY: test
test: check-args
	docker exec -e PGPASSWORD=1234 test psql --username=postgres --no-password --dbname=postgres -c "CREATE EXTENSION pg_bigm;"
	docker exec -e PGPASSWORD=1234 test psql --username=postgres --no-password --dbname=postgres -c "\dx" | grep -q pg_bigm

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
