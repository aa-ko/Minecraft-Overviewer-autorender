# Minecraft-Overviewer-autorender
This project is a simple wrapper around the [Minecraft-Overviewer](https://github.com/overviewer/Minecraft-Overviewer). It allows you to mount your Minecraft world into a Docker container and continuously re-render it. The sample [compose file](docker-compose.yml) will also spin up a caddy web server to serve the resulting render over HTTP.

You can find the pre-built docker image [here](https://hub.docker.com/r/aako/minecraft-overviewer-autorender).

## Usage
Simply mount your Minecraft world directory into `/world` inside the minecraft-overviewer-autorender container.

## Known issues and limitations
- Currently, only a single smooth-lighting render will be produced.
- You cannot render multiple worlds inside a single container right now.
- Changes inside the world directory during the rendering process sometimes lead to weird artifacts in the resulting render.

## TODO
- Make the image smaller.. a **lot** smaller!
- Rewrite 0.3.0 in Rust
- Sensible logging
- Prometheus endpoint