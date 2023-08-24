#!/bin/bash

RED="\e[31m"
GREEN="\e[32m"
ENDCOLOR="\e[0m"
CYAN='\033[0;36m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'

alreadyUpdated=false
EcoServer=/home/container/server/EcoServer

runSteam()
{
    echo -e "${YELLOW}Running Steam.${ENDCOLOR}"
    echo -e "${GREEN}Steam update log will be available in${ENDCOLOR} ${CYAN}steamLatest.log ${ENDCOLOR}"
    echo -e "${YELLOW}PLEASE WAIT ...${ENDCOLOR}"
    if [ "$STEAM_FEEDBACK" = true ]; then
         /usr/games/steamcmd +force_install_dir /home/container/server +login anonymous \
         $( [[ "${WINDOWS_INSTALL}" == "1" ]] && printf %s '+@sSteamCmdForcePlatformType windows' ) \
         +app_update 739590 -beta ${VERSION_BRANCH} validate +quit
      else
         mkdir -p /home/container/server/Logs
         /usr/games/steamcmd +force_install_dir /home/container/server +login anonymous \
         $( [[ "${WINDOWS_INSTALL}" == "1" ]] && printf %s '+@sSteamCmdForcePlatformType windows' ) \
         +app_update 739590 -beta ${VERSION_BRANCH} validate +quit > /home/container/server/Logs/steamLatest.log
    fi
    echo -e "${BLUE}Completed.${ENDCOLOR}"
    echo -e "${YELLOW}Steam completed its operations.${ENDCOLOR}"
}

#case $VERSION_BRANCH in
#    release|staging|playtest) echo -e "${YELLOW}Selected branch is:${ENDCOLOR} ${BLUE}$VERSION_BRANCH${ENDCOLOR}" ;;
#    *) echo "VERSION_BRANCH must be: release, staging or playtest." && exit 1 ;;
#esac

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

FILE=/home/container/server/Mods/Chronicler/SQLite.Interop.dll

if [ -f "$FILE" ]; then
    echo -e "${YELLOW}Redundant Interlop dll removed from Chronicler.${ENDCOLOR}"
    rm "$FILE"
fi

cd /home/container/server

echo -e "${BLUE}Server will now start."
exec ./EcoServer
