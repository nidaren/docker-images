### nidaren/eco-server:environment

**Content:**

- `build-docker-image.sh` - builds the image.
- `docker-compose.yml`- sample configuration of the image.
- 'Dockerfile' :)

`files` folder contains all the objects needed to build the image.

- `sources.list`  - sources list for the underlying system. It contains sources enabling steamcmd download during image build.
- `entrypoint.sh` - contains routine required for this image, removing it is not supported and functionalities are lost when done so.
- `libSQLite.Interlop.dll.so` - linux shared object library,required to run Chronicler or any other SLQLite dependent mods. Compiled for the underlying system from SQLight source: `sqlite-netFx-full-source-1.0.116.0`.