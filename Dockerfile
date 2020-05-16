#
# Creating postgres data directory
# mkdir -p ~/volumes/jhipster/vobys/postgresql
#
# Building 
# mvn clean package -PIPE,dev,webpack,swagger -DskipTests=true
#
# Creating the image
# docker build -t vobys-ne-gateway --no-cache --rm --build-arg JAR_FILE=target/vobys-gateway-0.0.1-SNAPSHOT.jar -f src/main/docker/Dockerfile .
#
# Running the container 
# docker run -it vobys-ne-gateway
# 
# Composing services
# docker-compose -f src/main/docker/app.yml up -d 
# 
# Verifying log over the container
# docker logs docker_vobys-gateway_1 -f --tail=200
#
FROM maven:3.6.1-jdk-8
ARG JAR_FILE
# RUN apt update && apt install -y --force-yes openjdk-8-jdk
RUN mkdir /var/lib/vobys
COPY src/main/docker/startup.sh /var/lib/vobys/startup.sh
COPY ${JAR_FILE} /var/lib/vobys/vobys.jar
RUN chmod +x -R /var/lib/vobys
ENTRYPOINT ["/var/lib/vobys/startup.sh"]

