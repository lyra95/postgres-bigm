# TL;DR;

PostgreSQL docker images with [`pg_bigm`](https://pgbigm.osdn.jp/index_en.html) installed.

`bitnami/postgresql` and `postgres` are supported.

# Before Deploying; Load pg_bigm

As in the [pg_bugm installation guide](https://pgbigm.osdn.jp/pg_bigm_en-1-2.html#install),
your `postgresql.conf` file should contains `shared_preload_libraries = pg_bigm`. However, I personally have found no issues for not doing this.

For bitnami docker images, you can set this by `POSTGRESQL_SHARED_PRELOAD_LIBRARIES` env variable.
Please refer to `Preloading shared libraries` section in https://hub.docker.com/r/bitnami/postgresql

For bitnami helm charts, you can set this by `postgresqlSharedPreloadLibraries` in your `value.yaml`.
Please refer to https://github.com/bitnami/charts/tree/main/bitnami/postgresql#postgresql-common-parameters

For official postgres images, you need to customize whole `postgresql.conf` file.
Please refer to `Database Configuration` section in https://hub.docker.com/_/postgres
