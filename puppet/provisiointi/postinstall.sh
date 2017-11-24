#!/bin/bash

sleep 10

service puppet stop

hostnamectl set-hostname provorja

cat <<EOF > /etc/hosts

127.0.0.1       localhost
127.0.1.1       provorja
172.28.13.37    master2

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters

EOF

service avahi-daemon restart

cat <<EOF > /etc/puppet/puppet.conf

[main]
logdir=/var/log/puppet
vardir=/var/lib/puppet
ssldir=/var/lib/puppet/ssl
rundir=/run/puppet
factpath=$vardir/lib/facter
prerun_command=/etc/puppet/etckeeper-commit-pre
postrun_command=/etc/puppet/etckeeper-commit-post
node_name=cert

[master]
ssl_client_header = SSL_CLIENT_S_DN
ssl_client_verify_header = SSL_CLIENT_VERIFY

[agent]
server = master2.local

EOF

rm -r /var/lib/puppet/ssl
puppet agent --enable
service puppet restart
