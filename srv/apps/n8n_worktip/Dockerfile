FROM n8nio/n8n

USER root

# Instalar dependências do Chrome/Chromium (Alpine Linux)
RUN apk add --no-cache \
    chromium \
    nss \
    freetype \
    freetype-dev \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    nodejs \
    yarn

# Configurar Chrome para rodar em sandbox
ENV CHROME_BIN=/usr/bin/chromium-browser
ENV CHROME_PATH=/usr/bin/chromium-browser
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

USER node

# Criar diretório para community nodes
RUN mkdir -p /home/node/.n8n/nodes

# Instalar Wassenger node no local correto
RUN cd /home/node/.n8n/nodes && npm install n8n-nodes-wassenger

# Expor porta padrão
EXPOSE 5678
