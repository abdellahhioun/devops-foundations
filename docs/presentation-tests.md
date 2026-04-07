# Presentation Tests

Use these commands in order during the presentation.

## 0) Start stack in production mode

```bash
cd /Users/abd-ellah/Documents/devops-foundations
docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d --build
```

## 1) Health checks (API + app reachability)

```bash
curl -s https://api.localhost/health
curl -s https://api.localhost/db
curl -s https://api.localhost/cache/status
curl -I https://app.localhost
```

Expected:
- API routes return JSON with `status` OK/connected
- App returns HTTP `200`

## 2) Admin routes auth check

Without credentials (expected `401`):

```bash
curl -I https://db.localhost
curl -I https://traefik.localhost
```

With credentials:

```bash
curl -u admin:admin -I https://db.localhost
curl -u admin:admin -I -L https://traefik.localhost
```

## 3) Show backend replicas (prod)

```bash
docker compose -f docker-compose.yml -f docker-compose.prod.yml ps backend
```

You should see 2 backend containers.

## 4) Prove service still works if one backend is down

List backend containers:

```bash
docker ps --format "table {{.Names}}\t{{.Status}}" | grep backend
```

Stop one backend replica (replace with one backend container name from command above):

```bash
docker stop devops-foundations-backend-1
```

Test API again:

```bash
curl -s https://api.localhost/health
curl -s https://api.localhost/db
```

Expected:
- API still responds (Traefik routes to remaining replica)

## 5) Bring replica back

```bash
docker start devops-foundations-backend-1
docker compose -f docker-compose.yml -f docker-compose.prod.yml ps backend
```

## 6) Optional TLS sanity check (mkcert)

```bash
echo | openssl s_client -connect app.localhost:443 -servername app.localhost 2>/dev/null | openssl x509 -noout -issuer -subject
```

Expected:
- Issuer contains mkcert development CA
