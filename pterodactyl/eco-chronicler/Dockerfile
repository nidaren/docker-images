FROM        debian:buster-slim

ARG         BUILD_DATE

LABEL       org.label-schema.schema-version="1.0"
LABEL       org.label-schema.build-date=$BUILD_DATE
LABEL       org.label-schema.name="ECO Server"
LABEL       org.label-schema.description="Eco Server container by nidaren."
LABEL       org.label-schema.url="https://discord.nidaren.net"
LABEL       org.label-schema.vcs-url="https://github.com/nidaren/docker-images"
LABEL       org.label-schema.vendor="nidaren"
LABEL       org.label-schema.version="1.3"

COPY        ["./files/entrypoint.sh", "./files/libSQLite.Interop.dll.so", "./"]

RUN         DEBIAN_FRONTEND=noninteractive \
            apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends \
               gcc \ 
	       g++ \ 
	       libgcc1 \ 
	       lib32gcc1 \
	       libc++-dev \ 
	       gdb \
	       libc6 \
	       git \
	       wget \
	       curl \
	       tar \
	       zip \
	       unzip \
	       binutils \
	       xz-utils \
	       liblzo2-2 \
	       cabextract \
	       iproute2 \
	       net-tools \
	       netcat \
	       telnet \
	       libatomic1 \
	       libsdl1.2debian \
	       libsdl2-2.0-0 \
               libfontconfig \
	       libicu63 \
	       icu-devtools \
	       libunwind8 \
	       libssl-dev \
	       sqlite3 \
	       libsqlite3-dev \
	       libmariadbclient-dev \
	       libduktape203 \
	       locales \
	       gnupg2 \
	       apt-transport-https \
	       software-properties-common \
	       ca-certificates \
	       tzdata \
	       liblua5.3 \
               libz-dev \
	       rapidjson-dev \ 
	    && wget --no-check-certificate \ 
               https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb \
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
            && wget --no-check-certificate https://aka.ms/dotnet-counters/linux-x64 -O /usr/bin/dotnet-counters \
            && wget --no-check-certificate https://aka.ms/dotnet-dump/linux-x64 -O /usr/bin/dotnet-dump \
            && wget --no-check-certificate https://aka.ms/dotnet-trace/linux-x64 -O /usr/bin/dotnet-trace \
            && chmod +x /usr/bin/dotnet-counters \
            && chmod +x /usr/bin/dotnet-trace \
            && chmod +x /usr/bin/dotnet-dump \
	    && apt-get update -y \ 
	    && apt-get install -y --no-install-recommends aspnetcore-runtime-7.0 libgdiplus \ 
            && sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen \
	    && update-locale lang=en_US.UTF-8 \ 
	    && dpkg-reconfigure --frontend noninteractive locales \ 
	    && useradd -m -d /home/container -s /bin/bash container \ 
            && rm -rf /var/lib/apt/lists/* \
	    && mkdir -p /mnt/server/Configs \ 
	    && mkdir -p /mnt/server/Storage \ 
	    && cp /libSQLite.Interop.dll.so /usr/lib \ 
	    && chmod +x /entrypoint.sh \
	    && rm /libSQLite.Interop.dll.so

USER        container
ENV         USER=container HOME=/home/container PATH="${PATH}:/opt/profiling"
ENV         DEBIAN_FRONTEND noninteractive

WORKDIR     /home/container

CMD         [ "/bin/bash", "/entrypoint.sh" ]
