#!/bin/bash -e

echo WARNING
echo This script installs packages and applies config overwriting existing files.
echo It meant to run only once on a clean operating system.
echo You need to know the exact configuration parameters and the key GPG password.
echo The remote server must be ready to accept the key and SSH tunnels from this unit.
echo.

marker=~/mp-installed
if [ -f $marker ]; then
  echo Install is already complete, to re-install remove $marker and re-run this script
  exit 1
fi

if [ -z "$1" ]
then
    echo Use: install.sh {remote_user} {remote_port} {unit_password}
    exit 1
fi

read -p "Press Enter to proceed or ^C to stop"

remote_user=$1
remote_port=$2
$password=$3

echo.
echo Installing packages
sudo apt-get -y install curl nano squid openvpn nodejs npm python3 git autossh

echo.
echo Downloading project
cd ~
git clone https://github.com/2nolife/mobile-proxy.git

echo.
echo Unpacking project key
read -p "You will now be asked for the key GPG password, press Enter to proceed"
cd ~/mobile-proxy/other
gpg mobileproxy_id_rsa.gpg
chmod 400 mobileproxy_id_rsa

echo.
echo Congiguring SSH
cd ~/.ssh
ssh-keygen -f id_rsa -N "" -y
chmod 400 id_rsa
echo "" > config
echo "Host *" >> config
echo "  StrictHostKeyChecking no" >> config
chmod 400 config

echo.
echo Configuring Squid
cd /etc/squid
sudo cp -n squid.conf squid.default.conf
sudo cp ~/mobile-proxy/other/squid.conf squid.conf
sudo touch passwords
sudo touch trusted.txt
sudo touch banned.txt

echo.
echo Configuring Control Panel
cd ~/mobile-proxy/change-ip
mkdir output
npm install

echo.
echo Configuring VPN
read -p "You will now be asked for VPN settings, press Enter to proceed"
cd ~
curl -O https://raw.githubusercontent.com/Angristan/openvpn-install/master/openvpn-install.sh
chmod +x openvpn-install.sh
udo ./openvpn-install.sh
rm openvpn-install.sh
mv *.ovpn ~/mobile-proxy/unit

echo.
echo Configuring project
cd ~/mobile-proxy/bin
python3 setup.py $remote_user $remote_port
cd /etc
sudo cp -n rc.local rc.local.old
sudo cp ~/mobile-proxy/other/rc.local rc.local
cd ~/mobile-proxy/unit
/change-pwd.sh $password
/change-key.sh

echo.
echo Finalising
cd ~
touch mp-installed

echo.
read -p "All done, press Enter to reboot or ^C to stop"
sudo reboot
