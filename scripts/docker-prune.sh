#!/usr/bin/env bash

echo "Stopping containers"
docker stop "$(docker ps -aq)"
echo "Removing containers"
docker rm "$(docker ps -aq)"
echo "Removing volumes"
docker volume rm "$(docker volume ls -q)"
