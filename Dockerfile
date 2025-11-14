# Use Kartoza's well-maintained GeoServer image
FROM kartoza/geoserver:2.24.2

# Set Java memory options
ENV JAVA_OPTS="-Xms512m -Xmx1024m"
ENV GEOSERVER_DATA_DIR=/opt/geoserver/data_dir

EXPOSE 8080

# Use default command from Kartoza image
