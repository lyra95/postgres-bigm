# Base Image Should Be Debian with PostgreSQL installed
ARG IMAGE_BASE
FROM ${IMAGE_BASE} AS build

USER root
ARG POSTGRESQL_BUILD_PKG_VERSION=all
RUN apt update && apt install -y postgresql-server-dev-${POSTGRESQL_BUILD_PKG_VERSION} make gcc libicu-dev wget checkinstall
RUN wget https://ja.osdn.net/dl/pgbigm/pg_bigm-1.2-20200228.tar.gz && tar zxf pg_bigm-1.2-20200228.tar.gz
RUN cd pg_bigm-1.2-20200228 && \
	make USE_PGXS=1 PG_CONFIG="$(which pg_config)" && \
	checkinstall -Dy --pkgname bigm --nodoc make USE_PGXS=1 PG_CONFIG="$(which pg_config)" install

FROM ${IMAGE_BASE}

COPY --from=build /pg_bigm-1.2-20200228/*.deb ./

USER root
RUN dpkg -i bigm_*.deb
