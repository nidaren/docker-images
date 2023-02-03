FROM        debian:buster-slim

LABEL       org.opencontainers.image.authors="rafal@nidaren.net"
LABEL       org.opencontainers.image.source="https://github.com/nidaren/docker-images"
LABEL       org.opencontainers.image.version="1.2"
LABEL       org.opencontainers.image.vendor="discord.nidaren.net"
LABEL       org.opencontainers.image.description="Eco Server container by nidaren."

COPY        ["./files/entrypoint.sh", "./files/libSQLite.Interop.dll.so", "./files/Chronicler.eco", "./"]

RUN         apt update && apt upgrade -y && apt install -y --no-install-recommends \
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
			   && wget --no-check-certificate https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb -O 	packages-microsoft-prod.deb \ 
			   && dpkg -i packages-microsoft-prod.deb \ 
			   && rm packages-microsoft-prod.deb \
			   && apt update -y \ 
			   && apt install -y --no-install-recommends aspnetcore-runtime-5.0 libgdiplus \ 
			   && update-locale lang=en_US.UTF-8 \ 
			   && dpkg-reconfigure --frontend noninteractive locales \ 
			   && useradd -m -d /home/container -s /bin/bash container \ 
			   && mkdir -p /mnt/server/Configs \ 
			   && mkdir -p /mnt/server/Storage \ 
			   && cp /libSQLite.Interop.dll.so /usr/lib \ 
			   && chmod +x /entrypoint.sh \
			   && cp /Chronicler.eco /mnt/server/Configs \ 
			   && rm /libSQLite.Interop.dll.so \ 
			   && rm /Chronicler.eco

USER        container
ENV         USER=container HOME=/home/container
ENV         DEBIAN_FRONTEND noninteractive

WORKDIR     /home/container

CMD         [ "/bin/bash", "/entrypoint.sh" ]