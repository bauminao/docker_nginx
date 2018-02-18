IMAGE_NAME = bauminao/nginx
CONTAINER_NAME = nginx

HOME = /etc/nginx
WWW_PATH = /var/www
LOG_PATH = /var/log/nginx

.PHONY: all

all: clean_all build run

clean: clean_container

clean_all: clean_container clean_image

clean_image:
	docker rmi -f ${IMAGE_NAME} 2>/dev/null || true
	docker images | grep ${IMAGE_NAME} || true

clean_container:
	docker rm -f ${CONTAINER_NAME} 2>/dev/null || true
	docker ps -a

build: clean_all
	docker build -t ${IMAGE_NAME} .

stop:
	docker stop ${CONTAINER_NAME}

restart: stop
	docker restart ${CONTAINER_NAME}

run: 
	docker run --name=${CONTAINER_NAME}                             \
		-v $$PWD/environment/sites:${WWW_PATH}                  \
		-v $$PWD/environment/nginx:${HOME}                      \
		-v $$PWD/environment/logs:${LOG_PATH}                   \
		-v $$PWD/environment/letsencrypt:/etc/letsencrypt_local \
	        -p 80:80                                                \
		-p 443:443				                \
		-ti -d ${IMAGE_NAME}
	sleep 1
	docker logs --details ${CONTAINER_NAME}

debug: clean
	docker run --name=${CONTAINER_NAME}                             \
		-v $$PWD/environment/sites:${WWW_PATH}                  \
		-v $$PWD/environment/nginx:${HOME}                      \
		-v $$PWD/environment/logs:${LOG_PATH}                   \
		-v $$PWD/environment/letsencrypt:/etc/letsencrypt_local \
	        -p 80:80                                                \
		-p 443:443				                \
		-ti  ${IMAGE_NAME} /bin/bash
	

reload:
	docker exec -t ${CONTAINER_NAME} service nginx reload

status:
	docker exec -t ${CONTAINER_NAME} service nginx status

renew_cert:
	docker exec -t ${CONTAINER_NAME} certbot renew 

ssh:
	docker exec -ti ${CONTAINER_NAME} bash

shell:
	docker exec -ti ${CONTAINER_NAME} bash

donotforget:
	docker exec -t ${CONTAINER_NAME} certbot renew --dry-run

