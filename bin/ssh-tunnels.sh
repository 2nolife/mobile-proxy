#!/bin/bash -e

echo SSH port
autossh -M 0 -fC -p 2424 -N -R 0.0.0.0:40000:localhost:22 intel@ha.kanalov.net -o ServerAliveInterval=10 -o ServerAliveCountMax=3 -i ~/mobile-proxy/other/mobileproxy_id_rsa

echo Modem CP port
autossh -M 0 -fC -p 2424 -N -R 0.0.0.0:40001:localhost:8080 intel@ha.kanalov.net -o ServerAliveInterval=10 -o ServerAliveCountMax=3 -i ~/mobile-proxy/other/mobileproxy_id_rsa

echo HTTP proxy port
utossh -M 0 -fC -p 2424 -N -R 0.0.0.0.0:40002:localhost:3128 intel@ha.kanalov.net -o ServerAliveInterval=10 -o ServerAliveCountMax=3 -i ~/mobile-proxy/other/mobileproxy_id_rsa

echo VPN port
autossh -M 0 -fC -p 2424 -N -R 0.0.0.0.0:40004:localhost:1194 intel@ha.kanalov.net -o ServerAliveInterval=10 -o ServerAliveCountMax=3 -i ~/mobile-proxy/other/mobileproxy_id_rsa
