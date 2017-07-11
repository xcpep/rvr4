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
            && apt-get install -y apt-utils \
            && apt-get install -y lib32gcc1 lib32stdc++6 wget tar curl \
            && useradd -m -d /home/container container \
            && mkdir -p /home/container/steamcmd \
            && cd /home/container/steamcmd \
            && wget -q -O - "http://media.steampowered.com/installer/steamcmd_linux.tar.gz" | tar xz & \
            && rm -f steamcmd_linux.tar.gz

USER        container
ENV         HOME /home/container
WORKDIR     /home/container

COPY        ./entrypoint.sh /entrypoint.sh
CMD         ["/bin/bash", "/entrypoint.sh"]
