#!/usr/bin/env bash

echo "Searching for Docker image ..."
DOCKER_IMAGE_ID=$(docker images --format="{{.ID}}" docker-anyconnect-chrome:latest | head -n 1)
echo "Found and using ${DOCKER_IMAGE_ID}"

USER_UID=$(id -u)

mkdir -p "${TMP}/config" "${TMP}/cache"

docker run -t -i \
   -e DISPLAY=$DISPLAY \
   -e AUTHSERVER="$AUTHSERVER" \
   -e AUTHGROUP="$AUTHGROUP" \
   -e AUTHUSER="$AUTHUSER" \
  --volume /tmp/.X11-unix:/tmp/.X11-unix \
  --volume /run/user/${USER_UID}/pulse:/run/user/1000/pulse \
  --volume /etc/machine-id:/etc/machine-id \
  --volume ~/.pulse:/home/user/.pulse \
  --volume ~/.pulsecookie:/home/user/.pulsecookie \
  --volume /var/lib/dbus:/var/lib/dbus \
  --mount type=bind,source=${TMP}/config,target=/home/user/.config \
  --mount type=bind,source=${TMP}/cache,target=/home/user/.cache \
  --mount type=bind,source="${HOME}"/Downloads,target=/home/user/Downloads \
  --cap-add NET_ADMIN --device /dev/net/tun --privileged \
  --ipc host \
  ${DOCKER_IMAGE_ID} \
  ${@}
