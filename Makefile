# Имя пользователя на докер-хабе
DOCKER_REGISTRY = $(USER_NAME)

build_all: oracle monitoring

monitoring: prometheus grafana

volume_dir:
	mkdir /home/$(USER)/oradata && chmod a+w /home/$(USER)/oradata

oracle:
	docker build --force-rm=true --no-cache=true -t $(DOCKER_REGISTRY)/oracle18-xe ./oracle18xe

prometheus:
	docker build -t $(DOCKER_REGISTRY)/prometheus ./monitoring/prometheus

grafana:
	docker build -t $(DOCKER_REGISTRY)/grafana ./monitoring/grafana

run_all: volume_dir run_oracle run_monitoring

run_oracle:
	docker run -d --name oracle -p 1521:1521 -e ORACLE_PWD=oracle -v /home/$(USER)/oradata:/opt/oracle/oradata $(DOCKER_REGISTRY)/oracle18-xe

run_monitoring: run_exporter run_prometheus run_grafana

run_exporter:
	docker run -d --name oracledb_exporter --link=oracle -p 9161:9161 -e DATA_SOURCE_NAME=system/oracle@oracle/xe iamseth/oracledb_exporter:alpine

run_prometheus:
	docker run -d -p 9090:9090 --name prometheus --link=oracledb_exporter $(DOCKER_REGISTRY)/prometheus

run_grafana:
	docker run -d -p 3000:3000 --name grafana --link=prometheus $(DOCKER_REGISTRY)/grafana

.PHONY: build_all monitoring oracle prometheus grafana run_all run_oracle run_monitoring run_exporter run_prometheus run_grafana
