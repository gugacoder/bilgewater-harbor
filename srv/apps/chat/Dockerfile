# Etapa 1: build
FROM node:20-alpine AS builder
WORKDIR /app

COPY package.json package-lock.json ./
RUN npm install

COPY . .
RUN npm run build

# Etapa 2: runtime
FROM node:20-alpine
WORKDIR /app
ENV NODE_ENV=production

# Copia apenas o necessário
COPY --from=builder /app /app

EXPOSE 3000
CMD ["npm", "run", "start"]

