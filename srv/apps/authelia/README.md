# Authelia SSO Setup

Este diretório contém a configuração completa do Authelia para implementar Single Sign-On (SSO) em todos os serviços do CodrStudio.

## 🚀 Instalação

### 1. Gerar Secrets
Antes de iniciar o Authelia pela primeira vez, execute:

```bash
cd srv/apps/authelia
./generate-secrets.sh
```

### 2. Configurar DNS
Certifique-se de que o domínio `auth.codrstudio.dev` aponta para seu servidor.

### 3. Iniciar Serviços
```bash
# Iniciar Authelia e Redis
docker-compose up -d

# Verificar logs
docker-compose logs -f authelia
```

## 👥 Usuários Padrão

### Administrador
- **Usuário**: `admin`
- **Senha**: `admin123`
- **Email**: `guga.coder@gmail.com`
- **Grupos**: `admins`, `users`

### Usuário Regular
- **Usuário**: `user`
- **Senha**: `user123`
- **Email**: `user@codrstudio.dev`
- **Grupos**: `users`

## 🔐 Políticas de Acesso

- **auth.codrstudio.dev**: Bypass (acesso livre ao Authelia)
- **panel.codrstudio.dev**: Two-factor (apenas admins)
- **\*.codrstudio.dev**: One-factor (usuários autenticados)

## 🎨 Customização

### Tema
O arquivo `theme/custom.css` contém o tema customizado. Para modificar:
1. Edite o arquivo CSS
2. Reinicie o container: `docker-compose restart authelia`

### Usuários
Para adicionar/modificar usuários:
1. Edite `users_database.yml`
2. Para gerar hash de senha:
   ```bash
   docker run --rm authelia/authelia:latest authelia hash-password 'sua_senha'
   ```
3. Reinicie o Authelia: `docker-compose restart authelia`

## 📧 Notificações

### Desenvolvimento
Atualmente configurado para usar filesystem (`/config/data/notification.txt`).

### Produção
Para usar SMTP, edite `notification.yml` e descomente a seção SMTP com suas credenciais.

## 🔧 Configuração Avançada

### Two-Factor Authentication (2FA)
- Habilitado por padrão para admins
- Use apps como Google Authenticator, Authy, etc.
- QR Code aparece no primeiro login

### OIDC (OpenID Connect)
Configurado para integração com outros serviços que suportam OIDC.

## 🛠️ Troubleshooting

### Verificar Status
```bash
docker-compose ps
docker-compose logs authelia
docker-compose logs redis
```

### Resetar Dados
```bash
docker-compose down
docker volume rm authelia_authelia-data authelia_redis-data
./generate-secrets.sh
docker-compose up -d
```

### Verificar Conectividade
```bash
curl -I https://auth.codrstudio.dev
```

## 📁 Estrutura de Arquivos

```
srv/apps/authelia/
├── docker-compose.yml      # Configuração dos containers
├── configuration.yml       # Configuração principal do Authelia
├── users_database.yml      # Base de usuários
├── notification.yml        # Configuração de notificações
├── generate-secrets.sh     # Script para gerar secrets
├── theme/
│   └── custom.css          # Tema customizado
└── data/                   # Dados persistentes (criado automaticamente)
    ├── jwt_secret
    ├── session_secret
    ├── storage_encryption_key
    ├── oidc_hmac_secret
    ├── oidc_private_key
    ├── db.sqlite3
    └── notification.txt
```

## 🔒 Segurança

- Todos os secrets são gerados automaticamente
- Senhas hasheadas com Argon2ID
- Sessões armazenadas no Redis com TTL
- Certificados SSL via Let's Encrypt
- Rate limiting habilitado

## 📞 Suporte

Para problemas ou dúvidas:
- Verifique os logs: `docker-compose logs authelia`
- Documentação oficial: https://www.authelia.com/
- Issues do projeto no GitHub