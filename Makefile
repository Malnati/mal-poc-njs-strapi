COMPANY = vobys
APP = gateway
PROJECT_NAME = $(COMPANY)-$(APP)
APP_IMAGE_VERSION = 1
APP_IMAGE_NAME = $(PROJECT_NAME):$(APP_IMAGE_VERSION)
APP_CONTAINER_NAME = vobys-gateway
POSTGRES_CONTAINER_NAME = vobys-postgresql
JHIPSTER_REGISTRY_CONTAINER_NAME = vobys-registry

.DEFAULT: help
.PHONY : help

help : Makefile
	@sed -n 's/^##//p' $<
 
##
## /*
##  * Commands and descriptions
##  * ref: https://www.jhipster.tech/docker-compose/
##  *
##  * Using Docker and Docker Compose is highly recommended in development, 
##  * and is also a good solution in production.
##  *
##  * Common commands:
##  * - List the containers [docker container ps --all]
##  * - Docker stats for containers [docker container stats $(docker container ps --format={{.Names}})]
##  * - Scale a container [docker-compose scale $(APP_CONTAINER_NAME)=4]
##  * - Stop containers [docker container stop <container_id>]
##  * - Delete a container [docker container rm <container_id>]
##  * - Inspect network by image [docker inspect -f '{{ range $name, $element := .NetworkSettings.Networks }}{{ $name }} {{ end }}' vobys-gateway]
##  * ------------------------------------------------------------------------
##  */
##

## TAKE CARE WITH PRUNE!
## make docker-prune             : docker system prune -a --volumes
docker-prune: 
	docker system prune -a --volumes

## make docker-ps                : docker ps --all

docker-ps: 
	docker ps --all

## make docker-container-stats   : docker container stats $(docker container ps --format={{.Names}})
##                                 To list all running containers with CPU, Memory, Networking I/O and Block I/O stats.

docker-container-stats: 
	docker container stats $(docker container ps --format={{.Names}})

## make docker-network-inspect   : docker network ls

docker-network:
	docker network ls

## make docker-configure-volumes : mkdir -p ~/volumes/$(COMPANY)/$(APP)/postgresql/
##                                 mkdir -p ~/volumes/$(COMPANY)/$(APP)/www/html/
docker-configure-volumes: 
	mkdir -p ~/volumes/$(COMPANY)/postgresql/
	mkdir -p ~/volumes/$(COMPANY)/$(APP)/www/html/

## make git-stash                : git stash save "Changes saved by Makefile."

git-stash: 
	git stash save "Changes saved by Makefile."

##
## /*
##  *
##  * The JHipster API Gateway
##  * ref: https://www.jhipster.tech/api-gateway/
##  * 
##  * JHipster can generate API gateways. A gateway is a normal JHipster 
##  * application, so you can use the usual JHipster options and development 
##  * workflows on that project, but it also acts as the entrance to your 
##  * microservices. More specifically, it provides HTTP routing and load 
##  * balancing, quality of service, security and API documentation for all 
##  * microservices.
##  * ------------------------------------------------------------------------
##  */
##

## make gateway-mvn-build        : mvn clean package -PIPE,dev,webpack,swagger -DskipTests=true

gateway-mvn-build: 
	mvn clean package -PIPE,dev,webpack,swagger -DskipTests=true

## make gateway-mvn-sonar        : mvn initialize sonar:sonar 

gateway-mvn-sonar: 
	mvn initialize sonar:sonar 

#	make gateway-jar-run:        : java -jar target/vobys-gateway-0.0.1-SNAPSHOT.jar

gateway-jar-run: 
	java -jar target/vobys-gateway-0.0.1-SNAPSHOT.jar

## make gateway-mvn-clean:       : mvn clean 
##                                 rm -f target/$(PROJECT_NAME)-0.0.1-SNAPSHOT.jar

gateway-mvn-clean: 
		mvn clean 
	    rm -f target/$(PROJECT_NAME)-0.0.1-SNAPSHOT.jar

## make docker-gateway-bash      : docker run -it $(APP_CONTAINER_NAME) /bin/bash

docker-gateway-bash: 
	docker run -it $(APP_CONTAINER_NAME) /bin/bash
	
## make docker-gateway-up        : docker-compose -f src/main/docker/gateway.yml up -d

docker-gateway-up: 
	docker-compose -f src/main/docker/gateway.yml up -d

## make docker-gateway-down      : docker-compose -f src/main/docker/gateway.yml down

