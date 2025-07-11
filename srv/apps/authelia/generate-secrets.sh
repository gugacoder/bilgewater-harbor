#!/bin/bash

# Script para gerar secrets do Authelia
# Execute este script antes de iniciar o Authelia pela primeira vez

SECRETS_DIR="./data"

echo "🔐 Gerando secrets para o Authelia..."

# Criar diretório de dados se não existir
mkdir -p "$SECRETS_DIR"

# Gerar JWT Secret
if [ ! -f "$SECRETS_DIR/jwt_secret" ]; then
    echo "Gerando JWT Secret..."
    openssl rand -hex 32 > "$SECRETS_DIR/jwt_secret"
    echo "✅ JWT Secret gerado"
fi

# Gerar Session Secret
if [ ! -f "$SECRETS_DIR/session_secret" ]; then
    echo "Gerando Session Secret..."
    openssl rand -hex 32 > "$SECRETS_DIR/session_secret"
    echo "✅ Session Secret gerado"
fi

# Gerar Storage Encryption Key
if [ ! -f "$SECRETS_DIR/storage_encryption_key" ]; then
    echo "Gerando Storage Encryption Key..."
    openssl rand -hex 32 > "$SECRETS_DIR/storage_encryption_key"
    echo "✅ Storage Encryption Key gerado"
fi

# Gerar OIDC HMAC Secret
if [ ! -f "$SECRETS_DIR/oidc_hmac_secret" ]; then
    echo "Gerando OIDC HMAC Secret..."
    openssl rand -hex 32 > "$SECRETS_DIR/oidc_hmac_secret"
    echo "✅ OIDC HMAC Secret gerado"
fi

# Gerar OIDC Private Key
if [ ! -f "$SECRETS_DIR/oidc_private_key" ]; then
    echo "Gerando OIDC Private Key..."
    openssl genpkey -algorithm RSA -out "$SECRETS_DIR/oidc_private_key" -pkcs8 -pkeyopt rsa_keygen_bits:2048
    echo "✅ OIDC Private Key gerado"
fi

# Definir permissões corretas
chmod 600 "$SECRETS_DIR"/*
chown -R 1000:1000 "$SECRETS_DIR" 2>/dev/null || true

echo ""
echo "🎉 Todos os secrets foram gerados com sucesso!"
echo "📁 Localização: $SECRETS_DIR/"
echo ""
echo "⚠️  IMPORTANTE:"
echo "   - Faça backup destes arquivos em local seguro"
echo "   - Nunca commite estes arquivos no Git"
echo "   - Mantenha as permissões restritivas (600)"
echo ""
echo "🚀 Agora você pode iniciar o Authelia com:"
echo "   docker-compose up -d"