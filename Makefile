# путь к папке Docker'а
DOCKER_FOLDER_PATH=docker
# путь к docker-compose.yml
COMPOSE=--file ${DOCKER_FOLDER_PATH}/docker-compose.yml
# путь к .env
ENV=--env-file ${DOCKER_FOLDER_PATH}/.env
# аргументы переданные вместе с вызовом инструкции
ARGS=$(filter-out $@, $(MAKECMDGOALS))
# чтобы аргументы не воспринимались как make команды
%::
	@true
# парсим нужные переменные из env файла
DUMP_DB_PORT=$(shell cat ${DOCKER_FOLDER_PATH}/.env | grep DUMP_DB_PORT | awk -F= '{print $$2}')
DUMP_DB_PASS=$(shell cat ${DOCKER_FOLDER_PATH}/.env | grep DUMP_DB_PASS | awk -F= '{print $$2}')
POSTGRES_USER=$(shell cat ${DOCKER_FOLDER_PATH}/.env | grep POSTGRES_USER | awk -F= '{print $$2}')


init: prepare-env build up composer-install


set-default-config: backup-main-config copy-default-config

prepare-env:
	cp ${DOCKER_FOLDER_PATH}/.env.example ${DOCKER_FOLDER_PATH}/.env

build:
	docker-compose $(COMPOSE) $(ENV) build

up:
	docker-compose $(COMPOSE) $(ENV) up -d

down:
	docker-compose $(COMPOSE) $(ENV) down

stop:
	docker-compose $(COMPOSE) $(ENV) stop

start:
	docker-compose $(COMPOSE) $(ENV) start

restart:
	docker-compose $(COMPOSE) $(ENV) restart

ps:
	docker-compose $(COMPOSE) $(ENV) ps

logs:
	docker-compose $(COMPOSE) $(ENV) logs $(ARGS)

shell-php:
	docker-compose $(COMPOSE) $(ENV) exec php bash

shell-nginx:
	docker-compose $(COMPOSE) $(ENV) exec nginx bash

shell-db:
	docker-compose $(COMPOSE) $(ENV) exec db bash

shell-test-db:
	docker-compose $(COMPOSE) $(ENV) exec test-db bash

shell-nodejs:
	docker-compose $(COMPOSE) $(ENV) exec nodejs sh

shell-rabbit:
	docker-compose $(COMPOSE) $(ENV) exec rabbit sh

dump-db:
	docker-compose $(COMPOSE) $(ENV) exec db bash -c "PGPASSWORD=$(DUMP_DB_PASS) pg_dump -Fc -O -x -v -h 172.18.21.229 -p $(DUMP_DB_PORT)  -U saascredit_user phl_saascredit_db > /tmp/phl_saascredit_db.dump"

restore-db:
	docker-compose $(COMPOSE) $(ENV) exec db bash -c "psql -U $(POSTGRES_USER) -d test_db -c \"DROP SCHEMA public CASCADE;\""
	docker-compose $(COMPOSE) $(ENV) exec db bash -c "psql -U $(POSTGRES_USER) -d test_db -c \"CREATE SCHEMA public;\""
	docker-compose $(COMPOSE) $(ENV) exec db bash -c "pg_restore -U postgres -O -x -v -c -d test_db /tmp/light_db.dump"

codecept-build:
	docker-compose $(COMPOSE) $(ENV) exec -T php bash -c "php vendor/bin/codecept build"

composer-install:
	docker-compose $(COMPOSE) $(ENV) exec php bash -c "composer install --prefer-dist"