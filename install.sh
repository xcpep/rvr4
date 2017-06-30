#!/bin/bash
sleep 2

cd /home/container

if [[ ! -d server ]] || [[ ${UPDATE} == "yes" ]]; then
    cd steamcmd
    ./steamcmd.sh +login ${STEAM_USER} ${STEAM_PASS} +force_install_dir ../ +app_update ${APP_ID} validate +quit

	if [[ ! -d ../mpmissions ]]; then
		ln -s ../mpmissions ../MPMissions
	fi
	
	if [[ ! -f ../steamclient.so ]]; then
		rm ../steamclient.so
		ln -s ../steamcmd/linux32/steamclient.so ../steamclient.so
	fi
	
	mkdir ../cfg
	mkdir ../profiles
	
	cd ../
fi