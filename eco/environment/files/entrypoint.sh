#!/bin/bash

RED="\e[31m"
GREEN="\e[32m"
ENDCOLOR="\e[0m"
CYAN='\033[0;36m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NICEC="\e[38;5;219m"
NICEC2="\e[38;5;223m"
NID_DEB=$(. /etc/os-release; echo "$NAME")
NID_DEBVER=$(cat /etc/debian_version)
NID_DEBEDI=$(. /etc/os-release; echo "$VERSION_CODENAME")
S32D=/home/container/.steam/sdk32/steamclient.so
S64D=/home/container/.steam/sdk64/steamclient.so
alreadyUpdated=false
EcoServer=/home/container/server/EcoServer

fix_interop() {
  echo -e "${YELLOW}Checking for${ENDCOLOR} ${GREEN}incompatible${ENDCOLOR} ${YELLOW}files.${ENDCOLOR}"
  find "$HOME" -type f -name "SQLite.Interop.dll" \
    -exec sh -c 'echo "Deleting incompatible: $1"; rm "$1"' _ {} \;
}

steamInit(){
    # need to run just for steamcmd update otherwise it gets sometimes stuck on getting user info
    echo -e "${NICEC}STEAM INIT AND SELF UPDATE, PLEASE WAIT ...${ENDCOLOR}"

    if [ "$STEAM_FEEDBACK" = true ]; then
      /home/container/steamcmd/steamcmd.sh +login anonymous +quit
    else
      mkdir -p /home/container/server/Logs
      /home/container/steamcmd/steamcmd.sh +login anonymous +quit > /home/container/server/Logs/steamLatest.log 2>&1

    fi
}

runSteam()
{
    echo -e "${YELLOW}Running Steam.${ENDCOLOR}"
    echo -e "${GREEN}Steam update log will be available in${ENDCOLOR} ${CYAN}steamLatest.log ${ENDCOLOR}"
    echo -e "${YELLOW}PLEASE WAIT ...${ENDCOLOR}"

    if [ ! -f "$S32D" ]; then
    	echo "Linking 32 bit steam dependencies."
    	ln -s /home/container/steamcmd/linux32/steamclient.so /home/container/.steam/sdk32/steamclient.so
    fi

    if [ ! -f "$S64D" ]; then
    	echo "Linking 64 bit steam dependencies."
       ln -s /home/container/steamcmd/linux64/steamclient.so /home/container/.steam/sdk64/steamclient.so
    fi

    if [ "$STEAM_FEEDBACK" = true ]; then
         echo -e "${NICEC2}=========================================================${ENDCOLOR}"
         echo -e "${NICEC}APP UPDATE CHECK ...${ENDCOLOR}"
         /home/container/steamcmd/steamcmd.sh +force_install_dir /home/container/server +login anonymous \
         $( [[ "${WINDOWS_INSTALL}" == "1" ]] && printf %s '+@sSteamCmdForcePlatformType windows' ) \
         +app_update 739590 -beta ${VERSION_BRANCH} validate +quit
      else
         mkdir -p /home/container/server/Logs

         echo -e "App update check"
         /home/container/steamcmd/steamcmd.sh +force_install_dir /home/container/server +login anonymous \
         $( [[ "${WINDOWS_INSTALL}" == "1" ]] && printf %s '+@sSteamCmdForcePlatformType windows' ) \
         +app_update 739590 -beta ${VERSION_BRANCH} validate +quit > /home/container/server/Logs/steamLatest.log 2>&1
    fi

    echo -e "${BLUE}Completed.${ENDCOLOR}"
    echo -e "${YELLOW}Steam completed its operations.${ENDCOLOR}"
}

echo -e "${YELLOW}=========================================================${ENDCOLOR}"
echo -e "Container's OS:     ${GREEN}${NID_DEB}${ENDCOLOR} ${NICE2}${NID_DEBEDI^}${ENDCOLOR}${NICEC} ${NID_DEBVER}${ENDCOLOR}"
echo -e "Container's Layout: by ${GREEN}nidaren (c) 2026${ENDCOLOR}"
echo -e "Support link:       ${NICEC}https://discord.nidaren.net${ENDCOLOR}"
echo -e "${YELLOW}=========================================================${ENDCOLOR}"

#case $VERSION_BRANCH in
#    release|staging|playtest) echo -e "${YELLOW}Selected branch is:${ENDCOLOR} ${BLUE}$VERSION_BRANCH${ENDCOLOR}" ;;
#    *) echo "VERSION_BRANCH must be: release, staging or playtest." && exit 1 ;;
#esac

steamInit

if [ ! -f "$EcoServer" ]; then
    echo -e "${YELLOW}EcoServer does not exist. Will download.${ENDCOLOR}"
    alreadyUpdated=true
    runSteam
fi

if [ "$UPDATE_SERVER" = true ] && [ -f "$EcoServer" ] && [ "$alreadyUpdated" = false ]; then
    echo -e "${YELLOW}Checking for updates ...${ENDCOLOR}"
    runSteam
fi

if [ "$FORCE_CHECK" = true ]; then
    echo -e "${YELLOW}Force integrity check requested ...${ENDCOLOR}"
    runSteam
fi

fix_interop

cd /home/container/server

echo -e "${NICEC}Server will now start.${ENDCOLOR}"
exec ./EcoServer -userToken="${ECO_TOKEN}"
