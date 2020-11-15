#!/bin/bash -e

# start uo script for /etc/rc.local
# sudo su -l pi -c "exec /home/pi/mobile-proxy/unit/startup.sh"

echo Starting modem control panel
cd ~/mobile-proxy/change-ip
npm start > output/weblet.log &

echo Preparing to SHH
echo "" > ~/.ssh/known_hosts

echo Starting SSH tunnels
~/mobile-proxy/unit/ssh-tunnels.sh
