#!/bin/bash -e

if [ -z "$1" ]
then
    echo Use: service.sh {{action}} {{name}}
    exit 1
fi

action=$1
name=$2

if [ $action = 'disable' ]; then
  echo Disabling $name port
  switch=n
else
  echo Enabling $name port
  switch=y
fi
sed -i "s/enable_$name=$switch/enable_$name=$switch/" ~/mobile-proxy/unit/ssh-tunnels.sh
