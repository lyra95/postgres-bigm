# Base Image Should Be Debian with PostgreSQL installed
ARG IMAGE_BASE=bitnami/postgresql:14.5.0-debian-11-r15

FROM ${IMAGE_BASE} AS build

USER root
RUN apt update && apt install -y postgresql-server-dev-all make gcc libicu-dev wget checkinstall
RUN wget https://ja.osdn.net/dl/pgbigm/pg_bigm-1.2-20200228.tar.gz && tar zxf pg_bigm-1.2-20200228.tar.gz
RUN cd pg_bigm-1.2-20200228 && \
	make USE_PGXS=1 PG_CONFIG="$(which pg_config)" && \
	checkinstall -Dy --pkgname bigm --nodoc make USE_PGXS=1 PG_CONFIG="$(which pg_config)" install

FROM ${IMAGE_BASE}

ARG CONF_PATH=/opt/bitnami/postgresql/conf/postgresql.conf

COPY --from=build /pg_bigm-1.2-20200228/*.deb ./

USER root
RUN dpkg -i bigm_20200228-1_amd64.deb
RUN echo shared_preload_libraries='pg_bigm' >> $CONF_PATH
