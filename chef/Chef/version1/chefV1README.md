# What is V1?

This is the first tested version of our projects chef implementation and will only get bugfixes.

V1 contains a cookbook for instaling a webserver. It also has scripts for installing both ChefDK and ChefServer but network configuration must be done by hand.

## Installation

The Chef infrastructure model requires a minimum of 3 computers; a workstation, a server, and a node.

First install ChefDK to your workstation by using the provided script install-chefDK.sh in /version1/extra folder with

```
sudo bash install-cheDK.sh
```
then install ChefServer on your u/server/u by using instal-chef-server.sh from /version1/extra with

```
sudo bash install-chef-server.sh
```

Then copy the .pem files over to your workstation and modify your /version1/chef-repo/.chef/knife.rb to contain the pathto your credits.pem file.

Also modify your knife.rb to contain the address with which to contact the server with. The address needs to be FQDN or you'll have to modify the hosts files on your nodes and workstation to give the appropriate name to your machine. You can test the connection by entereing the following commands while in the /.chef folder 

```
knife ssl fetch

knife ssl check

```
which will first retrieve the SSL certification from your server and then check if the certification is valid. This wil tell you if your network configuration is sufficent for Chef or if you need to change something.

Once you cna validate teh certificates succesfully you can establish a node by bootstrapping it you'll need to be able to connect to the machine you want to bootstrap using IP or FQDN. Also the node needs to be able to call back to the server so if you had to make changes to hosts file on your workstation you might have to change it on your node aswell.

Regadless to bootstrap you node connetct to it with ssh from your workstation with the command

```
knife bootstrap USER@IP_ADDRESS -N NODENAME
```
naturally you need to know the password.

after you ave bootstrapped the node you can run cookbooks you have uploaded to your server on it. To upload the cookbook provided to your server simply enter the following commands in teh directory /version1/chef-repo

```
berks install

berks upload
```
this will upload teh cookbooks which you can then add to your node with
```
knife node run_list add NODENAME linux_server
```
and then run with
```
knife ssh 'name:NODENAME' 'sudo chef-client' --ssh-user USERNAME --ssh-password --sudo
```
or you can simply wait for the periodical run that is determined in the cookbook itself.