docker-gateway-down: 
	docker-compose -f src/main/docker/gateway.yml down

## make docker-gateway-start     : docker-compose -f src/main/docker/gateway.yml start

docker-gateway-start: 
	docker-compose -f src/main/docker/gateway.yml start


## make docker-gateway-stop      : docker-compose -f src/main/docker/gateway.yml stop

docker-gateway-stop: 
	docker-compose -f src/main/docker/gateway.yml stop

## make docker-gateway-build     : docker build -t $(APP_IMAGE_NAME) --no-cache --force-rm --build-arg JAR_FILE=target/$(PROJECT_NAME)-0.0.1-SNAPSHOT.jar -f src/main/docker/Dockerfile ./

docker-gateway-build: 
	docker build -t $(APP_IMAGE_NAME) --no-cache --force-rm --build-arg JAR_FILE=target/$(PROJECT_NAME)-0.0.1-SNAPSHOT.jar -f src/main/docker/Dockerfile ./
	
## make docker-app-up            : docker-compose -f src/main/docker/app.yml up -d

docker-app-up: 
	docker-compose -f src/main/docker/app.yml up -d

## make docker-app-down          : docker-compose -f src/main/docker/app.yml down

docker-app-down: 
	docker-compose -f src/main/docker/app.yml down

##
## /*
##  *
##  * Using Sonar
##  *
##  * @see http://0.0.0.0:9000
##  * ------------------------------------------------------------------------
##  */
##
	
## make docker-gateway-recreate  : mvn clean
##                                 rm -f target/$(PROJECT_NAME)-0.0.1-SNAPSHOT.jar
##                                 mvn clean package -PIPE,dev,webpack,swagger -DskipTests=true
##                                 docker-compose -f src/main/docker/gateway.yml down
##                                 docker rmi $(APP_IMAGE_NAME)
##                                 docker build -t $(APP_IMAGE_NAME) --no-cache --force-rm --build-arg JAR_FILE=target/$(PROJECT_NAME)-0.0.1-SNAPSHOT.jar -f src/main/docker/Dockerfile ./
##                                 docker-compose -f src/main/docker/gateway.yml up -d
##                                 docker logs vobys-gateway-img:1 -f --tail=200

docker-gateway-recreate: 
	mvn clean
	rm -f target/$(PROJECT_NAME)-0.0.1-SNAPSHOT.jar
	mvn clean package -PIPE,dev,webpack,swagger -DskipTests=true
	docker-compose -f src/main/docker/gateway.yml down
	docker rmi $(APP_IMAGE_NAME)
	docker build -t $(APP_IMAGE_NAME) --no-cache --force-rm --build-arg JAR_FILE=target/$(PROJECT_NAME)-0.0.1-SNAPSHOT.jar -f src/main/docker/Dockerfile ./
	docker-compose -f src/main/docker/gateway.yml up -d
	docker logs $(APP_CONTAINER_NAME) -f --tail=200

## make docker-gateway-logs      : docker logs $(APP_IMAGE_NAME)_1 -f --tail=200
##                                 MacOS: docker ps -aqf "name=docker_vobys-gateway_1"
##                                 Linux: sudo docker ps -aqf "docker_vobys-gateway_1"
##                                 docker inspect --format="{{.Id}}" docker_vobys-ne-gateway_1 for getting the Contatiner_ID
docker-gateway-logs: 
	docker logs $(APP_CONTAINER_NAME) -f --tail=200

## make docker-sonar-up          : docker-compose -f src/main/docker/sonar.yml up -d

docker-sonar-up: 
	docker-compose -f src/main/docker/sonar.yml up -d

## make docker-sonar-down        : docker-compose -f src/main/docker/sonar.yml down

docker-sonar-down: 
	docker-compose -f src/main/docker/sonar.yml down

## make docker-sonar-stop        : docker-compose -f src/main/docker/sonar.yml stop

docker-sonar-stop: 
	docker-compose -f src/main/docker/sonar.yml stop

## make docker-sonar-start       : docker-compose -f src/main/docker/sonar.yml start

docker-sonar-start: 
	docker-compose -f src/main/docker/sonar.yml start

##
## /*
##  *
##  * Using PostgreSQL in development
##  * ref: https://www.jhipster.tech/development/
##  * 
##  * This option is bit more complex than using H2, but you have a some important 
##  * benefits:
##  * - Your data is kept across application restarts
##  * - Your application starts a little bit faster
##  * - You can use the great ./mvnw liquibase:diff goal (see reference)
##  *   PS. If you are running H2 with disk-based persistence, this workflow is not 
##  *       yet working perfectly.
##  * @see jdbc:postgres//localhost:5432/vobys
##  * ------------------------------------------------------------------------
##  */
##

