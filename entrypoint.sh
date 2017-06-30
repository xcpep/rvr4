#!/bin/bash
sleep 2

cd /home/container

if [[ ! -d server ]] || [[ ${UPDATE} == "yes" ]]; then
    cd steamcmd
    ./steamcmd.sh +login ${STEAM_USER} ${STEAM_PASS} +force_install_dir ../server +app_update ${APP_ID} validate +quit
    mkdir -p ~/".local/share/${RVR4_PROFILE}"
    mkdir -p ~/".local/share/${RVR4_PROFILE_OTHER}"
	
	if [[ ! -d ../server/server/mpmissions ]]; then
		ln -s ../server/mpmissions ../server/MPMissions
	fi
fi

cd /home/container/server

# Run the Server
./arma3server `eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`

if [ $? -ne 0 ]; then
    echo "PTDL_CONTAINER_ERR: There was an error while attempting to run the start command."
    exit 1
fi
