FROM        debian:bookworm-slim

COPY        ["./files", "/tmp/files"]

ARG         BUILD_DATE

LABEL       org.label-schema.schema-version="1.0"
LABEL       org.label-schema.build-date=$BUILD_DATE
LABEL       org.label-schema.name="ECO Server"
LABEL       org.label-schema.description="Eco Server container by nidaren."
LABEL       org.label-schema.url="https://discord.nidaren.net"
LABEL       org.label-schema.vcs-url="https://github.com/nidaren/docker-images"
LABEL       org.label-schema.vendor="nidaren"
LABEL       org.label-schema.version="1.3"

RUN         dpkg --add-architecture i386 \
            && apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends \
               ca-certificates libcurl4-gnutls-dev:i386 libcurl4:i386 libcurl3-gnutls:i386 libcurl4 \
               libc6 lib32gcc-s1 libstdc++6:i386 libicu72 libssl3 libstdc++6 \
               wget tzdata locales \
               lib32stdc++6 \
            && useradd -m -d /home/container -s /bin/bash container \
            && wget --no-check-certificate https://aka.ms/dotnet-counters/linux-x64 -O /usr/bin/dotnet-counters \
            && wget --no-check-certificate https://aka.ms/dotnet-dump/linux-x64 -O /usr/bin/dotnet-dump \
            && wget --no-check-certificate https://aka.ms/dotnet-trace/linux-x64 -O /usr/bin/dotnet-trace \
            && chmod +x /usr/bin/dotnet-counters \
            && chmod +x /usr/bin/dotnet-trace \
            && chmod +x /usr/bin/dotnet-dump \
            && wget --no-check-certificate \
               https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb \
               -O packages-microsoft-prod.deb \
            && dpkg -i packages-microsoft-prod.deb \
            && rm packages-microsoft-prod.deb \
            && mkdir /opt/profiling \
            && wget --no-check-certificate \
               https://download.jetbrains.com/resharper/dotUltimate.2022.3.2/JetBrains.dotTrace.CommandLineTools.linux-x64.2022.3.2.tar.gz\
               -O JetBrains.dotTrace.CommandLineTools.linux-x64.2022.3.2.tar.gz \
            && tar -zxvf JetBrains.dotTrace.CommandLineTools.linux-x64.2022.3.2.tar.gz -C /opt/profiling \
            && rm JetBrains.dotTrace.CommandLineTools.linux-x64.2022.3.2.tar.gz \
            && wget --no-check-certificate \
                https://download.jetbrains.com/resharper/dotUltimate.2022.3.2/JetBrains.dotMemory.Console.linux-x64.2022.3.2.tar.gz -O JetBrains.dotMemory.Console.linux-x64.2022.3.2.tar.gz \
            && tar -zxvf JetBrains.dotMemory.Console.linux-x64.2022.3.2.tar.gz -C /opt/profiling \
            && rm JetBrains.dotMemory.Console.linux-x64.2022.3.2.tar.gz \
            && apt-get update && apt-get upgrade -y \
            && apt-get install -y --no-install-recommends aspnetcore-runtime-7.0 libgdiplus \
            && sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen \
            && update-locale lang=en_US.UTF-8 \
            && dpkg-reconfigure --frontend noninteractive locales \
            && rm -rf /var/lib/apt/lists/* \
            && cd /tmp \
            && mv /tmp/files/libSQLite.Interop.dll.so /usr/lib \
            && mv /tmp/files/entrypoint.sh / \
            && chmod +x /entrypoint.sh \
            && mkdir -p /home/container/server \
            && mkdir -p /home/container/steamapps \
            && mkdir -p /home/container/steamcmd \
            && mkdir -p /home/container/.steam/sdk32 \
            && mkdir -p /home/container/.steam/sdk64 \
            && wget --no-check-certificate https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz -O steamcmd.tar.gz \
            && tar -xzvf steamcmd.tar.gz -C /home/container/steamcmd \
            && rm steamcmd.tar.gz \
            && cd /home/container \
            && chown -R container:container /home/container

USER        container
ENV         USER=container HOME=/home/container VERSION_BRANCH=release UPDATE_SERVER=true STEAM_FEEDBACK=false PATH="${PATH}:/opt/profiling"

WORKDIR     /home/container

ENTRYPOINT [ "/entrypoint.sh" ]
