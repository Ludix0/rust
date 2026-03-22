FROM cm2network/steamcmd:root

# Installation des bibliothèques CRUCIALES pour Rust (sqlite, pulse, atomic)
RUN apt-get update && apt-get install -y \
    libsqlite3-0 \
    libpulse0 \
    libatomic1 \
    gosu \
    && rm -rf /var/lib/apt/lists/*

# Dossier du serveur
RUN mkdir -p /home/steam/server_data && chown steam:steam /home/steam/server_data

WORKDIR /home/steam/server_data

# Copie du script de lancement
COPY --chown=steam:steam entrypoint.sh /home/steam/entrypoint.sh
RUN chmod +x /home/steam/entrypoint.sh

ENTRYPOINT ["/home/steam/entrypoint.sh"]
