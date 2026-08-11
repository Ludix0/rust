# Rust — Dedicated Server (Docker)

🇬🇧 [English](#english) | 🇫🇷 [Français](#français)

---

## English

Docker container to host a **Rust** dedicated server (SteamCMD App ID `258550`). The server binary and dependencies are downloaded automatically via SteamCMD, and the process runs as an unprivileged user (`PUID`/`PGID`) instead of root.

- Docker Hub image: [`ludix0/rust`](https://hub.docker.com/r/ludix0/rust)
- Ports used: game port `28015` (UDP + TCP, mapped externally to `7777`), RCON port `28016` (TCP)

### Requirements

- Docker + Docker Compose
- About 25-30 GB of free disk space (Rust server files and the world save are large, and grow over time)
- If the server must be reachable from the internet, forward ports `28015` (UDP + TCP) and `28016` (TCP) on your router to the host running this container

### Method 1 — Quick install from Docker Hub (recommended)

```bash
mkdir -p ~/rust && cd ~/rust
```

Create a `docker-compose.yml`:

```yaml
services:
  rust:
    image: ludix0/rust:latest
    container_name: rust
    restart: unless-stopped
    volumes:
      - ${HOME}/volumes/rust/filesServer:/home/steam/server_data
      - ${HOME}/volumes/steamcmd:/home/steam/steamcmd
    environment:
      - TZ=Europe/Paris
      - PUID=1000
      - PGID=1000
      - UPDATE_ON_START=true
      - RUST_HOSTNAME=My Rust Server
      - RUST_IDENTITY=server1
      - RUST_SEED=12345
      - RUST_WORLDSIZE=6000
      - RUST_MAXPLAYERS=50
      - RUST_PVE=true
      - RUST_PORT=28015
      - RUST_RCON_PORT=28016
      - RUST_RCON_PASSWORD=changeme
      - RUST_RCON_WEB=1
      - RUST_DESCRIPTION=Welcome to my Rust server!
      - RUST_SAVEINTERVAL=600
      - COMMSTART=+server.secure 0
    ports:
      - "7777:28015/udp"
      - "7777:28015/tcp"
      - "28016:28016/tcp"
```

```bash
docker compose up -d
docker compose logs -f
```

### Method 2 — Build from source (GitHub)

```bash
git clone https://github.com/ludix0/rust.git
cd rust
ln -sf /path/to/your/secrets.env .env   # or create a .env with the variables below
docker build -t ludix0/rust:latest .
docker compose up -d
```

### Environment variables

| Variable | Required | Description |
|----------|----------|-------------|
| `TZ` | No | Container timezone (e.g. `Europe/Paris`) |
| `PUID` | No | User ID the server process runs as (avoids running as root) |
| `PGID` | No | Group ID the server process runs as |
| `UPDATE_ON_START` | No | If `true`, runs the SteamCMD update/validate on every container start |
| `RUST_HOSTNAME` | No | Server name shown in the in-game server browser |
| `RUST_IDENTITY` | No | Save/identity folder name (allows several server profiles on the same data volume) |
| `RUST_SEED` | No | World generation seed |
| `RUST_WORLDSIZE` | No | Map size |
| `RUST_MAXPLAYERS` | No | Maximum number of players |
| `RUST_PVE` | No | Enables PvE mode when set to `true` |
| `RUST_PORT` | No | Game port used internally by RustDedicated |
| `RUST_RCON_PORT` | No | RCON port used internally by RustDedicated |
| `RUST_RCON_PASSWORD` | Yes | RCON admin password |
| `RUST_RCON_WEB` | No | Enables the web RCON interface when set to `1` |
| `RUST_DESCRIPTION` | No | Server description shown in the in-game server browser |
| `RUST_SAVEINTERVAL` | No | Auto-save interval, in seconds |
| `COMMSTART` | No | Extra RustDedicated startup arguments (e.g. `+server.secure 0`) |

### Volumes

| Volume | Content |
|--------|---------|
| `~/volumes/rust/filesServer:/home/steam/server_data` | Server binaries, world save, maps and configuration |
| `~/volumes/steamcmd:/home/steam/steamcmd` | SteamCMD installation, reused between restarts and updates |

### Ports

| Port | Protocol | Usage |
|------|----------|-------|
| 7777 → 28015 | UDP | Game traffic |
| 7777 → 28015 | TCP | Game traffic |
| 28016 → 28016 | TCP | RCON |

---

## Français

Conteneur Docker permettant d'héberger un serveur dédié **Rust** (App ID SteamCMD `258550`). Le binaire du serveur et ses dépendances sont téléchargés automatiquement via SteamCMD, et le processus tourne avec un utilisateur non privilégié (`PUID`/`PGID`) plutôt qu'en root.

- Image Docker Hub : [`ludix0/rust`](https://hub.docker.com/r/ludix0/rust)
- Ports utilisés : port de jeu `28015` (UDP + TCP, exposé en externe sur `7777`), port RCON `28016` (TCP)

### Prérequis

- Docker + Docker Compose
- Environ 25-30 Go d'espace disque libre (les fichiers du serveur Rust et la sauvegarde du monde sont volumineux, et grossissent avec le temps)
- Si le serveur doit être accessible depuis internet, rediriger les ports `28015` (UDP + TCP) et `28016` (TCP) sur votre routeur vers la machine qui héberge ce conteneur

### Méthode 1 — Installation rapide depuis Docker Hub (recommandée)

```bash
mkdir -p ~/rust && cd ~/rust
```

Créer un fichier `docker-compose.yml` :

```yaml
services:
  rust:
    image: ludix0/rust:latest
    container_name: rust
    restart: unless-stopped
    volumes:
      - ${HOME}/volumes/rust/filesServer:/home/steam/server_data
      - ${HOME}/volumes/steamcmd:/home/steam/steamcmd
    environment:
      - TZ=Europe/Paris
      - PUID=1000
      - PGID=1000
      - UPDATE_ON_START=true
      - RUST_HOSTNAME=Mon serveur Rust
      - RUST_IDENTITY=server1
      - RUST_SEED=12345
      - RUST_WORLDSIZE=6000
      - RUST_MAXPLAYERS=50
      - RUST_PVE=true
      - RUST_PORT=28015
      - RUST_RCON_PORT=28016
      - RUST_RCON_PASSWORD=changeme
      - RUST_RCON_WEB=1
      - RUST_DESCRIPTION=Bienvenue sur mon serveur Rust !
      - RUST_SAVEINTERVAL=600
      - COMMSTART=+server.secure 0
    ports:
      - "7777:28015/udp"
      - "7777:28015/tcp"
      - "28016:28016/tcp"
```

```bash
docker compose up -d
docker compose logs -f
```

### Méthode 2 — Build depuis les sources (GitHub)

```bash
git clone https://github.com/ludix0/rust.git
cd rust
ln -sf /chemin/vers/votre/secrets.env .env   # ou créer un .env avec les variables ci-dessous
docker build -t ludix0/rust:latest .
docker compose up -d
```

### Variables d'environnement

| Variable | Obligatoire | Description |
|----------|-------------|--------------|
| `TZ` | Non | Fuseau horaire du conteneur (ex. `Europe/Paris`) |
| `PUID` | Non | UID utilisé pour faire tourner le serveur (évite de rester en root) |
| `PGID` | Non | GID utilisé pour faire tourner le serveur |
| `UPDATE_ON_START` | Non | Si `true`, relance la mise à jour/validation SteamCMD à chaque démarrage du conteneur |
| `RUST_HOSTNAME` | Non | Nom du serveur affiché dans le navigateur de serveurs en jeu |
| `RUST_IDENTITY` | Non | Nom du dossier de sauvegarde/identité (permet plusieurs profils de serveur sur le même volume) |
| `RUST_SEED` | Non | Graine (seed) de génération du monde |
| `RUST_WORLDSIZE` | Non | Taille de la carte |
| `RUST_MAXPLAYERS` | Non | Nombre maximum de joueurs |
| `RUST_PVE` | Non | Active le mode PvE si réglé sur `true` |
| `RUST_PORT` | Non | Port de jeu utilisé en interne par RustDedicated |
| `RUST_RCON_PORT` | Non | Port RCON utilisé en interne par RustDedicated |
| `RUST_RCON_PASSWORD` | Oui | Mot de passe administrateur RCON |
| `RUST_RCON_WEB` | Non | Active l'interface RCON web si réglé sur `1` |
| `RUST_DESCRIPTION` | Non | Description du serveur affichée dans le navigateur de serveurs en jeu |
| `RUST_SAVEINTERVAL` | Non | Intervalle de sauvegarde automatique, en secondes |
| `COMMSTART` | Non | Arguments de démarrage supplémentaires pour RustDedicated (ex. `+server.secure 0`) |

### Volumes

| Volume | Contenu |
|--------|---------|
| `~/volumes/rust/filesServer:/home/steam/server_data` | Binaires du serveur, sauvegarde du monde, cartes et configuration |
| `~/volumes/steamcmd:/home/steam/steamcmd` | Installation de SteamCMD, réutilisée entre les redémarrages et les mises à jour |

### Ports

| Port | Protocole | Usage |
|------|-----------|-------|
| 7777 → 28015 | UDP | Trafic de jeu |
| 7777 → 28015 | TCP | Trafic de jeu |
| 28016 → 28016 | TCP | RCON |
