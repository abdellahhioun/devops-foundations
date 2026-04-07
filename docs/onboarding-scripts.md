# Onboarding Scripts

This file contains the command snippets needed to onboard quickly on this project.

## 1) Prerequisites

Install and check:

```bash
docker --version
docker compose version
mkcert -version
```

## 2) First-time setup

From the repository root:

```bash
cd /Users/abd-ellah/Documents/devops-foundations
./scripts/init.sh
```

What this does:
- Creates `.env` from `.env.example` (if missing)
- Installs local mkcert CA trust
- Generates TLS certs in `certs/`

## 3) Start the stack (development/default)

```bash
docker compose up -d --build
```

Check status:

```bash
docker compose ps
```

## 4) Start in production mode (includes backend replicas)

```bash
docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d --build
```

Check backend replicas:

```bash
docker compose -f docker-compose.yml -f docker-compose.prod.yml ps backend
```

## 5) Useful URLs

- App: `https://app.localhost`
- API health: `https://api.localhost/health`
- MailHog: `https://mail.localhost`
- Adminer: `https://db.localhost`
- Traefik dashboard: `https://traefik.localhost`

Basic Auth (Adminer + Traefik dashboard):
- user: `admin`
- password: `admin`

## 6) Common operations

Tail logs:

```bash
docker compose logs -f
```

Logs per service:

```bash
docker compose logs -f traefik
docker compose logs -f backend
docker compose logs -f frontend
```

Restart one service:

```bash
docker compose restart backend
```

Recreate Traefik after config/cert changes:

```bash
docker compose up -d --force-recreate traefik
```

Stop everything:

```bash
docker compose down
```

Stop + remove volumes (destructive):

```bash
docker compose down -v
```

## 7) TLS troubleshooting

If browser says cert is invalid or API calls fail with cert errors:

```bash
./scripts/init.sh
docker compose up -d --force-recreate traefik
```

Then hard refresh browser (`Cmd+Shift+R`).
