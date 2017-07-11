#!/bin/bash
sleep 2

#Install the Server
if [[ ! -d /home/container/server ]] || [[ ${UPDATE} == "1" ]]; then
	if [[ -f /home/container/steam.txt ]]; then
		mkdir -p /home/container/steamcmd
		cd /home/container/steamcmd
		wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
		tar -zxvf steamcmd_linux.tar.gz
		rm -f steamcmd_linux.tar.gz
		chmod 777 *
		/home/container/steamcmd/steamcmd.sh +login ${STEAM_USER} ${STEAM_PASS} +force_install_dir /home/container/server +app_update ${APP_ID} validate +runscript /home/container/steam.txt
	else
		mkdir -p /home/container/steamcmd
		cd /home/container/steamcmd
		wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
		tar -zxvf steamcmd_linux.tar.gz
		rm -f steamcmd_linux.tar.gz
		chmod 777 *
		/home/container/steamcmd/steamcmd.sh +login ${STEAM_USER} ${STEAM_PASS} +force_install_dir /home/container/server +app_update ${APP_ID} validate +quit
	fi
fi

if [[ -f /home/container/preflight.sh ]]; then
	/home/container/preflight.sh
fi

# Replace Startup Variables
MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
echo "~/server: ${MODIFIED_STARTUP}"

cd /home/container/server

# $NSS_WRAPPER_PASSWD and $NSS_WRAPPER_GROUP have been set by the Dockerfile
export USER_ID=$(id -u)
export GROUP_ID=$(id -g)

# Run the Server
${MODIFIED_STARTUP}

if [ $? -ne 0 ]; then
    echo "PTDL_CONTAINER_ERR: There was an error while attempting to run the start command."
    exit 1
fi
