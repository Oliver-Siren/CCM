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

In my experience, you will need to run a Linux system for your salt-master. In my setup, I used a Xubuntu 16.04.3 LTS, for I prefer the feel of the Xubuntu user interface.

Of course, you will also need some slaves (which, in Salt are referred to as "minions") and a decent internet connection.  I have tested running Salt minions on Ubuntu and Windows 10 systems.

> **Note:**
> - Salt master needs to be visible to the public internet (or at least be accessible through port forwarding or other means), if you plan to control minions beyond your own local area network.

## Installing Salt master

> **Note:**
> - This guide was tested using Salt version 2017.7.2 (October 9, 2017) and Xubuntu as a master
> - You can also opt to install Salt master directly from the package repository, but the following guide installs the latest version
> - If you have firewall up, you should open the ports 4505-4506/tcp for Salt

First, you should start with the installation of your Salt master.

In Terminal, you should begin with updating your package repository with:

`sudo apt-get update`

Next you can move on to installing Curl, which is used to getting the latest Salt version:

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
> - By default, Salt minions look for their master trying to find one with a hostname "salt". Thus, you shouldn't need to set interface IP at all, but in my experience, this never works and it is more efficient to set it to work by IP instead, as this also allows for the management of minions, that are not accessible through your LAN, but through Internet.

When you are done modifying /etc/salt/master, you should download Arctic CCM repository with

`sudo apt-get update && sudo apt-get -y install git && git clone https://github.com/joonaleppalahti/CCM.git`

and then move salt state (.sls) files to root /

`cd`

`cd CCM/salt`

`sudo cp -r srv/ /`

Now you have your Salt master set and it is time to take a look at your minions

## Installing Ubuntu minions

The following guide will give you the step by step instructions on how to install and setup your minions on Ubuntu system

> **Note:**
> - This guide was tested using Salt version 2017.7.2 (October 9, 2017) and Xubuntu as a minion
> - You can also opt to install Salt minion directly from the package repository, but the following guide installs the latest version
> - If you have a firewall up, you should open the ports 4505-4506/tcp for Salt

Minions get installed almost the same way as the master

`sudo apt-get update && sudo apt-get -y install curl`

`curl -L https://bootstrap.saltstack.com -o install_salt.sh`

`sudo sh install_salt.sh -P`

As with the master, you will need to modify Salt minion’s configuration file as well.

`sudoedit /etc/salt/minion`

and there you will need to find
`#master: salt` and insert your master's IP as well as comment out the line, so that it looks something like this `master: 10.0.0.1`

after this, you are done with the setup and it is time to make contact with the master.

## Contacting master and accepting minions with master

In this part, I go over the procedure on how to connect your minions to your master.

First, you should run this command on your minions so that they start calling for their master

`sudo salt-minion`
your first attempt might fail and give you the message that "Salt-minion is shut down" but the second attempt should do it.

Now that you minions are calling for their master, you should run this command on your master

`sudo salt-key -F master`

here you should see your minions’ keys waiting for you master to accept them

`sudo salt-key -A` to accept all of them

or

`sudo salt-key -a minion_name` to accept a specific minion

![alt text](https://github.com/joonaleppalahti/CCM/blob/master/salt/saltimg/saltkeys.PNG "salt-keys")

Now that you have accepted your minions, you should test the connection.

`sudo salt '*' test.ping`

for which you should get "True" as a answer from each minion.

## Running Arctic CCM Salt states

At this point you have your master and minions set and connected to each other and you have my state files ready to use in your /srv/salt/ file, so now is the time to take a look at these files.

> **Note:**
> - In my test enviroment, I had my minions named mWS, mSRV and WinMin
> - mWS for workstation
> - mSRV for LAMP (Linux,apache,MySQL,PHP) server
> - WinMin for Windows minion
> - top.sls contains a list of minions on which to run various states, so you might want to change the names to reflect the host names of your minions

When you have modified top.sls to address your minions and chosen which states to run on them, it is time to execute the order

`sudo salt '*' state.apply`

This might take a moment, depending on the state modules you have chosen to use. On the feedback, you should get a detailed list of changes to your minions or a list of failures, in chase you did something wrong when you modified top.sls or some of the other files.

## Installing Windows minions

On Windows OS, you'll first need to open a couple of ports in the firewall for Salt (4505-4506)

This command needs to be given in a powershell that has adminisrator privileges
`netsh advfirewall firewall add rule name="Salt" dir=in action=allow protocol=TCP localport=4505-4506`

Now that you have your firewall set, you should allow remote execution of powershell, in order to allow for the powershell script to be ran by Salt (this script is needed in order to take ownership and give rights to img0.jpg that is your Windows' default wallpaper).

This command needs to be given in a powershell that has adminisrator privileges
`Set-ExecutionPolicy RemoteSigned`

Windows Salt minion client needs to be downloaded from the source for it is not included in this git repository.

You can download it from here:
https://docs.saltstack.com/en/latest/topics/installation/windows.html

Python3 AMD64: [Salt-Minion-2017.7.2-AMD64-Setup.exe](https://repo.saltstack.com/windows/Salt-Minion-2017.7.2-Py3-AMD64-Setup.exe)


## **To be continued..**
