# GeoServer on Tomcat - MEMORY OPTIMIZED
FROM tomcat:9-jdk11-openjdk-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Set optimized memory settings for Railway
ENV JAVA_OPTS="-Djava.awt.headless=true -Xms256m -Xmx512m -XX:MaxMetaspaceSize=256m -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -XX:+DisableExplicitGC"
ENV CATALINA_OPTS="-Xms256m -Xmx512m"
ENV GEOSERVER_DATA_DIR=/geoserver_data

# Download and install GeoServer 2.24.2
RUN wget -O /tmp/geoserver.zip \
    "https://downloads.sourceforge.net/project/geoserver/GeoServer/2.24.2/geoserver-2.24.2-war.zip" && \
    unzip /tmp/geoserver.zip -d /tmp && \
    unzip /tmp/geoserver.war -d /usr/local/tomcat/webapps/geoserver && \
    rm -rf /tmp/*

# Disable GeoWebCache to save memory (optional - remove if you need caching)
RUN sed -i 's/<enabled>true<\/enabled>/<enabled>false<\/enabled>/' /usr/local/tomcat/webapps/geoserver/data/gwc-gs.xml 2>/dev/null || true

# Create data directory
RUN mkdir -p ${GEOSERVER_DATA_DIR}

# Expose port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
