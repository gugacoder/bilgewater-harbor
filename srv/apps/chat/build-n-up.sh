#!/bin/bash

docker-compose down

# Força rebuild da imagem (ignora cache)
docker-compose build --no-cache

# Depois sobe o container com a nova imagem
docker-compose up -d

