# ----------------------------------
# Pterodactyl Dockerfile
# Environment: RVR4
# Minimum Panel Version: 0.6.0
# ----------------------------------
FROM        ubuntu:16.04

MAINTAINER  Pterodactyl Software, <support@pterodactyl.io>
ENV         DEBIAN_FRONTEND noninteractive
ENV         USER_NAME container

# Install Dependencies
RUN         apt-get update \
            && apt-get install -y lib32gcc1 lib32stdc++6 wget tar curl \
            && adduser -D -h /home/container container \
            && mkdir -p /home/container/steamcmd \
            && wget http://media.steampowered.com/installer/steamcmd_linux.tar.gz \
            && tar -zxvf steamcmd_linux.tar.gz -d /home/container/steamcmd \
            && rm -f steamcmd_linux.tar.gz

USER        container
ENV         HOME /home/container
WORKDIR     /home/container

COPY        ./entrypoint.sh /entrypoint.sh
CMD         ["/bin/bash", "/entrypoint.sh"]
