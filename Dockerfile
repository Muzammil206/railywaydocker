# GeoServer on Tomcat - ULTRA CONSERVATIVE MEMORY
FROM tomcat:9-jdk11-openjdk-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Very conservative memory settings for Railway free tier
ENV JAVA_OPTS="-Djava.awt.headless=true -Xms128m -Xmx384m -XX:MaxMetaspaceSize=128m -XX:+UseSerialGC -XX:+DisableExplicitGC"
ENV CATALINA_OPTS="-Xms128m -Xmx384m"
ENV GEOSERVER_DATA_DIR=/geoserver_data

# Download and install GeoServer
RUN wget -O /tmp/geoserver.zip \
    "https://downloads.sourceforge.net/project/geoserver/GeoServer/2.24.2/geoserver-2.24.2-war.zip" && \
    unzip /tmp/geoserver.zip -d /tmp && \
    unzip /tmp/geoserver.war -d /usr/local/tomcat/webapps/geoserver && \
    rm -rf /tmp/*

# Create data directory
RUN mkdir -p ${GEOSERVER_DATA_DIR}

EXPOSE 8080
CMD ["catalina.sh", "run"]
