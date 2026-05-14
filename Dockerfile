# Base Image Should Be Debian with PostgreSQL installed
ARG IMAGE_BASE
FROM ${IMAGE_BASE} AS build

USER root
ARG POSTGRESQL_BUILD_PKG_VERSION=all
ARG PGBIGM_VERSION=1.2-20250903
RUN apt update && apt install -y postgresql-server-dev-${POSTGRESQL_BUILD_PKG_VERSION} make gcc libicu-dev wget checkinstall
RUN wget https://github.com/pgbigm/pg_bigm/archive/refs/tags/v${PGBIGM_VERSION}.tar.gz && tar zxf v${PGBIGM_VERSION}.tar.gz
RUN cd pg_bigm-${PGBIGM_VERSION} && \
	make USE_PGXS=1 PG_CONFIG="$(which pg_config)" && \
	checkinstall -Dy --pkgname bigm --fstrans=no --nodoc make USE_PGXS=1 PG_CONFIG="$(which pg_config)" install

FROM ${IMAGE_BASE}

ARG PGBIGM_VERSION=1.2-20250903
COPY --from=build /pg_bigm-${PGBIGM_VERSION}/*.deb ./

USER root
RUN dpkg -i bigm_*.deb
