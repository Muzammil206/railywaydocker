#!/bin/bash

set -e

# Create GeoServer data directory if it doesn't exist
mkdir -p ${GEOSERVER_DATA_DIR}

# Set proper permissions
chmod -R 755 ${GEOSERVER_DATA_DIR}

# Wait for PostgreSQL to be ready (if using database)
if command -v /usr/local/bin/wait-for-db.sh &> /dev/null; then
    echo "Waiting for PostgreSQL to be ready..."
    /usr/local/bin/wait-for-db.sh
else
    echo "Wait script not found, proceeding without database wait..."
fi

echo "Starting GeoServer with Java options: $JAVA_OPTS"
exec catalina.sh run