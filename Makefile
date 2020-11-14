# Имя пользователя на докер-хабе
build_all: oracle monitoring

monitoring: exporter prometheus grafana

volume_dir:
	mkdir /home/$(USER)/oradata && chmod a+w /home/$(USER)/oradata

oracle:
	docker build --force-rm=true --no-cache=true --build-arg DB_EDITION=ee -t oracle12 ./oracle12c
	yes | docker image prune > /dev/null

exporter:
	docker build --build-arg VERSION=0.3.0 --build-arg ORACLE_VERSION=18.5 -t oracledb_exporter ./monitoring/oracledb_exporter

prometheus:
	docker build -t prometheus ./monitoring/prometheus

grafana:
	docker build -t grafana ./monitoring/grafana

run_all: volume_dir run_oracle run_monitoring

run_oracle:
	docker run -d --name oracle -p 1521:1521 -e ORACLE_PWD=oracle -v /home/$(USER)/oradata:/opt/oracle/oradata oracle12

run_monitoring: run_exporter run_prometheus run_grafana

run_exporter:
	docker run -d --name oracledb_exporter --link=oracle -p 9161:9161 -e DATA_SOURCE_NAME=system/oracle@oracle/ORCLCDB oracledb_exporter

run_prometheus:
	docker run -d -p 9090:9090 --name prometheus --link=oracledb_exporter prometheus

run_grafana:
	docker run -d -p 3000:3000 --name grafana --link=prometheus grafana

.PHONY: build_all monitoring oracle prometheus grafana run_all run_oracle run_monitoring run_exporter run_prometheus run_grafana
