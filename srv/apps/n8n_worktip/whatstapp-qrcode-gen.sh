#!/bin/bash

# Script corrigido - salva como: qr-live.sh

while true; do
    clear
    echo "🤖 NIC Bot - QR Code Monitor"
    echo "============================="
    echo "$(date '+%Y-%m-%d %H:%M:%S')"
    echo ""
    
    # Buscar último QR Code
    QR_CODE=$(docker logs n8n 2>/dev/null | grep "QR code data:" | tail -1 | sed 's/.*QR code data: //')
    
    if [ -n "$QR_CODE" ]; then
        echo "✅ QR Code encontrado!"
        echo ""
        
        # Verificar se qrencode existe
        if ! command -v qrencode >/dev/null 2>&1; then
            echo "📦 Instalando qrencode..."
            apt update >/dev/null 2>&1 && apt install -y qrencode >/dev/null 2>&1
        fi
        
        # Gerar QR Code
        if command -v qrencode >/dev/null 2>&1; then
            echo "$QR_CODE" | qrencode -t UTF8 -m 2
        else
            echo "❌ Erro: qrencode não instalado"
            echo "📋 Código manual: $QR_CODE"
        fi
        
        echo ""
        echo "📱 Escaneie com: WhatsApp → ⋮ → WhatsApp Web"
    else
        echo "❌ QR Code não encontrado"
        echo "💡 Certifique-se que o workflow está ativo"
    fi
    
    echo ""
    echo "🔄 Atualizando em 3 segundos... (Ctrl+C para sair)"
    sleep 3
done
