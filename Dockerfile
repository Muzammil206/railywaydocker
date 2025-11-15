# Base image: Tomcat with JDK 11
FROM tomcat:9-jdk11-openjdk-slim

# Install required tools
RUN apt-get update && apt-get install -y wget unzip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Set Java memory options safe for Railway free tier
ENV JAVA_OPTS="-Djava.awt.headless=true -Xms128m -Xmx384m -XX:+UseSerialGC"

# Set GeoServer data directory
ENV GEOSERVER_DATA_DIR=/geoserver_data

# Download and install GeoServer WAR
RUN wget -O /tmp/geoserver.zip "https://downloads.sourceforge.net/project/geoserver/GeoServer/2.24.2/geoserver-2.24.2-war.zip" && \
    unzip /tmp/geoserver.zip -d /tmp && \
    unzip /tmp/geoserver.war -d /usr/local/tomcat/webapps/geoserver && \
    rm -rf /tmp/*

# Create persistent data directory (Railway volume recommended)
RUN mkdir -p ${GEOSERVER_DATA_DIR} && chown -R root:root ${GEOSERVER_DATA_DIR}

# 🔹 Critical: Make Tomcat listen on Railway's dynamic PORT
RUN sed -i -E 's/port="8080"/port="${PORT}"/g' /usr/local/tomcat/conf/server.xml

# Expose port (required by Docker)
EXPOSE 8080

# Run Tomcat
CMD ["catalina.sh", "run"]

