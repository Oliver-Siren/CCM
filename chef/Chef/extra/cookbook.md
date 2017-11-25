I started forming the linux_server_v1 cookbook simply by entering the command "chef create cookbook" to create the cookboock. Then added some variables to try. And prodeeded to create a node to try the cookbook on. Then I ran into problems as I could not bootstrap the node as I usually do. I did not want to go too far into trying to fix the error, so i decided to try and reinstall chef server since it often has problems running on vagrant. I did so but the problem presisted. I redid the bootstrap with the modifier -V -V to get more information on what is happening in the bootstrap process the error that seems to fail the bootstrapping is the following 
```
dpkg: error: requested operation requires superuser privilege
```

Which seems strange since the vagrant user is in sudoers which should be enough also I'm fairly sure I've done this bootstrap before without problems

after a brief search I found that I can run the command with the argument "-- sudo" that fixes the problems but then it get stuck at 

```
ERROR: Connection refused connecting to https://vagrant.vm/organizations/arctic/nodes/node1
```
I belive this is simply a problem of the network configuration. So i fixed it by adding the servers address to the nodes etc/hosts file and the run completed without issue.
Next problem was trying to run the cookbook with 

```
knife ssh 'name:node1-ubuntu' 'sudo chef-client' --ssh-user USER --identity-file IDENTITY_FILE --attribute ipaddress
```

since the vagrant instance gets the wrong ipaddress with attribute I tried to find if some of the other attributes has the correct ipaddress. I tried reading the output of the attributes with 
```
knife search node "name:node1" -F json -V -V |grep 
```
and giving grep different arguments since my console wouldn't display the whole list of items. I did not find the appropriate attribute to use despite finding the ipaddress I wanted to target so I also added the ip of the node to etc/hosts of both my desktop and server but it did not fix the problem. 
Rereading the knife ssh documentation I realized that the modifier -G for gateway takes a IP address so I don't need to run the ip address to teh command with ohai but can instead simply use gateway so
```
knife ssh 'name:node1' 'sudo chef-client' --ssh-user vagrant --ssh-password vagrant -G 192.168.1.64 -V
```
works to run the cookbook I wanted to run

I ran into further problems in using the mysql cookbook since it seems the example settings given to set the mysql password only configures the initial password and I was at first unable to log in using it. Therefore to change it I needed to reinstall mysql on my vagrant instance which I figured would be easiest to do by destroying it and bootstrapping it again. This still resulted in an error with unpermitted access. On inspecting what I did previously to solve the problem I decided to reinstall chef server aswell, but having done that I still had the same problem wtih the mysql install. It seems that the mysql cookbook does not configure correctly and that it instead attains a random password which seems to be a feature if you do a hands off install of mysql otherwise. I tried looking for an answer to changing the password with the mysql module instead it seems that as of the writing there is a known bug in the module that dosen't properly set the root password on certain mysql versions. I there fore decided to abandon using the chef provided mysql cookbook and istead find some other solution to instaling mysql with a predifeined password. I wasn't really sure what the state of the current distibution of mysql was so I first tied installing it into my node to find out how it is simply installing it manually. After instaling it I was unable to use mysql since when i tried to login it gave the following error on "mysql -u root"

```
ERROR 2002 (HY000): Can't connect to local MySQL server through socket '/var/run/mysqld/mysqld.sock' (2)

```
correcting the error seemed like it'd need installation of mysql server which i was reluctant to do again because it sets a randomized password for root on install if one isn't provided I found a script from [https://gist.github.com/sheikhwaqas/9088872] that did the job in a hands on test so I decided to use it for my cookbook as well. The relative bit was 
```
echo "mysql-server-5.6 mysql-server/root_password password root" | sudo debconf-set-selections & echo "mysql-server-5.6 mysql-server/root_password_again password root" | sudo debconf-set-selections & sudo apt-get -y install mysql-server

```
despite the mysql-server package being "Ver 14.14 Distrib 5.7.20, for Linux" the password was indeed set to root on istall I decided to try the install with another password aswell to make sure and while the first install failed after giving "sudo apt update" the install succeded also a second time. Since there was a problem with the install idecided to try a third time and now the install failed. I then tried to modify the commands to account for the version by amending the bit where the version is stated but this did not rectify the problem i ran into. Despite trying i was unable to replicate my earlier success.

I decided to reread the mysql modules readme and I realized I neglected to try turning mysql on with "sudo service mysql-foo start" as directed in the guide for mysql cookbook. After entering the command i was able to log in to mysql as  instructed in the readme.
