# --- Stage 1: Builder ---
# On utilise une image temporaire pour préparer les assets
FROM nginx:stable-alpine AS builder
WORKDIR /app
# On copie les fichiers depuis votre machine (contexte) vers l'étape builder
COPY . .

# --- Stage 2: Production ---
# On repart d'une image vierge, légère et sécurisée
FROM nginx:stable-alpine

# SÉCURITÉ : droits pour exécution en non-root (UID/GID explicites)
RUN touch /var/run/nginx.pid && \
    chown -R 1000:1000 /var/run/nginx.pid /var/cache/nginx /var/log/nginx /etc/nginx/conf.d

# On force Nginx à écouter sur le port 8080 car 80 est réservé à root
RUN sed -i 's/listen\(.*\)80;/listen 8080;/' /etc/nginx/conf.d/default.conf

WORKDIR /usr/share/nginx/html

# SOLUTION : On copie depuis l'étape "builder" vers cette étape de production
COPY --from=builder --chown=1000:1000 /app/index.html ./index.html

USER 1000:1000

# METADATA OCI [5]
LABEL org.opencontainers.image.title="CloudNative Lab - Frontend" \
      org.opencontainers.image.description="Dashboard statique servi par Nginx" \
      org.opencontainers.image.version="1.0.0"

# OBSERVABILITÉ : Healthcheck avec wget (natif sur Alpine) [6, 7]
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://127.0.0.1:8080/ || exit 1

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]