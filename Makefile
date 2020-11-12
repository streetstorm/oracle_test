# Имя пользователя на докер-хабе
DOCKER_REGISTRY = $(USER_NAME)

all: oracle monitoring

monitoring: prometheus grafana

oracle:
	docker build --force-rm=true --no-cache=true -t $(DOCKER_REGISTRY)/oracle18-xe ./oracle18-xe

prometheus:
	docker build -t $(DOCKER_REGISTRY)/prometheus ./monitoring/prometheus

grafana:
	docker build -t $(DOCKER_REGISTRY)/grafana ./monitoring/grafana

.PHONY: all monitoring oracle prometheus grafana
