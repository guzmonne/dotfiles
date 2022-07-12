#!/usr/bin/env bash

mkdir -p ~/Comics/data
mkdir -p ~/Comics/comics
mkdir -p ~/Comics/downloads

docker run -d \
  --name=mylar3 \
  -e PUID=$(id -u) \
  -e PGID=$(id -g) \
  -p 8090:8090 \
  -v ~/Comics/data:/config \
  -v ~/Comics/comics:/comics \
  -v ~/Comics/downloads:/downloads \
  --restart unless-stopped \
  lscr.io/linuxserver/mylar3:latest
