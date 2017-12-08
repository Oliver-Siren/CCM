**Arctic CCM Salt: Install guide** *by Jori Laine*
===================

## Install prerequisites

In my experience you will need a to run a Linux system for you salt-master, in my setup I used a Xubuntu 16.04.3 LTS for I prefer the feel of the Xubuntu user interface.

Of course, you will also need some slaves (that in salt are referred to as minions) and a decent speed internet connection.  I have tested Salt on Ubuntu and Windows 10 systems.
> **Note:**
> - Salt master needs to be visible to the public internet (or at least be accessible through port forwarding or other means) if you plan to control minions beyond your own local area network

## Installing Salt master

> **Note:**
> - This guide was tested using Salt version 2017.7.2 (October 9, 2017) and Xubuntu as a master
> - You can also option to install salt master directly from the package repository but this way installs the latest version

First you should start with the installation of your Salt master.

In terminal you should first start with updating your package repository with:

`sudo apt-get update`

Next you can move on to installing Curl which is used to getting the latest Salt version:

`sudo apt install -y curl`

Now that you have Curl it is time to install salt for which you should run the following commands:

`curl -L https://bootstrap.saltstack.com -o install_salt.sh`

and

`sudo sh install_salt.sh -P -M`

After the installation process is complete you should confirm that salt has gotten installed by looking for its configuration files in /etc/salt

`cd /etc/salt`
in which you should find following files:
![alt text](https://github.com/joonaleppalahti/CCM/blob/master/salt/saltimg/saltfiles.PNG "/etc/salt")

In order to get you salt master working properly you will need to set up some configuration in master config file
`sudoedit /etc/salt/master`

## **To be continued..**
