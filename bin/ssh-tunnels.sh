#!/bin/bash -e

srv_port1=2424
srv_host1=intel@ha.kanalov.net
ssh_key=~/mobile-proxy/other/mobileproxy_id_rsa
keep_a=ServerAliveInterval=10
keep_c=ServerAliveCountMax=3

echo SSH port
autossh -M 0 -fC -p $srv_port1 -N -R 0.0.0.0:40000:localhost:22 $srv_host1 -o $keep_a -o $keep_c -i $ssh_key

echo Modem CP port
autossh -M 0 -fC -p $srv_port1 -N -R 0.0.0.0:40001:localhost:8080 $srv_host1 -o $keep_a -o $keep_c -i $ssh_key

echo HTTP proxy port
utossh -M 0 -fC -p $srv_port1 -N -R 0.0.0.0.0:40002:localhost:3128 $srv_host1 -o $keep_a -o $keep_c -i $ssh_key

echo VPN port
autossh -M 0 -fC -p $srv_port1 -N -R 0.0.0.0.0:40004:localhost:1194 $srv_host1 -o $keep_a -o $keep_c -i $ssh_key
