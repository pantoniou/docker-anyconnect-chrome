#!/bin/bash
sudo dbus-daemon --system --fork && \
./start-vpn.sh -s foo.com -g work-group -u john && \
/usr/bin/google-chrome-stable && \
./stop-vpn.sh
