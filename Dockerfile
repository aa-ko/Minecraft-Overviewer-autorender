FROM debian:stable

# Minecraft world directory
VOLUME /world
# Render cache
VOLUME /cache
# Render target directory / web-server root
VOLUME /render

RUN apt update
RUN apt install -y --no-install-recommends curl rsync git build-essential python3 python3-pip python3-dev python3-pil python3-numpy

ENV MC_VERSION=1.19.2
RUN mkdir -p ~/.minecraft/versions/${MC_VERSION}/
RUN curl https://overviewer.org/textures/${MC_VERSION} -o ~/.minecraft/versions/${MC_VERSION}/${MC_VERSION}.jar

COPY Minecraft-Overviewer /overviewer
WORKDIR /overviewer
RUN python3 setup.py build

COPY autorender.py /overviewer/

CMD ["python3", "-u", "./autorender.py"]
