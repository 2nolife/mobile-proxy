#!/bin/bash -e

srv_user={srv_user}
srv1_port={srv1_port}
srv1_host={srv1_host}
prv_key=~/mobile-proxy/other/mobileproxy_id_rsa
pub_key=~/.ssh/id_rsa.pub

scp -i $prv_key -P $srv1_port $pub_key $srv_user@$srv1_host:~/my_id_rsa.pub
