#!/bin/bash

set -e

# Create GeoServer data directory if it doesn't exist
mkdir -p ${GEOSERVER_DATA_DIR}

# Set proper permissions
chmod -R 755 ${GEOSERVER_DATA_DIR}

# Wait for Tomcat to start
echo "Starting GeoServer..."

# Start Tomcat
exec catalina.sh run