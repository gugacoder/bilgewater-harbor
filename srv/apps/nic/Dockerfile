FROM python:3.11-slim

# Instalar dependências básicas
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Instalar a ferramenta retry
RUN curl -L https://raw.githubusercontent.com/kadwanev/retry/master/retry -o /usr/local/bin/retry \
    && chmod +x /usr/local/bin/retry

# Instalar uvx (pipx successor)
RUN pip install --no-cache-dir uv

# Script de entrada que usa retry
RUN echo '#!/bin/bash\n\
echo "Iniciando MCP com retry resiliente..."\n\
exec retry -t 0 -m 5 -x 60 -- uvx mcpo --port 8000 --server-type "streamable_http" -- https://n8n.codrstudio.dev/mcp/ask-nic' \
> /usr/local/bin/start-mcp.sh && chmod +x /usr/local/bin/start-mcp.sh

EXPOSE 8000

CMD ["/usr/local/bin/start-mcp.sh"]
