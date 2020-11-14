#!/bin/bash -e

# change password for SSH and all services

if [ -z "$1" ]
then
    echo Use: change-pwd {{password}}
    exit 1
fi

pwd=$1
if [ ${{#pwd}} -ne 8 ]
then
    echo Password must be 8 characters long
    exit 1
fi

squid_file=/etc/squid/passwords
cp_file=~/mobile-proxy/change-ip/passwords

encpwd=$(openssl passwd -crypt $pwd)

echo Patching $squid_file
echo proxy:$encpwd | sudo tee $squid_file

echo Patching $cp_file
echo admin:$pwd > $cp_file

echo Updating SSH password
