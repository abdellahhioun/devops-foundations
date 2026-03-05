# DevOps Foundations - CloudNative Labs

Ce projet est une infrastructure de référence conteneurisée démontrant les fondamentaux DevOps : microservices, reverse proxy (Traefik), sécurité, et scalabilité.

## 🚀 État du projet (Progress Tracking)

Nous suivons l'implémentation basée sur le document `DevOps Foundations.pdf`.

### ✅ Ce qui a été fait
- **Structure du projet** : Arborescence complète créée selon les exigences du CTO.
- **Workflow Git & Docs** : 
  - [docs/merge-vs-rebase.md](docs/merge-vs-rebase.md) rédigé et stylisé.
  - [.gitignore](.gitignore) configuré pour exclure `.env` et les certificats SSL.
- **Services Applicatifs (Backend)** : 
  - API Node.js fonctionnelle avec les 5 routes requises.
  - Dockerfile multi-stage et optimisé.
- **Services Applicatifs (Frontend)** : 
  - Dashboard dynamique fonctionnel (appels API, Redis counter, formulaire MailHog).
  - Dockerfile multi-stage et optimisé.
- **Infrastructure** : 
  - **Déploiement réussi** : Toute la stack est opérationnelle via `docker-compose`.
  - **Orchestration** : Healthchecks et dépendances (`depends_on`) configurés pour un démarrage propre.
  - **Reverse Proxy** : Traefik configuré avec HTTPS, Middlewares (Rate-limit, Security Headers) et Dashboard sécurisé.
  - **Multi-environnement** : Fichiers `override.yml` (dev) et `prod.yml` (replicas, limits) implémentés.
- **Automatisation** : 
  - [scripts/init.sh](scripts/init.sh) opérationnel.

### 🛠️ Ce qu'il reste à faire
- **Partie 1 : Workflow Git**
  - [ ] Finaliser [CONTRIBUTING.md](CONTRIBUTING.md) (stratégie GitFlow, conventions de commits).
- **Partie 4 : Documentation & Démo**
  - [ ] Rédiger [docs/architecture-reseau.md](docs/architecture-reseau.md).
  - [ ] Créer le schéma d'architecture (`schema-architecture.png`).
  - [ ] Préparer le screencast de démonstration.

---

## 🛠️ Installation Rapide

1. Exécutez le script d'initialisation :
   ```bash
   ./scripts/init.sh
   ```
2. Configurez votre fichier `.env` avec vos credentials.
3. Lancez l'infrastructure :
   ```bash
   docker-compose up -d
   ```

Pour plus de détails sur le plan d'action, consultez [docs/project-plan.md](docs/project-plan.md).
