# Use official GeoServer image - MOST RELIABLE OPTION
FROM docker.io/geoserver/geoserver:2.23.2

# Set Java memory options optimized for Railway
ENV JAVA_OPTS="-Djava.awt.headless=true -Xms512m -Xmx1024m -XX:MaxPermSize=256m -Dorg.geotools.referencing.forceXY=true"
ENV GEOSERVER_DATA_DIR=/geoserver_data

# Create data directory
RUN mkdir -p ${GEOSERVER_DATA_DIR}

# Expose GeoServer port
EXPOSE 8080

# Use the default command from official image (already optimized)
