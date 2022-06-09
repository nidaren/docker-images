# eco-chronicler

<b><u>Please note:</b></u> Image contains all needed prerequisites to run Chronicler with Eco, but
the plugin itself as well as any additional files need to be downloaded and added as per Pterodactyl's
requirements.

<u>Content:</u>
<br>`files` folder contains all the objects needed to build the image.

- `Chronicler.eco` initial configuration file - normally not required but in docker environment it ensures that proper path is established for the initial database.
- `entrypoint.sh` - contains routine needed by Pterodactyl to run its egg correctly.
- `libSQLite.Interlop.dll.so` - linux shared object library,required to run Chronicler. Compiled for the underlying system from SQLight source: `sqlite-netFx-full-source-1.0.116.0`.