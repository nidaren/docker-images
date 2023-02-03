FROM        debian:buster-slim

COPY        ["./files", "/tmp/files"]

LABEL       org.opencontainers.image.authors="rafal@nidaren.net"
LABEL       org.opencontainers.image.source="https://github.com/nidaren/docker-images"
LABEL       org.opencontainers.image.version="1.2"
LABEL       org.opencontainers.image.vendor="discord.nidaren.net"
LABEL       org.opencontainers.image.description="Eco Server container by nidaren."

RUN         mv /tmp/files/sources.list /etc/apt/sources.list && dpkg --add-architecture i386 \
            && echo steam steam/question select "I AGREE" | debconf-set-selections \
    	    && echo steam steam/license note '' | debconf-set-selections \
            && apt update && apt upgrade -y && apt install -y --no-install-recommends \
               ca-certificates \
               libc6 \
               libgcc1 \
               libgssapi-krb5-2 \
               libicu63 \
               libssl1.1 \
               libstdc++6 \
               zlib1g \
               lib32gcc1 \
               wget \
	           locales \
            && useradd -m -d /home/container -s /bin/bash container \
            && wget --no-check-certificate https://aka.ms/dotnet-counters/linux-x64 -O /usr/bin/dotnet-counters \
            && wget --no-check-certificate https://aka.ms/dotnet-dump/linux-x64 -O /usr/bin/dotnet-dump \
            && wget --no-check-certificate https://aka.ms/dotnet-trace/linux-x64 -O /usr/bin/dotnet-trace \
            && chmod +x /usr/bin/dotnet-counters \
            && chmod +x /usr/bin/dotnet-trace \
            && chmod +x /usr/bin/dotnet-dump \
            && wget --no-check-certificate \
               https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb \
               -O packages-microsoft-prod.deb \
            && dpkg -i packages-microsoft-prod.deb \
            && rm packages-microsoft-prod.deb \
            && apt update -y \
            && apt install -y --no-install-recommends aspnetcore-runtime-7.0 libgdiplus steamcmd \
            && update-locale lang=en_US.UTF-8 \
            && dpkg-reconfigure --frontend noninteractive locales \
            && rm -rf /var/lib/apt/lists/* \
            && cd /tmp \
            && mv /tmp/files/libSQLite.Interop.dll.so /usr/lib \
            && mv /tmp/files/entrypoint.sh / \
            && chmod +x /entrypoint.sh \
            && mkdir -p /home/container/steamcmd \
            && mkdir -p /home/container/steamapps \
            && mkdir -p /home/container/server \
            && chown -R container:container /home/container

USER        container
ENV         USER=container HOME=/home/container VERSION_BRANCH=release UPDATE_SERVER=true STEAM_FEEDBACK=false

WORKDIR     /home/container

ENTRYPOINT [ "/entrypoint.sh" ]
