#!/bin/bash

# Script para gerar certificados SSL para PostgreSQL
# Execute este script no diretório do seu projeto

set -e

CERTS_DIR="./certs"
DOMAIN="sql.codrstudio.dev"

# Criar diretório dos certificados
mkdir -p "$CERTS_DIR"

echo "🔐 Gerando certificados SSL para PostgreSQL..."

# 1. Gerar chave privada da CA
openssl genrsa -out "$CERTS_DIR/ca.key" 4096

# 2. Gerar certificado da CA
openssl req -new -x509 -days 365 -key "$CERTS_DIR/ca.key" -out "$CERTS_DIR/ca.crt" -subj "/C=BR/ST=MG/L=Juiz de Fora/O=CodrStudio/CN=PostgreSQL CA"

# 3. Gerar chave privada do servidor
openssl genrsa -out "$CERTS_DIR/server.key" 4096

# 4. Gerar requisição de certificado do servidor
openssl req -new -key "$CERTS_DIR/server.key" -out "$CERTS_DIR/server.csr" -subj "/C=BR/ST=MG/L=Juiz de Fora/O=CodrStudio/CN=$DOMAIN"

# 5. Gerar certificado do servidor assinado pela CA
openssl x509 -req -days 365 -in "$CERTS_DIR/server.csr" -CA "$CERTS_DIR/ca.crt" -CAkey "$CERTS_DIR/ca.key" -CAcreateserial -out "$CERTS_DIR/server.crt"

# 6. Gerar chave privada do cliente
openssl genrsa -out "$CERTS_DIR/client.key" 4096

# 7. Gerar requisição de certificado do cliente
openssl req -new -key "$CERTS_DIR/client.key" -out "$CERTS_DIR/client.csr" -subj "/C=BR/ST=MG/L=Juiz de Fora/O=CodrStudio/CN=postgres"

# 8. Gerar certificado do cliente assinado pela CA
openssl x509 -req -days 365 -in "$CERTS_DIR/client.csr" -CA "$CERTS_DIR/ca.crt" -CAkey "$CERTS_DIR/ca.key" -CAcreateserial -out "$CERTS_DIR/client.crt"

# 9. Ajustar permissões
chmod 600 "$CERTS_DIR"/*.key
chmod 644 "$CERTS_DIR"/*.crt
chmod 644 "$CERTS_DIR"/*.csr

# 10. Criar arquivo de configuração do cliente
cat > "$CERTS_DIR/postgresql.conf" << EOF
# Configuração SSL do cliente PostgreSQL
ssl_cert_file = 'client.crt'
ssl_key_file = 'client.key'
ssl_ca_file = 'ca.crt'
ssl_mode = 'require'
EOF

# 11. Limpar arquivos temporários
rm -f "$CERTS_DIR"/*.csr "$CERTS_DIR"/*.srl

echo "✅ Certificados SSL gerados com sucesso!"
echo "📁 Certificados salvos em: $CERTS_DIR"
echo ""
echo "📋 Arquivos gerados:"
echo "   - ca.crt (Certificado da CA)"
echo "   - server.crt (Certificado do servidor)"
echo "   - server.key (Chave privada do servidor)"
echo "   - client.crt (Certificado do cliente)"
echo "   - client.key (Chave privada do cliente)"
echo "   - postgresql.conf (Configuração do cliente)"
echo ""
echo "🚀 Agora execute: docker-compose up -d"
