FROM tomcat:9-jdk11-openjdk-slim

# Install tools
RUN apt-get update && apt-get install -y wget unzip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Railway free-tier safe memory
ENV JAVA_OPTS="-Djava.awt.headless=true -Xms128m -Xmx384m -XX:+UseSerialGC"
ENV GEOSERVER_DATA_DIR=/geoserver_data

# Install GeoServer
RUN wget -O /tmp/geoserver.zip \
    "https://downloads.sourceforge.net/project/geoserver/GeoServer/2.24.2/geoserver-2.24.2-war.zip" && \
    unzip /tmp/geoserver.zip -d /tmp && \
    unzip /tmp/geoserver.war -d /usr/local/tomcat/webapps/geoserver && \
    rm -rf /tmp/*

# Create data dir (Railway volume recommended)
RUN mkdir -p /geoserver_data && chown -R root:root /geoserver_data

# 🔥 IMPORTANT: Make Tomcat use Railway’s PORT variable
RUN sed -i 's/port="8080"/port="${PORT}"/' /usr/local/tomcat/conf/server.xml

# Tomcat still needs 8080 exposed (Docker requirement)
EXPOSE 8080

CMD ["catalina.sh", "run"]
