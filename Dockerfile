# ----------------------------------
# Pterodactyl Dockerfile
# Environment: RVR4
# Minimum Panel Version: 0.6.0
# ----------------------------------
FROM        ubuntu:16.04

MAINTAINER  Pterodactyl Software, <support@pterodactyl.io>
ENV         DEBIAN_FRONTEND noninteractive

# Install Dependencies
RUN 		echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN         dpkg --add-architecture i386 \
            && apt-get update \
            && apt-get upgrade -y \
            && apt-get install -y sudo tar curl gcc g++ lib32gcc1 lib32tinfo5 lib32z1 lib32stdc++6 libtinfo5:i386 libncurses5:i386 libcurl3-gnutls:i386 \
            && adduser --disabled-password --uid 15000 --gid 0 --gecos container container \
			&& adduser container sudo \
			&& echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER        container
COPY        ./entrypoint.sh /entrypoint.sh
CMD         ["/bin/bash", "/entrypoint.sh"]