#
# Creating postgres data directory
# mkdir -p ~/volumes/jhipster/strapi/postgresql
#
# Building 
# mvn clean package -PIPE,dev,webpack,swagger -DskipTests=true
#
# Creating the image
# docker build -t strapi-ne-gateway --no-cache --rm --build-arg JAR_FILE=target/strapi-gateway-0.0.1-SNAPSHOT.jar -f src/main/docker/Dockerfile .
#
# Running the container 
# docker run -it strapi-ne-gateway
# 
# Composing services
# docker-compose -f src/main/docker/app.yml up -d 
# 
# Verifying log over the container
# docker logs docker_strapi-gateway_1 -f --tail=200
#
FROM maven:3.6.1-jdk-8
ARG JAR_FILE
# RUN apt update && apt install -y --force-yes openjdk-8-jdk
RUN mkdir /var/lib/strapi
COPY src/main/docker/startup.sh /var/lib/strapi/startup.sh
COPY ${JAR_FILE} /var/lib/strapi/strapi.jar
RUN chmod +x -R /var/lib/strapi
ENTRYPOINT ["/var/lib/strapi/startup.sh"]

