FROM node:22-alpine AS builder

WORKDIR /app

COPY package*.json ./

RUN npm ci

COPY . .

FROM node:22-alpine AS production 

RUN apk add --no-cache curl

ENV NODE_ENV=production

WORKDIR /app 

#sécurity 

COPY --from=builder --chown=node:node /app/node_modules ./node_modules
COPY --from=builder --chown=node:node /app/index.js ./index.js
COPY --from=builder --chown=node:node /app/package.json ./package.json

USER node

LABEL org.opencontainers.image.title="Cloudnative Lab - Backend"
LABEL org.opencontainers.image.description="API Node.js pour les fondations DevOps"
LABEL org.opencontainers.image.version="1.0.0"

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://127.0.0.1:3000/health || exit 1

EXPOSE 3000

CMD ["node", "index.js"]
