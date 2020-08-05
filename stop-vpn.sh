#!/bin/bash

PIDF="openconnect-server-pid"

if [ ! -f ${PIDF} ] ; then
	echo "No $PIDF file with running server PID"
	exit 5
fi

echo "Locating running instance of openconnect"
PIDS=$(pidof `sudo which openconnect`)
SPID=$(cat "$PIDF")
APID=0
for PID in $PIDS ; do
	if [ "x$PID" == "x$SPID" ]; then
		echo "Stopping running openconnect client with PID $SPID"
		APID="$PID"
	fi
done

if [ $APID -eq 0 ]; then
	echo "No running openconnect server found with PID $SPID"
	exit 5
fi

echo "Terminating openconnect instance with PID $APID gracefully (max 10 sec)"

sudo kill -SIGINT $APID
timeout 10 tail --pid=$APID -f /dev/null

# checking to see if the openconnect instance terminated gracefully
PIDS=$(pidof `sudo which openconnect`)
for PID in $PIDS ; do
	if [ "x$PID" == "x$APID" ]; then
		echo "Failed to stop running openconnect client with PID $SPID gracefully"
		exit 5
	fi
done

sudo ifconfig tun1 down
sudo openvpn --rmtun --dev tun1
