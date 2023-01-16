FROM debian:11.6

RUN apt update
RUN apt install -y --no-install-recommends wget rsync git build-essential python3 python3-pip python3-dev python3-pil python3-numpy

COPY Minecraft-Overviewer /overviewer
WORKDIR /overviewer
RUN python3 setup.py build


# Minecraft world directory
VOLUME /world
# Render cache
VOLUME /cache
# Render target directory / web-server root
VOLUME /render

COPY autorender.py /overviewer/
COPY autorender-requirements.txt /overviewer/
RUN pip3 install -r autorender-requirements.txt

ENV MC_VERSION=1.19.2
RUN mkdir -p ~/.minecraft/versions/${MC_VERSION}/
RUN wget https://overviewer.org/textures/${MC_VERSION} -O ~/.minecraft/versions/${MC_VERSION}/${MC_VERSION}.jar

CMD ["python3", "-u", "./autorender.py"]
