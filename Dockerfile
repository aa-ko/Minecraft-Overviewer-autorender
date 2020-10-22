# Build Minecraft-Overviewer from source
FROM ubuntu:focal-20200925 AS build

RUN apt-get update
RUN apt-get -y install wget git build-essential python3 python3-dev python3-pil python3-numpy
RUN mkdir /overviewer
WORKDIR /overviewer
RUN git clone --branch v0.16.0 --depth 1 https://github.com/overviewer/Minecraft-Overviewer.git /overviewer
RUN python3 setup.py build

# (Optionally) mount config file
#VOLUME /config

# Copy renderer script
FROM ubuntu:focal-20200925

ENV MC_VERSION=1.16.3

# Mount world directory from host read-only
VOLUME /world
# Mount tmpfs for caching render artifacts
VOLUME /cache
# Mount target directory (web-server root) from host with write permissions
VOLUME /render

RUN apt-get update
RUN apt-get -y install wget rsync python3 python3-pip python3-pil python3-numpy

COPY --from=build /overviewer /overviewer
COPY render.py /overviewer
COPY docker-requirements.txt /overviewer
WORKDIR /overviewer
RUN pip3 install -r docker-requirements.txt

RUN mkdir -p ~/.minecraft/versions/${MC_VERSION}/
RUN wget https://overviewer.org/textures/${MC_VERSION} -O ~/.minecraft/versions/${MC_VERSION}/${MC_VERSION}.jar

CMD ["python3", "./render.py"]
