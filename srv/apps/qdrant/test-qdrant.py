#!/usr/bin/env python3

import yaml
import re
import requests
import sys

# Lê a chave do config.yaml
def get_api_key():
    with open('config.yaml', 'r') as f:
        config = yaml.safe_load(f)
        return config['service']['api_key']

# Lê a URL do docker-compose.yml
def get_qdrant_url():
    with open('docker-compose.yml', 'r') as f:
        content = f.read()
        match = re.search(r"Host\(`(.*?)`\)", content)
        if match:
            return f"https://{match.group(1)}"
        else:
            raise ValueError("URL do Qdrant não encontrada no docker-compose.yml")

# Faz uma requisição GET para listar coleções
def test_connection():
    url = get_qdrant_url()
    api_key = get_api_key()
    try:
        r = requests.get(f"{url}/collections", headers={"api-key": api_key}, timeout=5)
        r.raise_for_status()
        print("✅ Conexão bem-sucedida. Resposta:")
        print(r.json())
    except Exception as e:
        print("❌ Falha na conexão:")
        print(e)
        sys.exit(1)

if __name__ == "__main__":
    test_connection()

