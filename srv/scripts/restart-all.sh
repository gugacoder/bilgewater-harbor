# !/bin/bash
BASE_DIR="/srv/apps"

echo "🔄 Reiniciando todos os serviços com docker-compose..."

for dir in "$BASE_DIR"/*/; do
  if [ -f "$dir/docker-compose.yml" ]; then
    echo "🔁 Reiniciando: $dir"
    docker compose -f "$dir/docker-compose.yml" down
    docker compose -f "$dir/docker-compose.yml" up -d
  fi
done

echo "✅ Todos os serviços foram reiniciados."