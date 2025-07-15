#!/bin/bash

docker compose down
docker compose up -d
echo Aguardando inicialização...
sleep 5
docker exec -u root code-server /home/coder/.docker/provision.sh

