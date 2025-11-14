FROM tomcat:9-jdk11-openjdk-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV GEOSERVER_VERSION=2.23.2
ENV GEOSERVER_DATA_DIR=/var/geoserver_data
ENV GEOSERVER_HOME=/usr/local/tomcat
ENV JAVA_OPTS="-Djava.awt.headless=true -Xms512m -Xmx2048m -XX:MaxPermSize=512m -XX:PerfDataSamplingInterval=500 -Dorg.geotools.referencing.forceXY=true"

# Download and install GeoServer
RUN curl -L -o /tmp/geoserver.zip \
    "https://sourceforge.net/projects/geoserver/files/GeoServer/${GEOSERVER_VERSION}/geoserver-${GEOSERVER_VERSION}-war.zip" \
    && unzip /tmp/geoserver.zip -d /tmp \
    && unzip /tmp/geoserver.war -d ${GEOSERVER_HOME}/webapps/geoserver \
    && rm -rf /tmp/*

# Create data directory
RUN mkdir -p ${GEOSERVER_DATA_DIR}

# Copy initialization script
COPY scripts/init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8080/geoserver/web/ || exit 1

CMD ["/usr/local/bin/init.sh"]