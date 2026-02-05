# Analyse Technique : Git Merge vs. Git Rebase

Dans un workflow DevOps professionnel, l'intégration des changements entre les branches est une opération critique. Git propose deux mécanismes principaux : le **Merge** (fusion) et le **Rebase** (réadressage).

## 1. Git Merge : Préservation de l'Histoire

Le `git merge` combine les historiques de deux branches en créant un nouveau "commit de fusion" (merge commit).

- **Fonctionnement** : Il effectue une fusion à trois branches entre les deux derniers instantanés et leur ancêtre commun.
- **Impact** : Il préserve la chronologie authentique. On voit exactement quand une branche a commencé et quand elle a été fusionnée.
- **Avantages** : Opération non-destructive, sûre pour les branches partagées.
- **Inconvénients** : Peut rendre l'historique illisible (effet "toile d'araignée") sur les gros projets.

## 2. Git Rebase : Linéarité et Clarté

Le `git rebase` réécrit l'histoire de la branche en déplaçant ses commits au sommet de la branche cible.

- **Fonctionnement** : Git retire temporairement vos commits, met à jour la base avec le code le plus récent, puis réapplique vos commits un par un.
- **Impact** : Crée un historique parfaitement rectiligne. Il semble que le travail a été fait séquentiellement.
- **Avantages** : Facilite la lecture, le débogage et l'utilisation de `git bisect`.
- **Inconvénients** : Destructif (change les hashes SHA). **Interdiction formelle de rebaser une branche publique.**

## 3. Comparatif et Politique du Projet

| Caractéristique | Git Merge | Git Rebase |
| :--- | :--- | :--- |
| **Historique** | Authentique / Complexe | Linéaire / Propre |
| **Commits** | Ajoute un commit de fusion | Réécrit les commits existants |
| **Usage idéal** | Intégration dans `main` | Mise à jour de `feature/*` locale |

### Politique CloudNative Labs

Nous utilisons une approche hybride :
1.  Les développeurs effectuent des **rebases locaux** sur `develop` pour garder leurs branches propres.
2.  L'intégration finale dans `main` se fait par **merge** pour conserver une trace officielle de la release.
