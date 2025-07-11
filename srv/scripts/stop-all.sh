#!/bin/bash
BASE_DIR="/srv/apps"

echo "⏹️ Parando todos os serviços com docker-compose..."

for dir in "$BASE_DIR"/*/; do
  if [ -f "$dir/docker-compose.yml" ]; then
    echo "⏬ Parando: $dir"
    docker compose -f "$dir/docker-compose.yml" down
  fi
done

echo "✅ Todos os serviços foram parados."