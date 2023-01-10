FROM ubuntu:22.04 as build

RUN apt update
RUN apt install -y --no-install-recommends wget rsync git build-essential python3 python3-pip python3-dev python3-pil python3-numpy
RUN rm -rf /var/lib/apt/lists/*

COPY Minecraft-Overviewer /overviewer
WORKDIR /overviewer
RUN python3 setup.py build


FROM alpine:3.17.1 as autorender

# From here:
# https://stackoverflow.com/a/62555259

ENV PYTHONUNBUFFERED=1
RUN apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python
RUN python3 -m ensurepip
RUN pip3 install --no-cache --upgrade pip setuptools

ENV MC_VERSION=1.19.2

# Minecraft world directory
VOLUME /world
# Render cache
VOLUME /cache
# Render target directory / web-server root
VOLUME /render

WORKDIR /overviewer

COPY --from=build /overviewer/ /overviewer/

COPY autorender.py /overviewer
COPY autorender-requirements.txt /overviewer
RUN pip3 install -r autorender-requirements.txt

RUN mkdir -p ~/.minecraft/versions/${MC_VERSION}/
RUN wget https://overviewer.org/textures/${MC_VERSION} -O ~/.minecraft/versions/${MC_VERSION}/${MC_VERSION}.jar

CMD ["python3", "-u", "./autorender.py"]
