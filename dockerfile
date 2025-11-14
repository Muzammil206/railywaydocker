# GeoServer Dockerfile for Railway
FROM tomcat:9-jdk11-openjdk-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV GEOSERVER_VERSION=2.23.2
ENV GEOSERVER_DATA_DIR=/geoserver_data
ENV JAVA_OPTS="-Djava.awt.headless=true -Xms512m -Xmx1024m -XX:MaxPermSize=256m -Dorg.geotools.referencing.forceXY=true"

# Download and install GeoServer
RUN curl -L -o /tmp/geoserver.zip \
    "https://sourceforge.net/projects/geoserver/files/GeoServer/${GEOSERVER_VERSION}/geoserver-${GEOSERVER_VERSION}-war.zip" \
    && unzip /tmp/geoserver.zip -d /tmp \
    && unzip /tmp/geoserver.war -d /usr/local/tomcat/webapps/geoserver \
    && rm -rf /tmp/*

# Create data directory
RUN mkdir -p ${GEOSERVER_DATA_DIR}

# Expose port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]