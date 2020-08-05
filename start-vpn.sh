#!/bin/bash

while getopts "s:u:g:p:" OPTION; do
    case "$OPTION" in
    s)
        AUTHSERVER="$OPTARG"
        ;;
    u)
        AUTHUSER="$OPTARG"
        ;;
    g)
        AUTHGROUP="$OPTARG"
        ;;
    p)
	AUTHPASS="$OPTARG"
	;;
    *)
        echo "incorrect options (only -s -g -u supported)"
	exit 5
        ;;
    esac
done

if [ "x$AUTHSERVER" == "x" -o "x${AUTHUSER}" == "x" -o "x${AUTHGROUP}" == "x" ]; then
	echo "AUTHSERVER AUTHUSER and AUTHGROUP variables must be set"
	exit 5
fi

sudo openvpn --mktun --dev tun1 || exit 5
sudo ifconfig tun1 up

if [ "x$AUTHPASS" == "x" ]; then
	AUTHPASS=`zenity --password --title="${AUTHGROUP}/${AUTHUSER}"`
	if [ $? -ne 0 ]; then
		echo "aborted password entry"
		exit 5
	fi
fi
echo "$AUTHPASS" | sudo openconnect "${AUTHSERVER}" --authgroup="${AUTHGROUP}" --user="${AUTHUSER}" \
	-b --pid-file="openconnect-server-pid" --passwd-on-stdin

if [ $? -ne 0 ]; then
	exit 5
fi

sleep 3
