#!/bin/bash -e

echo WARNING
echo Generate a new key and upload it to the server. The server must be ready to accept it.
echo Do not proceed if not sure!
read -p "Press Enter to generate a new key or ^C to stop"

srv_user={srv_user}
srv1_port={srv1_port}
srv1_host={srv1_host}
prv_key=~/mobile-proxy/other/mobileproxy_id_rsa
pub_key=~/.ssh/id_rsa.pub

echo Saving old key
cp ~/.ssh/id_rsa ~/.ssh/id_rsa.old
cp ~/.ssh/id_rsa.pub ~/.ssh/id_rsa.pub.old

echo Creating new key
echo -e 'y\n' | ssh-keygen -f ~/.ssh/id_rsa -N ""
cat $pub_key >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

echo Uploading public key
scp -i $prv_key -P $srv1_port $pub_key $srv_user@$srv1_host:~/my_id_rsa.pub
ssh -i $prv_key -p $srv1_port $srv_user@$srv1_host 'cat my_id_rsa.pub > .ssh/authorized_keys && rm my_id_rsa.pub'

echo Connecting with new key
ssh -p $srv1_port $srv_user@$srv1_host 'echo'

echo Deleting old key
rm  ~/.ssh/id_rsa.old
rm ~/.ssh/id_rsa.pub.old
