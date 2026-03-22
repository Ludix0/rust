#!/bin/bash


# Modifier l'UID et le GID de l'utilisateur steam
USER_ID=${PUID:-1000}
GROUP_ID=${PGID:-1000}

echo "Ajustement de l'utilisateur steam vers UID: $USER_ID et GID: $GROUP_ID..."
groupmod -g $GROUP_ID steam
usermod -u $USER_ID -g $GROUP_ID steam

# On s'assure que l'utilisateur steam possède le dossier de destination
chown -R steam:steam /home/steam/server_data

# Mise à jour seulement si demandée ou si le serveur n'existe pas
if [ "$UPDATE_ON_START" = "true" ] || [ ! -f "/home/steam/server_data/RustDedicated" ]; then
    echo "--- Mise à jour du serveur Solace Crafting (SteamCMD) ---"
    # Mise à jour du serveur
    gosu steam /home/steam/steamcmd/steamcmd.sh \
         +force_install_dir /home/steam/server_data \
         +login anonymous \
         +app_update 258550 validate +quit
else
    echo "--- Saut de la mise à jour (UPDATE_ON_START=false) ---"
fi


# S'assurer que les dossiers appartiennent au bon utilisateur
chown -R steam:steam /home/steam/

cd /home/steam/server_data

# Lancement avec les variables d'environnement Docker
./RustDedicated -batchmode \
    +server.port ${RUST_PORT} \
    +server.identity "${RUST_IDENTITY}" \
    +server.seed ${RUST_SEED} \
    +server.worldsize ${RUST_WORLDSIZE} \
    +server.maxplayers ${RUST_MAXPLAYERS} \
    +server.hostname "${RUST_HOSTNAME}" \
    +server.description "${RUST_DESCRIPTION}" \
    +server.saveinterval ${RUST_SAVEINTERVAL} \
    +server.pve ${RUST_PVE} \
    +rcon.port ${RUST_RCON_PORT} \
    +rcon.password "${RUST_RCON_PASSWORD}" \
    +rcon.web ${RUST_RCON_WEB}
