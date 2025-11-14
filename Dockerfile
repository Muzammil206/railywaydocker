# Simple GeoServer on Tomcat - WORKING VERSION
FROM tomcat:9-jdk11-openjdk-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV JAVA_OPTS="-Djava.awt.headless=true -Xms512m -Xmx1024m -XX:MaxPermSize=256m"
ENV GEOSERVER_DATA_DIR=/geoserver_data

# Download and install GeoServer 2.24.2
RUN wget -O /tmp/geoserver.zip \
    "https://downloads.sourceforge.net/project/geoserver/GeoServer/2.24.2/geoserver-2.24.2-war.zip" && \
    unzip /tmp/geoserver.zip -d /tmp && \
    unzip /tmp/geoserver.war -d /usr/local/tomcat/webapps/geoserver && \
    rm -rf /tmp/*

# Create data directory
RUN mkdir -p ${GEOSERVER_DATA_DIR}

# Expose port
EXPOSE 8080

# Simple startup
CMD ["catalina.sh", "run"]
