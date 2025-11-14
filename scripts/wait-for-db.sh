#!/bin/bash

set -e

host="postgis"
port="5432"
user="geoserver"
db="geoserver"

echo "Waiting for PostgreSQL at $host:$port..."

until PGPASSWORD=geoserver psql -h "$host" -p "$port" -U "$user" -d "$db" -c '\q'; do
  >&2 echo "PostgreSQL is unavailable - sleeping"
  sleep 2
done

>&2 echo "PostgreSQL is up - continuing"