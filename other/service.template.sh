#!/bin/bash -e

if [ -z "$1" ]
then
    echo Use: service.sh {{action}} {{name}}
    exit 1
fi

action=$1
name=$2

file=~/mobile-proxy/unit/ssh-tunnels.sh
if [ $action = 'disable' ]; then
  echo Disabling $name port
  sed -i "s/enable_$name=y/enable_$name=n/" $file
else
  echo Enabling $name port
  sed -i "s/enable_$name=n/enable_$name=y/" $file
fi
