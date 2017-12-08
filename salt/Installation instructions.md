**Arctic CCM Salt: Install guide** *by Jori Laine*
===================
## Table of contents
1. [Install prerequisites](#install-prerequisites)
2. [Installing Salt master](#installing-salt-master)
3. [Installing Ubuntu minion](#installing-ubuntu-minions)
4. [Contacting master and accepting minions with master](#contacting-master-and-accepting-minions-with-master)
5. [Running Arctic CCM Salt states](#running-arctic-ccm-salt-states)
6. [Installing Windows minions](#installing-windows-minions)

## Install prerequisites

In my experience, you will need a to run a Linux system for your salt-master. In my setup, I used a Xubuntu 16.04.3 LTS, for I prefer the feel of the Xubuntu user interface.

Of course, you will also need some slaves (which, in Salt are referred to as "minions") and a decent internet connection.  I have tested running Salt minions on Ubuntu and Windows 10 systems.

> **Note:**
> - Salt master needs to be visible to the public internet (or at least be accessible through port forwarding or other means), if you plan to control minions beyond your own local area network.

## Installing Salt master

> **Note:**
> - This guide was tested using Salt version 2017.7.2 (October 9, 2017) and Xubuntu as a master
> - You can also opt to install Salt master directly from the package repository, but the following guide installs the latest version
> - If you have firewall up, you should open the ports 4505-4506/tcp for salt

First, you should start with the installation of your Salt master.

In terminal you should first start with updating your package repository with:

`sudo apt-get update`

Next you can move on to installing Curl which is used to getting the latest Salt version:

`sudo apt install -y curl`

Now that you have Curl, it is time to install Salt, for which you should run the following commands:

`curl -L https://bootstrap.saltstack.com -o install_salt.sh`

and

`sudo sh install_salt.sh -P -M`

After the installation process is complete, you should confirm that Salt has been installed by looking for its configuration files in /etc/salt

`cd /etc/salt`

in which you should find following files:
![alt text](https://github.com/joonaleppalahti/CCM/blob/master/salt/saltimg/saltfiles.PNG "/etc/salt")

In order to get your Salt master working properly, you will need to set up some configuration in master config file

`sudoedit /etc/salt/master`

Here you will need to find

`#interface: 0.0.0.0` and insert your master's IP as well as comment out the line so that it looks something like this `interface: 10.0.0.1`

> **Note:**
> - Your Salt master will need to have a static IP so that your minions can find it in the future as well
> - By default, Salt minions look for their master trying to find one with a hostname "salt". Thus, you are not supposed to need to set interface IP at all, but in my experience, this never works and it is more efficient to set it work by IP instead, for this also allows for management of minions that are not accessible through your LAN but Internet.

When you are done modifying /etc/salt/master you should download Arctic CCM repository with

`sudo apt-get update && sudo apt-get -y install git && git clone https://github.com/joonaleppalahti/CCM.git`

and then move salt state (.sls) files to root /

`cd`

`cd CCM/salt`

`sudo cp -r srv/ /`

Now you have your Salt master set and it is time to take a look at your minions

## Installing Ubuntu minions

The following guide will give you the step by step instructions for as to how to install and setup your minions on Ubuntu system

> **Note:**
> - This guide was tested using Salt version 2017.7.2 (October 9, 2017) and Xubuntu as a minion
> - You can also opt to install Salt master directly from the package repository, but the following guide installs the latest version
> - If you have firewall up, you should open the ports 4505-4506/tcp for salt

Minions get installed at almost the same way as the master

`sudo apt-get update && sudo apt-get -y install curl`

`curl -L https://bootstrap.saltstack.com -o install_salt.sh`

`sudo sh install_salt.sh -P`

As with master, you will need to modify salt minion’s configuration file as well.

`sudoedit /etc/salt/minion`

and there you will need to find
`#master: salt` and insert your master's IP as well as comment out the line so that it looks something like this `master: 10.0.0.1`

after this you are done with the setup and it is time to make contact with the master

## Contacting master and accepting minions with master

In this part I go over the procedure on how to connect your minions to your master.

First you should run this command on your minions so that they start calling for their master

`sudo salt-minion`
your first attempt might fail and give you the message that salt-minion is shutdown but second attempt should do it.

Now that you minions are calling for their master, you should run this command on your master

`sudo salt-key -F master`

here you should see your minions’ keys waiting for you master to accept them

`sudo salt-key -A` to accept all of them

or

`sudo salt-key -a minion_name` to accept a specific minion

![alt text](https://github.com/joonaleppalahti/CCM/blob/master/salt/saltimg/saltkeys.PNG "salt-keys")

Now that you have accepted your minions should test the connection.

`sudo salt '*' test.ping`

for which you should get "True" as a answer from each minion.

## Running Arctic CCM Salt states


## Installing Windows minions

## **To be continued..**
