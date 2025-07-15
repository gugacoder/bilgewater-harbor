FROM ghcr.io/coder/code-server:latest

USER root

# Instalar dependências
RUN apt-get update && \
    apt-get install -y npm && \
    npm install -g @anthropic-ai/claude-code && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Voltar para o usuário coder
USER coder

# Expor as portas necessárias
EXPOSE 8080 3000 5000 8000
