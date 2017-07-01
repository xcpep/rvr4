#!/bin/bash
sleep 2

cd /home/container

if [[ ! -f ${SERVER_EXE} ]] || [[ ${UPDATE} == "yes" ]]; then
    cd steamcmd
    ./steamcmd.sh +login ${STEAM_USER} ${STEAM_PASS} +force_install_dir ../ +app_update ${APP_ID} validate +quit

	if [[ ! -d ../mpmissions ]]; then
		ln -s ../mpmissions ../MPMissions
	fi
	
	if [[ ! -f ../steamclient.so ]]; then
		rm ../steamclient.so
		ln -s ../steamcmd/linux32/steamclient.so ../steamclient.so
	fi
	
	if [[ ! -d ~/.local/share/ ]]; then
		mkdir -p ~/.local/share/
	fi
	
	if [[ ! -d ../cfg ]]; then
		mkdir -p ../cfg
	fi
	
	if [[ ! -d ../profiles ]]; then
		mkdir -p ../profiles
	fi
	
	cd ../
fi

# Replace Startup Variables
MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
echo ":/home/container$ ${MODIFIED_STARTUP}"

# Run the Server
${MODIFIED_STARTUP}

if [ $? -ne 0 ]; then
    echo "PTDL_CONTAINER_ERR: There was an error while attempting to run the start command."
    exit 1
fi