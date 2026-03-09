# Network Architecture Documentation

This document describes the network architecture and security choices implemented for the CloudNative Labs stack.

## 1. High-Level Overview

Our architecture uses a **Zero-Trust** approach to internal networking, where services are isolated into separate networks based on their roles. **Traefik v3** serves as the single point of entry (Reverse Proxy) for all external traffic.

## 2. Network Isolation Strategy

We have implemented two distinct Docker networks to enforce strict isolation:

### `frontend` Network (The Public Zone)
- **Traefik**: Exposed to the host on ports 80/443.
- **frontend-svc**: Serves the dashboard (Nginx).
- **mailhog**: Web interface for testing emails.
- **adminer**: Web interface for database administration.

### `backend` Network (The Private Zone)
- **backend-svc**: The Node.js API.
- **database**: PostgreSQL.
- **cache**: Redis.
- **mailhog**: SMTP interface for sending emails.

### Why this matters:
- **Security**: The `database` and `cache` services are **not** on the `frontend` network. They are physically unreachable from Traefik or any external client, preventing direct attacks on our data layer.
- **Limited Exposure**: Only Traefik has ports exposed to the host machine. All other service-to-service communication happens over internal Docker networks.

## 3. Traefik Routing & Traffic Flow

Traefik manages traffic through three main concepts:

1.  **Providers (Docker)**: Traefik listens to the Docker socket to dynamically discover services.
2.  **Routers**: Match incoming requests based on the `Host` header (e.g., `api.localhost`).
3.  **Middlewares**: Apply security and performance logic to requests *before* they reach the service:
    - `api-ratelimit`: Prevents abuse by limiting the number of requests to the backend.
    - `security-headers`: Hardens the HTTP response with HSTS, X-Frame-Options, etc.
    - `admin-auth`: Protects administrative interfaces with Basic Authentication.

## 4. Security Justification

- **Non-Root Containers**: Both frontend and backend services run as a non-privileged `node` user to mitigate the impact of a potential container breakout.
- **SSL/TLS**: All traffic is encrypted using HTTPS. Traefik terminates SSL at the edge, ensuring unencrypted traffic never leaves the Docker network.
- **Multi-Stage Builds**: We use multi-stage Dockerfiles to minimize the image size and remove unnecessary build tools from the final production environment.
- **Environment Parity**: The use of `docker-compose.override.yml` and `docker-compose.prod.yml` ensures that production constraints (resource limits, replicas) are enforced while keeping the development environment flexible.
