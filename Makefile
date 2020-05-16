COMPANY = malnati
APP = strapi
PROJECT_NAME = $(COMPANY)-$(APP)
APP_IMAGE_VERSION = 1
APP_IMAGE_NAME = $(PROJECT_NAME):$(APP_IMAGE_VERSION)
APP_CONTAINER_NAME = $(APP)-container
POSTGRES_CONTAINER_NAME = strapi-postgresql

.DEFAULT: help
.PHONY : help

help : Makefile
	@sed -n 's/^##//p' $<
 
##
## /*
##  * GitHub: https://github.com/Malnati/mal-poc-njs-strapi
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
##  * - Inspect network by image [docker inspect -f '{{ range $name, $element := .NetworkSettings.Networks }}{{ $name }} {{ end }}' $(APP)-container]
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
##  * Using Sonar
##  * ref: https://docs.sonarqube.org/latest/setup/get-started-2-minutes/
##  *
##  * @see http://0.0.0.0:9000
##  * ------------------------------------------------------------------------
##  */
##

## make docker-sonar-up          : docker-compose -f docker/sonar.yml up -d

docker-sonar-up: 
	docker-compose -f docker/sonar.yml up -d

## make docker-sonar-down        : docker-compose -f docker/sonar.yml down

docker-sonar-down: 
	docker-compose -f docker/sonar.yml down

## make docker-sonar-stop        : docker-compose -f docker/sonar.yml stop

docker-sonar-stop: 
	docker-compose -f docker/sonar.yml stop

## make docker-sonar-start       : docker-compose -f docker/sonar.yml start

docker-sonar-start: 
	docker-compose -f docker/sonar.yml start

##
## /*
##  *
##  * Using PostgreSQL in development
##  * ref: https://docs.docker.com/engine/examples/postgresql_service/
##  * 
##  * This option is bit more complex than using H2, but you have a some important 
##  * benefits:
##  * - Your data is kept across application restarts
##  * - Your application starts a little bit faster
##  * - You can use the great ./mvnw liquibase:diff goal (see reference)
##  *   PS. If you are running H2 with disk-based persistence, this workflow is not 
##  *       yet working perfectly.
##  * @see jdbc:postgres//localhost:5432/strapi
##  * ------------------------------------------------------------------------
##  */
##

## make docker-postgres-up       : docker-compose -f docker/postgresql.yml up -d

docker-postgres-up: 
	docker-compose -f docker/postgresql.yml up -d

## make docker-postgres-down     : docker-compose -f docker/postgresql.yml down

docker-postgres-down: 
	docker-compose -f docker/postgresql.yml down

## make docker-postgres-start    : docker-compose -f docker/postgresql.yml start

docker-postgres-start: 
	docker-compose -f docker/postgresql.yml start

## make docker-postgres-stop     : docker-compose -f docker/postgresql.yml stop

docker-postgres-stop: 
	docker-compose -f docker/postgresql.yml stop

## make docker-postgres-exec     : docker exec -it $(POSTGRES_CONTAINER_NAME) /bin/bash

docker-postgres-exec: 
	docker exec -it $(POSTGRES_CONTAINER_NAME) /bin/bash

## make docker-postgres-logs     : docker logs $(POSTGRES_CONTAINER_NAME) -f --tail=200

docker-postgres-logs: 
	docker logs $(POSTGRES_CONTAINER_NAME) -f --tail=200

## make docker-postgres-recreate : docker-compose -f docker/postgresql.yml down
##                                 rm -rf ~/volumes/$(COMPANY)/postgresql/ && mkdir -p ~/volumes/$(COMPANY)/postgresql/
##                                 docker rmi postgres
##                                 docker-compose -f docker/postgresql.yml up -d
##                                 docker logs $(POSTGRES_CONTAINER_NAME) -f --tail=200

docker-postgres-recreate: 
	docker-compose -f docker/postgresql.yml down
	rm -rf ~/volumes/$(COMPANY)/postgresql/ && mkdir -p ~/volumes/$(COMPANY)/postgresql/
	docker rmi postgres
	docker-compose -f docker/postgresql.yml up -d
	docker logs $(POSTGRES_CONTAINER_NAME) -f --tail=200

##
## End Makefile 