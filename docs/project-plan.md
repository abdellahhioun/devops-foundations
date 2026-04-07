## DevOps Foundations – Project Plan

This document summarizes the missions and expectations from the “DevOps Foundations” PDF and tracks current progress on this repository.

---

## 1. High-Level Goals

- Deliver a production-like, containerized stack for CloudNative Labs.
- Focus on infrastructure quality (Docker, Compose, Traefik, networks, security) more than on complex business logic.
- Expose services only through Traefik (no direct app ports); keep credentials out of versioned code.

---

## 2. Missions and Deliverables

### Part 1 – Git Workflow & DevOps Culture

- Enforce a professional Git workflow:
  - GitFlow with protected branches: `main`, `develop`.
  - At least 5 atomic, well-named commits per feature branch.
  - Use Conventional Commits: `feat:`, `fix:`, `docs:`, `chore:`, etc.
  - At least one merge with a documented conflict resolution.
- Documentation:
  - CONTRIBUTING.md must describe:
    - Branching strategy.
    - Commit conventions.
    - Code review process and self-review checklist.
  - merge-vs-rebase.md:
    - Comparative analysis with concrete examples.
    - Chosen policy for this project, with technical justification.
    - Both merge and rebase approaches should be visible in the Git history.

### Part 2 – Services & Containerization

#### Backend Service (API)

- Minimal REST API in Node.js with the following routes:
  - `GET /health`: returns `{"status": "ok", "service": "backend"}`.
  - `GET /`: returns a welcome message and version.
  - `GET /db`: tests PostgreSQL connection and returns status with timestamp.
  - `GET /cache`: tests Redis and increments a visit counter.
  - `POST /contact`: sends a test email via MailHog.

#### Frontend Service (Dashboard)

- Simple HTML/CSS/JS (or light framework) dashboard that:
  - Shows title: **“DevOps Foundations – Dashboard”**.
  - Calls API endpoints and displays:
    - Backend status (OK/DOWN).
    - Database status (OK/DOWN).
    - Cache status (OK/DOWN).
  - Displays visit counter from Redis.
  - Provides a contact form that calls `/contact`.

#### Dockerfiles

For **frontend** and **backend**:

- Multi-stage builds:
  - `builder` stage: install dependencies / build.
  - `production` stage: minimal image (alpine or distroless).
- Security:
  - Non-root user with explicit UID/GID.
  - No secrets baked into the image (use environment variables).
- Optimization:
  - Dockerfile instruction order optimized for cache.
  - Complete `.dockerignore` for both services.
  - Document image size before/after optimization (in docs).
- Observability:
  - OCI labels (`org.opencontainers.image.*`).
  - Healthchecks defined in Dockerfiles.

#### Docker Compose (multi-environments)

- Files:
  - `docker-compose.yml`: base configuration.
  - `docker-compose.override.yml`: development (bind mounts, hot-reload, developer-friendly settings).
  - `docker-compose.prod.yml`: production (replicas, limits, restart policies).
- For each service:
  - Healthchecks with appropriate intervals.
  - `restart` policies adapted to the service.
  - Resource limits in production (`deploy.resources.limits`).
  - Logging driver configured in production.
- Networks:
  - `frontend` network: Traefik + exposed apps.
  - `backend` network: internal services (DB, Redis, MailHog).
  - Strict isolation: Postgres is **not** attached to the frontend network.
- Volumes:
  - Named volumes for PostgreSQL and Redis persistence.
- Secrets:
  - `.env.example` documented.
  - `.env` ignored in `.gitignore`.

### Part 3 – Traefik Reverse Proxy

- Traefik v3 configuration:
  - Static config in `traefik/traefik.yml`:
    - Docker provider.
    - EntryPoints:
      - `web` (:80) with redirection to HTTPS.
      - `websecure` (:443) with mkcert-generated certificates.
  - Dynamic config in `traefik/dynamic/middlewares.yml`:
    - Rate limiting on API (e.g. 100 req/min).
    - Security headers (HSTS, X-Frame-Options, X-Content-Type-Options, etc.).
    - Gzip compression.
    - Basic Auth for Traefik dashboard and Adminer.
- Routing via Docker labels:
  - `app.localhost` → frontend.
  - `api.localhost` → backend.
  - `db.localhost` → Adminer.
  - `mail.localhost` → MailHog.
  - `traefik.localhost` → Traefik dashboard.
- Load balancing:
  - At least 2 backend replicas in production.
  - Demonstrated through Docker Compose prod + Traefik routing.

### Part 4 – Documentation & Demonstration

- README.md:
  - Prerequisites (Docker, mkcert, etc.).
  - Step-by-step installation guide.
  - Useful commands (start, stop, logs, rebuild).
  - URLs for all services exposed via Traefik.
- Network documentation:
  - `docs/architecture-reseau.md` + `docs/images/schema-architecture.png`.
  - Explanation of Traefik concepts (providers, routers, services, middlewares).
  - Justification of security choices.
- Screencast (5–10 min):
  - Clone repo and initial configuration.
  - `docker compose up` from scratch.
  - Navigation on all URLs (frontend, API, Adminer, MailHog, Traefik).
  - Demonstration of load balancing (multiple backend replicas).
  - Stop/restart with persistence verification.

### Bonus (Optional)

- Monitoring stack (Prometheus, Grafana).
- Docker Swarm stack (docker-stack.yml, rolling updates, rollback).
- Watchtower for automatic updates.
- Portainer exposed via Traefik.
- Security scanning with Trivy or Docker Scout and documented report.

---

## 📊 Current Score: 85 / 100

| Category | Score | Status |
| :--- | :--- | :--- |
| Repository Structure | 10 / 10 | ✅ Completed |
| Part 1: Git Workflow | 10 / 20 | 🛠️ In Progress |
| Part 2: Services & Docker | 35 / 35 | ✅ Completed |
| Part 3: Traefik Proxy | 25 / 25 | ✅ Completed |
| Part 4: Docs & Demo | 5 / 10 | 🛠️ In Progress |

---

## ✅ Completed Deliverables
- [x] **[project-plan.md](project-plan.md)**: Master plan created.
- [x] **[merge-vs-rebase.md](merge-vs-rebase.md)**: Technical documentation.
- [x] **Backend API**: Node.js with 5 routes + CORS.
- [x] **Frontend Dashboard**: Dynamic UI with status checks & Redis counter.
- [x] **Optimized Dockerfiles**: Multi-stage, non-root, OCI labels.
- [x] **Docker Compose Stack**: Healthchecks, `depends_on`, multi-env split.
- [x] **Traefik Configuration**: SSL, rate-limiting, security headers, basic auth.
- [x] **Automation**: `init.sh` script.

## 🛠️ Remaining Tasks
- [ ] **CONTRIBUTING.md**: Formalize GitFlow and commit rules.
- [ ] **architecture-reseau.md**: Detailed network documentation.
- [ ] **Architecture Schema**: Visual representation of the stack.
- [ ] **Screencast**: Final demonstration of the working project.

