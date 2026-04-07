# DevOps Foundations - CloudNative Labs

Ce projet est une infrastructure de référence conteneurisée démontrant les fondamentaux DevOps : microservices, reverse proxy (Traefik), sécurité, et scalabilité.

---

## 🚀 État du projet (100% DONE)

Ce projet implémente l'intégralité des exigences spécifiées dans le document `DevOps Foundations.pdf`.

### ✅ Points Forts Techniques
- **Workflow Git & Documentation** : 
  - [CONTRIBUTING.md](CONTRIBUTING.md) : Stratégie GitFlow et conventions de commits.
  - [docs/merge-vs-rebase.md](docs/merge-vs-rebase.md) : Analyse comparative détaillée.
  - [docs/architecture-reseau.md](docs/architecture-reseau.md) : Documentation de l'isolation réseau.
- **Services Applicatifs** : 
  - **Backend (Node.js)** : API REST avec 5 routes, CORS configuré, multi-stage Dockerfile (Alpine), Healthchecks.
  - **Frontend (Nginx)** : Dashboard dynamique, Healthchecks, optimisation de cache Docker.
- **Infrastructure & Proxy** : 
  - **Traefik v3** : SSL/TLS auto-généré, Rate Limiting, Security Headers, Gzip.
  - **Orchestration** : Docker Compose multi-environnements (base, override, prod).
  - **Isolation Réseau** : Séparation stricte entre les réseaux `frontend` et `backend`.
- **Automatisation** : Script d'initialisation [scripts/init.sh](scripts/init.sh).

---

## 🔗 Accès aux Services (Localhost)

Une fois la stack lancée, vous pouvez accéder aux services via les URLs suivantes :

| Service | URL | Credentials (si applicable) |
| :--- | :--- | :--- |
| **Frontend Dashboard** | [https://app.localhost](https://app.localhost) | - |
| **Backend API** | [https://api.localhost/health](https://api.localhost/health) | - |
| **Traefik Dashboard** | [https://traefik.localhost](https://traefik.localhost) | `admin` / `admin` |
| **Adminer (DB Admin)** | [https://db.localhost](https://db.localhost) | `admin` / `admin` |
| **MailHog (Emails)** | [https://mail.localhost](https://mail.localhost) | - |

---

## 🛠️ Installation Rapide

1. **Prérequis** : Assurez-vous d'avoir `docker`, `docker-compose` et `mkcert` installés.
2. **Initialisation** :
   ```bash
   ./scripts/init.sh
   ```
3. **Configuration** : Copiez le fichier `.env.example` vers `.env` et ajustez vos variables.
4. **Lancement** :
   ```bash
   docker-compose up -d --build
   ```

---

## 📄 Documentation Complète
- [Plan d'action détaillé](docs/project-plan.md)
- [Guide de contribution](CONTRIBUTING.md)
- [Architecture réseau et sécurité](docs/architecture-reseau.md)
- [Merge vs Rebase : Analyse technique](docs/merge-vs-rebase.md)
