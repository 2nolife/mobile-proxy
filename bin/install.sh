#!/bin/bash -e

echo WARNING
echo This script installs packages and applies config overwriting existing files.
echo It meant to run only once on a clean operating system.
echo You need to know the exact configuration parameters and the key GPG password.
echo The remote server must be ready to accept the key and SSH tunnels from this unit.
echo

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
password=$3

echo
echo Installing packages
sudo apt-get -y install curl nano squid openvpn nodejs npm python3 git autossh

echo
echo Downloading project
cd ~
if [ -d mobile-proxy ]; then
  echo mobile-proxy already exists, updating
  cd mobile-proxy
  git pull
else
  git clone https://github.com/2nolife/mobile-proxy.git
fi
cd ~/mobile-proxy
mkdir -p unit

echo
echo Decrypting project key
cd ~/mobile-proxy/other
if [ -f mobileproxy_id_rsa ]; then
  echo mobileproxy_id_rsa already exists
else
  read -p "You will now be asked for the key GPG password, press Enter to proceed"
  gpg mobileproxy_id_rsa.gpg
fi
chmod 400 mobileproxy_id_rsa

echo
echo Congiguring SSH
cd ~
mkdir -p .ssh
cd ~/.ssh
if [ -f id_rsa ]; then
  echo id_rsa already exists
else
  echo -e 'y\n' | ssh-keygen -f id_rsa -N ""
fi
chmod 600 id_rsa
echo > config
echo "Host *" >> config
echo "  StrictHostKeyChecking no" >> config
chmod 600 config

echo
echo Configuring Squid
cd /etc/squid
sudo cp -n squid.conf squid.default.conf
sudo cp ~/mobile-proxy/other/squid.conf squid.conf
sudo touch passwords
sudo touch trusted.txt
sudo touch banned.txt

echo
echo Configuring Control Panel
cd ~/mobile-proxy/change-ip
mkdir -p output
npm install

echo
echo Configuring VPN
read -p "You will now be asked for VPN settings, press Enter to proceed"
cd ~
curl -O https://raw.githubusercontent.com/Angristan/openvpn-install/master/openvpn-install.sh
chmod +x openvpn-install.sh
sudo ./openvpn-install.sh
rm openvpn-install.sh
mv *.ovpn ~/mobile-proxy/unit

echo
echo Configuring project
cd ~/mobile-proxy/bin
python3 setup.py $remote_user $remote_port
cd /etc
sudo cp -n rc.local rc.local.old
sudo cp ~/mobile-proxy/other/rc.local rc.local
cd ~/mobile-proxy/unit
/change-pwd.sh $password
/change-key.sh

echo
echo Finalising
cd ~
touch mp-installed

echo
read -p "All done, press Enter to reboot or ^C to stop"
sudo reboot
