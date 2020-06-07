.PHONY: build start stop template

COMPOSE_PROJECT := "myapp"
COMPOSE_BUILD := "./build/docker-compose.build.yaml"
COMPOSE_APP := "./build/docker-compose.app.yaml"
RELEASE_NAME := "app"
CHART_NAME := "chart"
NAMESPACE := "app-namespace"


build:
	${INFO} "Build App Docker Image"
	@ docker-compose -f ${COMPOSE_BUILD} build

push:
	${INFO} "Push App Docker Image"
	@ docker-compose -f ${COMPOSE_BUILD} push

start:
	${INFO} "Start App"
	@ docker-compose -f ${COMPOSE_APP} -p ${COMPOSE_PROJECT} up -d
	@ docker-compose -f ${COMPOSE_APP} -p ${COMPOSE_PROJECT} ps

stop:
	${INFO} "Stop App"
	@ docker-compose -f ${COMPOSE_APP} -p ${COMPOSE_PROJECT} down

template:
	${INFO} "Generate Chart from templates"
	@ helm template --namespace ${NAMESPACE} ${RELEASE_NAME} ${CHART_NAME}

deploy:
	${INFO} "Deploy App Chart"
	@ helm install ${RELEASE_NAME} ${CHART_NAME}

redeploy:
	${INFO} "Re-Deploy App Chart"
	@ helm uninstall ${RELEASE_NAME} ${CHART_NAME} && helm install ${RELEASE_NAME} ${CHART_NAME}

uninstall:
	${INFO} "Uninstall App Chart"
	@ helm uninstall ${RELEASE_NAME} ${CHART_NAME}

upgrade:
	${INFO} "Upgrade App Chart"
	@ helm upgrade ${RELEASE_NAME} ${CHART_NAME}

# Colorful logs
GREEN := "\e[1;32m"
NC := "\e[0m"

# Shell Functions
INFO := @bash -c '\
  printf $(GREEN); \
  echo "=> $$1"; \
  printf $(NC)' SOME_VALUE