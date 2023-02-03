

# Eco Server Docker Images

### nidaren/eco-server:environment

This image is version agnostic, it can run **any branch or version** *selected automatically* or *specified* by the user. 

**It will be downloaded and applied as per the docker-compose file or local user files will be used if present.**

**Contrary to official docker builds of Eco Server, these images offer *proper signal handling*, this means that whenever SIGINT *(cltr+c)* or SIGTERM, or any other termination signal is sent, proper Server saving will occur and a clean exit.**

My docker images **contain all the dependencies** which enable running of mods **dependent on SQLite** like *Chronicler*.

I strongly advise to use **Docker Compose** or similar service, to deploy your containers. They have added startup logic as well as some settings.

**IMPORTANT:** Make sure you **use proper docker compose** file, written specifically for the **image type** it uses. They are available below.

**Chronicler users:** **SQLite.Interop.dll** from **Mods/Chronicler** folder will be automatically deleted, as this library is NOT compatible with Linux!

If local server files are present, these will be used.

**Functionality:**
*  Exposes entire Server Root
* Contains everything for mods dependent on **SQLite** like *Chronicler*.
* Ports for `game server`, `webserver`, `RCON` are all available.
* Proper **termination signal handling** - each time `SIGINT`, `SIGTERM` is received by any process, server is saved properly.
* Fast SteamCMD that remembers its update status within container.
* Exposes **environmental variables**: 
  * **`VERSION_BRANCH`** - accepts string: release, playtest, staging - version of the server to download.
  * **`UPDATE_SERVER`** - accepts true/false - Checks for server updates on the selected branch before running the Server.
  * **`STEAM_FEEDBACK`** - accepts true/false - steamcmd output in console, when false it saves it to Logs/latestSteam.log.

**Please use the following docker-compose file: https://pastebin.com/MZqhkH1B**

```yaml
version: '3.8'

services:
  eco-server-environment:
    container_name: eco-server-env
    image: nidaren/eco-server:environment
    restart: unless-stopped
    # comment out both stdin_opn and tty if you don't need these functionalities.
    # both work in detached mode (-d) when attaching to the container
    stdin_open: true # interactive: allows to input keyboard commands to the container in (-d) detached mode.
    tty: true        # tty: pseudo terminal, needed if using stdin_open, adds colors as well.
    volumes:
    # Exposes root of the Server
    # source - host, target - container
    # you can freely change source (host) but don't change target!
      - type: bind
        source: ./eco-server    # source - location on the host
        target: /home/container/server # target - DON'T modify, location inside container
    environment:
      VERSION_BRANCH: release # release, playtest, staging - version of the server to download
      UPDATE_SERVER: true # Checks for server updates on the selected branch before running the Server
      STEAM_FEEDBACK: false # steamcmd output in console, when false it saves it to Logs/latestSteam.log
    ports:
      # Ports to be assigned in format host:container
      - "3000:3000/udp" # GameServerPort from Network.eco
      - "3001:3001/tcp" # WebServerPort from Network.eco
      - "3002:3002/tcp" # RconServerPort from Network.eco
```

# Pterodactyl

### nidaren/pterodactyl:eco-chronicler

Images in this set are designed to work with 
*Pterodactyl hosting environment* and not suitable to run without it. 

This docker image is designed to be used with *Eco egg* 
available in Pterodactyl eggs library *by default*.<br>
It adds required Linux shared objects to enable running of Chronicler plugin, which would otherwise crash,
reporting missing libraries.

**Usage:**

1. In Pterodactyl panel, in the ***Custom* Image** field, paste the docker image link.
2. Stop the server, download Chronicler, upload to Mods folder.
3. Run your Eco egg.

**IMPORTANT:** **SQLite.Interop.dll** from **Mods/Chronicler** folder will be automatically deleted, as this library is NOT compatible with Linux!

**Please note:** Image contains all needed prerequisites to run Chronicler with Eco, but
the plugin itself as well as any additional files need to be downloaded and added as per Pterodactyl's
requirements.