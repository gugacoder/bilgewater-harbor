FROM ghcr.io/coder/code-server:latest
USER root

# Remover Node.js antigo e instalar versão 22
RUN apt-get update && \
    apt-get remove -y nodejs npm && \
    curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get update && \
    apt-get install -y nodejs && \
    apt-get install -y vim && \
    npm install -g @anthropic-ai/claude-code && \
    npm install -g @google/gemini-cli && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Voltar para o usuário coder
USER coder

# Expor as portas necessárias
EXPOSE 8080 3000 5000 8000
