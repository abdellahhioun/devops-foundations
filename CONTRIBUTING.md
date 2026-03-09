# Contributing to DevOps Foundations

This project follows professional DevOps standards for version control and code quality. Please adhere to these guidelines when contributing.

## 1. Branching Strategy: GitFlow

We follow a strict **GitFlow** model to ensure code stability and traceability:

- **main**: Contains production-ready code. No direct commits allowed.
- **develop**: The integration branch for features. All features are merged here first.
- **feature/**: Dedicated branches for new functionality (e.g., `feature/traefik-config`).
- **fix/**: Dedicated branches for bug fixes.

### Workflow:
1. Create a branch from `develop`: `git checkout -b feature/my-new-feature`
2. Commit your changes using Conventional Commits.
3. Push to origin and create a Pull Request (PR) to `develop`.
4. After review and testing, merge into `develop`.

## 2. Commit Conventions

We use **Conventional Commits** to maintain a readable and structured project history.

### Format:
`<type>: <description>`

### Types:
- `feat`: A new feature for the user.
- `fix`: A bug fix.
- `docs`: Documentation changes only.
- `style`: Changes that do not affect the meaning of the code (white-space, formatting, etc.).
- `refactor`: A code change that neither fixes a bug nor adds a feature.
- `test`: Adding missing tests or correcting existing tests.
- `chore`: Changes to the build process or auxiliary tools and libraries.

**Example:** `feat: implement Traefik rate limiting middleware`

## 3. Code Review Checklist (Self-Review)

Before submitting a PR, ensure you have checked the following:

- [ ] **Dockerization**: Is the Dockerfile optimized (multi-stage) and secure (non-root)?
- [ ] **Networking**: Is the service correctly isolated on the appropriate network?
- [ ] **Observability**: Does the service have a working health check?
- [ ] **Traefik**: Are the labels correct and follow the project's routing standards?
- [ ] **Security**: Are there no secrets or credentials hardcoded?
- [ ] **Tests**: Have you verified the changes in a local `docker-compose up` environment?