## make docker-postgres-up       : docker-compose -f src/main/docker/postgresql.yml up -d

docker-postgres-up: 
	docker-compose -f src/main/docker/postgresql.yml up -d

## make docker-postgres-down     : docker-compose -f src/main/docker/postgresql.yml down

docker-postgres-down: 
	docker-compose -f src/main/docker/postgresql.yml down

## make docker-postgres-start    : docker-compose -f src/main/docker/postgresql.yml start

docker-postgres-start: 
	docker-compose -f src/main/docker/postgresql.yml start

## make docker-postgres-stop     : docker-compose -f src/main/docker/postgresql.yml stop

docker-postgres-stop: 
	docker-compose -f src/main/docker/postgresql.yml stop

## make docker-postgres-exec     : docker exec -it $(POSTGRES_CONTAINER_NAME) /bin/bash

docker-postgres-exec: 
	docker exec -it $(POSTGRES_CONTAINER_NAME) /bin/bash

## make docker-postgres-logs     : docker logs $(POSTGRES_CONTAINER_NAME) -f --tail=200

docker-postgres-logs: 
	docker logs $(POSTGRES_CONTAINER_NAME) -f --tail=200

## make docker-postgres-recreate : docker-compose -f src/main/docker/postgresql.yml down
##                                 rm -rf ~/volumes/$(COMPANY)/postgresql/ && mkdir -p ~/volumes/$(COMPANY)/postgresql/
##                                 docker rmi postgres
##                                 docker-compose -f src/main/docker/postgresql.yml up -d
##                                 docker logs $(POSTGRES_CONTAINER_NAME) -f --tail=200

docker-postgres-recreate: 
	docker-compose -f src/main/docker/postgresql.yml down
	rm -rf ~/volumes/$(COMPANY)/postgresql/ && mkdir -p ~/volumes/$(COMPANY)/postgresql/
	docker rmi postgres
	docker-compose -f src/main/docker/postgresql.yml up -d
	docker logs $(POSTGRES_CONTAINER_NAME) -f --tail=200

##
## /*
##  *
##  * The JHipster Registry has three main purposes:
##  * 
##  * It is a an Eureka server, that serves as a discovery server for applications. 
##  * This is how JHipster handles routing, load balancing and scalability for all 
##  * applications. It is a Spring Cloud Config server, that provide runtime 
##  * configuration to all applications. It is an administration server, with 
##  * dashboards to monitor and manage applications. All those features are packaged 
##  * into one convenient application with a modern Angular-based user interface.
##  * @see http://0.0.0.0:8761
##  * ------------------------------------------------------------------------
##  */
##

## make docker-registry-up       : docker-compose -f src/main/docker/jhipster-registry.yml up -d 

docker-registry-up: 
	docker-compose -f src/main/docker/jhipster-registry.yml up -d 

## make docker-registry-down     : docker-compose -f src/main/docker/jhipster-registry.yml down

docker-registry-down: 
	docker-compose -f src/main/docker/jhipster-registry.yml down

## make docker-registry-stop     : docker-compose -f src/main/docker/jhipster-registry.yml stop

docker-registry-stop: 
	docker-compose -f src/main/docker/jhipster-registry.yml stop

## make docker-registry-start    : docker-compose -f src/main/docker/jhipster-registry.yml start

docker-registry-start: 
	docker-compose -f src/main/docker/jhipster-registry.yml start

## make docker-registry-recreate : docker-compose -f src/main/docker/jhipster-registry.yml down
##                                 docker rmi vobys-jhipster-registry
##                                 docker-compose -f src/main/docker/jhipster-registry.yml up -d 
##                                 docker logs $(JHIPSTER_REGISTRY_CONTAINER_NAME) -f --tail=200

docker-registry-recreate: 
	docker-compose -f src/main/docker/jhipster-registry.yml down
	docker rmi postgres
	docker-compose -f src/main/docker/jhipster-registry.yml up -d 
	docker logs $(JHIPSTER_REGISTRY_CONTAINER_NAME) -f --tail=200

## make docker-registry-logs     : docker logs $(JHIPSTER_REGISTRY_CONTAINER_NAME) -f --tail=200

docker-registry-logs: 
	docker logs $(JHIPSTER_REGISTRY_CONTAINER_NAME) -f --tail=200

##
## End Makefile 