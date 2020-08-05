FROM ubuntu:18.04
MAINTAINER Pantelis Antoniou <pantelis.antoniou@konsulko.com>

ENV UNAME user

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y wget gnupg2 sudo software-properties-common

RUN echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
	dbus-x11 packagekit-gtk3-module libcanberra-gtk-module libcanberra-gtk3-module \
	net-tools openvpn openconnect \
	zenity \
	pulseaudio-utils \
	google-chrome-stable

# Set up the user (and add it to the audio group)
RUN export UNAME=$UNAME UID=1000 GID=1000 && \
    mkdir -p "/home/${UNAME}" && \
    echo "${UNAME}:x:${UID}:${GID}:${UNAME} User,,,:/home/${UNAME}:/bin/bash" >> /etc/passwd && \
    echo "${UNAME}:x:${UID}:" >> /etc/group && \
    mkdir -p /etc/sudoers.d && \
    echo "${UNAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${UNAME} && \
    chmod 0440 /etc/sudoers.d/${UNAME} && \
    chown ${UID}:${GID} -R /home/${UNAME} && \
    gpasswd -a ${UNAME} audio && \
    mkdir -p /var/run/dbus

USER $UNAME
ENV HOME /home/user

COPY pulse-client.conf /etc/pulse/client.conf
COPY start-vpn.sh stop-vpn.sh vpn-chrome.sh /

CMD /vpn-chrome.sh
