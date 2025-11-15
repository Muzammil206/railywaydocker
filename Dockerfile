FROM tomcat:9-jdk11-openjdk-slim

RUN apt-get update && apt-get install -y wget unzip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ENV JAVA_OPTS="-Djava.awt.headless=true -Xms128m -Xmx384m -XX:+UseSerialGC"
ENV GEOSERVER_DATA_DIR=/geoserver_data

# Download and install GeoServer
RUN wget -O /tmp/geoserver.zip \
    "https://downloads.sourceforge.net/project/geoserver/GeoServer/2.24.2/geoserver-2.24.2-war.zip" && \
    unzip /tmp/geoserver.zip -d /tmp && \
    unzip /tmp/geoserver.war -d /usr/local/tomcat/webapps/geoserver && \
    rm -rf /tmp/*

# Create data directory
RUN mkdir -p /geoserver_data

# ✔ Critical! Make Tomcat use Railway's PORT
RUN sed -i -E 's/port="8080"/port="${PORT}"/g' /usr/local/tomcat/conf/server.xml

EXPOSE 8080

CMD ["catalina.sh", "run"]
