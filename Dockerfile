# Base Image Should Be Debian with PostgreSQL installed
ARG IMAGE_BASE

FROM ${IMAGE_BASE} AS build

USER root
RUN apt update && apt install -y postgresql-server-dev-all make gcc libicu-dev wget checkinstall
RUN wget https://ja.osdn.net/dl/pgbigm/pg_bigm-1.2-20200228.tar.gz && tar zxf pg_bigm-1.2-20200228.tar.gz
RUN cd pg_bigm-1.2-20200228 && \
	make USE_PGXS=1 PG_CONFIG="$(which pg_config)" && \
	checkinstall -Dy --pkgname bigm --nodoc make USE_PGXS=1 PG_CONFIG="$(which pg_config)" install

FROM ${IMAGE_BASE} AS base

COPY --from=build /pg_bigm-1.2-20200228/*.deb ./

USER root
RUN dpkg -i bigm_20200228-1_amd64.deb

FROM base AS bitnami

USER root
RUN mkdir -p /docker-entrypoint-initdb.d
COPY init-db/bitnami/load-bigm.sh /docker-entrypoint-initdb.d/

FROM base AS official

USER root
RUN cp /usr/share/postgresql/postgresql.conf.sample /usr/share/postgresql/postgresql.conf && \
    echo shared_preload_libraries = 'pg_bigm' >> /usr/share/postgresql/postgresql.conf && \
    chmod 444 /usr/share/postgresql/postgresql.conf

CMD [ "postgres", "-c", "config_file=/usr/share/postgresql/postgresql.conf" ]

