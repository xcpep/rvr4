#!/bin/bash
sleep 2

#Install the Server
if [[ ! -d /home/container/server ]] || [[ ${UPDATE} == "1" ]]; then

	if [[ -f /home/container/steam.txt ]]; then
		/home/container/steamcmd/steamcmd.sh +login ${STEAM_USER} ${STEAM_PASS} +force_install_dir /home/container/server +app_update ${APP_ID} validate +runscript /home/container/steam.txt
	else
		/home/container/steamcmd/steamcmd.sh +login ${STEAM_USER} ${STEAM_PASS} +force_install_dir /home/container/server +app_update ${APP_ID} validate +quit
	fi

	#fix
	if [[ -d /home/container/server/mpmissions ]]; then
		ln -s /home/container/server/mpmissions /home/container/server/MPMissions
	fi
	
	#fix
	if [[ -f /home/container/server/steamclient.so ]]; then
		rm /home/container/server/steamclient.so
		ln -s /home/container/server/steamcmd/linux32/steamclient.so /home/container/server/steamclient.so
	fi
	
	#fix
	if [[ ! -d /home/container/.local/share ]]; then
		mkdir -p /home/container/.local/share
	fi
	
	#workshop
	if [[ ! -d /home/container/server/steamapps/workshop ]]; then 
		mkdir -p /home/container/server/steamapps/workshop
	fi
	
	if [[ ! -d /home/container/server/steamapps/workshop ]]; then 
		mkdir -p /home/container/server/steamapps/workshop
	fi
	
	if [[ ! -L home/container/server/workshop ]]; then 
		rm home/container/server/workshop
		ln -s /home/container/server/steamapps/workshop home/container/server/workshop
	fi
	
fi

# Replace Startup Variables
MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
echo "~/server: ${MODIFIED_STARTUP}"

cd /home/container/server

# $NSS_WRAPPER_PASSWD and $NSS_WRAPPER_GROUP have been set by the Dockerfile
export USER_ID=$(id -u)
export GROUP_ID=$(id -g)
envsubst < /passwd.template > ${NSS_WRAPPER_PASSWD}
export LD_PRELOAD=/libnss_wrapper.so

# Run the Server
${MODIFIED_STARTUP}

if [ $? -ne 0 ]; then
    echo "PTDL_CONTAINER_ERR: There was an error while attempting to run the start command."
    exit 1
fi