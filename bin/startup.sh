#!/bin/bash -e

# start uo script for /etc/rc.local
# sudo su -l pi -c "exec /home/pi/mobile-proxy/bin/startup.sh"

echo Starting modem control panel
cd ~/mobile-proxy/change-ip
npm start > output/weblet.log &

echo Setting up SSH tunnels
~/mobile-proxy/bin/ssh-tunnels.sh
