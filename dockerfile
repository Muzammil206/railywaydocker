FROM tomcat:9-jdk11-openjdk-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV GEOSERVER_VERSION=2.23.2
ENV GEOSERVER_DATA_DIR=/var/geoserver_data
ENV GEOSERVER_HOME=/usr/local/tomcat
ENV JAVA_OPTS="-Djava.awt.headless=true -Xms512m -Xmx1024m -XX:MaxPermSize=256m -Dorg.geotools.referencing.forceXY=true"

# Download and install GeoServer
RUN curl -L -o /tmp/geoserver.zip \
    "https://sourceforge.net/projects/geoserver/files/GeoServer/${GEOSERVER_VERSION}/geoserver-${GEOSERVER_VERSION}-war.zip" \
    && unzip /tmp/geoserver.zip -d /tmp \
    && unzip /tmp/geoserver.war -d ${GEOSERVER_HOME}/webapps/geoserver \
    && rm -rf /tmp/*

# Download PostGIS JDBC driver
RUN curl -L -o ${GEOSERVER_HOME}/webapps/geoserver/WEB-INF/lib/postgresql-42.6.0.jar \
    "https://jdbc.postgresql.org/download/postgresql-42.6.0.jar"

# Create data directory
RUN mkdir -p ${GEOSERVER_DATA_DIR}

# Copy initialization scripts
COPY scripts/init.sh /usr/local/bin/init.sh
COPY scripts/wait-for-db.sh /usr/local/bin/wait-for-db.sh
RUN chmod +x /usr/local/bin/init.sh /usr/local/bin/wait-for-db.sh

# Expose port
EXPOSE 8080

CMD ["/usr/local/bin/init.sh"]