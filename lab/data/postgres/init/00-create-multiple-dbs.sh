#!/bin/bash
# 00-create-multiple-dbs.sh — Crea bases de datos adicionales
# Postgres nativo: POSTGRES_DB crea una BD.
# Esta extensión lee POSTGRES_MULTIPLE_DATABASES y crea las adicionales.

set -e

function create_database() {
	local database=$1
	echo "  Creating database '$database'"
	psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" -d postgres <<-EOSQL
	    CREATE DATABASE "$database";
EOSQL
}

if [ -n "$POSTGRES_MULTIPLE_DATABASES" ]; then
	echo "Multiple database creation requested: $POSTGRES_MULTIPLE_DATABASES"
	for db in $(echo "$POSTGRES_MULTIPLE_DATABASES" | tr ',' ' '); do
		create_database "$db"
	done
	echo "Multiple databases created"
fi
