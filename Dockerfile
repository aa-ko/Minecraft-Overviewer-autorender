FROM ubuntu:20.04

RUN apt-get update
RUN apt-get -y install wget rsync git build-essential python3 python3-pip python3-dev python3-pil python3-numpy

COPY Minecraft-Overviewer /overviewer
WORKDIR /overviewer
RUN python3 setup.py build

ENV MC_VERSION=1.16.3

# Mount world directory from host read-only
VOLUME /world
# Mount tmpfs for caching render artifacts
VOLUME /cache
# Mount target directory (web-server root) from host with write permissions
VOLUME /render

COPY autorender.py /overviewer
COPY docker-requirements.txt /overviewer
WORKDIR /overviewer
RUN pip3 install -r docker-requirements.txt

RUN mkdir -p ~/.minecraft/versions/${MC_VERSION}/
RUN wget https://overviewer.org/textures/${MC_VERSION} -O ~/.minecraft/versions/${MC_VERSION}/${MC_VERSION}.jar

CMD ["python3", "-u", "./render.py"]
