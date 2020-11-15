#!/bin/bash -e

srv_user={srv_user}
srv1_port={srv1_port}
srv1_host={srv1_host}
prv_key=~/mobile-proxy/other/mobileproxy_id_rsa
pub_key=~/.ssh/id_rsa.pub

echo Creating new key
ssh-keygen -f ~/.ssh/id_rsa -N "" -y
cat $pub_key >> ~/.ssh/authorized_keys
chmod og-wx ~/.ssh/authorized_keys

echo Uploading public key
scp -i $prv_key -P $srv1_port $pub_key $srv_user@$srv1_host:~/my_id_rsa.pub
ssh -i $prv_key -p $srv1_port $srv_user@$srv1_host 'cat my_id_rsa.pub > .ssh/authorized_keys && rm my_id_rsa.pub'
