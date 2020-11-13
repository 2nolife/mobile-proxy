#!/bin/bash -e

# SSH tunnels for
#   SSH
#   Control Panel HTTP
#   HTTP proxy server
#   VPN server

srv1_port={srv1_port}
srv1_host={srv1_host}
prv_key=~/mobile-proxy/unit/{prv_key}

keep_a=ServerAliveInterval=10
keep_c=ServerAliveCountMax=3

port1={port1}
port2={port2}
port3={port3}
port4={port4}

echo SSH port
autossh -M 0 -fC -p $srv1_host -N -R 0.0.0.0:$port1:localhost:22 $srv1_port -o $keep_a -o $keep_c -i $prv_key

echo Modem CP port
autossh -M 0 -fC -p $srv1_host -N -R 0.0.0.0:$port2:localhost:8080 $srv1_port -o $keep_a -o $keep_c -i $prv_key

echo HTTP proxy port
autossh -M 0 -fC -p $srv1_host -N -R 0.0.0.0.0:$port3:localhost:3128 $srv1_port -o $keep_a -o $keep_c -i $prv_key

echo VPN port
autossh -M 0 -fC -p $srv1_host -N -R 0.0.0.0.0:$port4:localhost:1194 $srv1_port -o $keep_a -o $keep_c -i $prv_key
