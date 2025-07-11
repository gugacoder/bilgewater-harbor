# TODO

- [x] Issue 1 - Acrescentar uma página bonita de login ao traefik com authelia para implementar SSO (Single Sign-On) para todos os serviços publicados por ele.

## ✅ Issue 1 - Implementação Completa

### O que foi implementado:
- **Authelia SSO**: Sistema completo de autenticação centralizada
- **Página de login customizada**: Tema moderno e responsivo
- **Integração com Traefik**: Forward auth para todos os serviços
- **Redis para sessões**: Armazenamento persistente e escalável
- **Two-Factor Authentication**: 2FA opcional via TOTP
- **Políticas de acesso granulares**: Controle por domínio e grupo
- **OIDC Support**: Para integração com outros serviços

### Arquivos criados:
- `srv/apps/authelia/docker-compose.yml` - Configuração dos containers
- `srv/apps/authelia/configuration.yml` - Configuração principal
- `srv/apps/authelia/users_database.yml` - Base de usuários
- `srv/apps/authelia/notification.yml` - Configuração de notificações
- `srv/apps/authelia/theme/custom.css` - Tema customizado
- `srv/apps/authelia/generate-secrets.sh` - Script para gerar secrets
- `srv/apps/authelia/README.md` - Documentação completa
- `srv/apps/authelia/.gitignore` - Proteção de arquivos sensíveis

### Arquivos modificados:
- `srv/apps/traefik/docker-compose.yml` - Removido basicauth, adicionado middleware Authelia

### Próximos passos para deploy:
1. Executar `./generate-secrets.sh` no servidor
2. Configurar DNS para `auth.codrstudio.dev`
3. Iniciar com `docker-compose up -d`
4. Testar login em `https://auth.codrstudio.dev`
5. Verificar proteção do dashboard em `https://panel.codrstudio.dev`

### Credenciais padrão:
- **Admin**: admin/admin123 (grupo: admins)
- **User**: user/user123 (grupo: users)

