# oracle_test

## Инструкция запуска

- Скачиваем репозиторий и заходим в директорию `oracle_test`:

  `git clone https://github.com/streetstorm/oracle_test.git && cd oracle_test`

- Экспортируем переменную с вашим ником Dockerhub:

  `export USER_NAME=your_dockerhub_name`

- Собираем все образы:

  `make build_all`

- Создаем папку для volume базы данных:

  `mkdir ~/oradata && chmod a+w ~/oradata`

- Запускаем контейнер базы данных и ждём, когда статус контейнера будет `healthy`:
  `make run_oracle`

  либо:

```shell
  docker run --name oracle -p 1521:1521 -e ORACLE_PWD=oracle -v /home/$USER/oradata:/opt/oracle/oradata \
  $USER_NAME/oracle18-xe`
```

- Заходим в контейнер oracle и делаем SELECT по первичному ключу в созданную таблицу:

```shell
docker exec -ti oracle sqlplus sys/oracle@//localhost:1521/XE as sysdba

SELECT * FROM ACCOUNTS WHERE ACCOUNT_NUMBER = 1;

exit
```

- Запускаем мониторинг:

`make run_monitoring`

  либо по очереди:

```shell
# Экспортер (make run_exporter)
docker run -d --name oracledb_exporter --link=oracle -p 9161:9161 -e DATA_SOURCE_NAME=system/oracle@oracle/xe \
iamseth/oracledb_exporter:alpine
# Prometheus (make run_prometheus)
docker run -d -p 9090:9090 --name prometheus --link=oracledb_exporter $USER_NAME/prometheus
# Grafana (make run_grafana)
docker run -d -p 3000:3000 --name grafana --link=prometheus $USER_NAME/grafana
```

- Открываем браузер, заходим в Grafana `http://localhost:3000`, логин и пароль по умолчанию(admin:admin). Data Source и Dashboard уже преднастроены, достаточно открыть dashboard: Oracledb.
