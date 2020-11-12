#!/bin/bash -e

echo Starting modem control panel
cd ~/mobile-proxy/change-ip
npm start > output/weblet.log &

echo Setting up SSH tunnels
~/mobile-proxy/bin/ssh-tunnels.sh
