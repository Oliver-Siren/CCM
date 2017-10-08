# Chef infrastructure automation

## Introduction

This document is being presented as part of a study poject. Our team is researching infrasructure automation with the goal of comparing the most popular options (at this time). I will be studying Chef. Our goal is to produce easy setup guides for a number of example configuraions and to present our findings to our classmates at the end of the project. I have no prior familiarity with chef although I did check that it should work with Xubuntu which is my Linux distro of choice. I also installed it from the repo to have a quick look but deided to remove it to proceed with a guide provided by chef.

## Starting with Chef

Chef.io has a number of links to guides and instructions. I have no previous knowledge of chef so i'll be looking at the provided guides as part of this project. I started folowing the guide starting from [https://learn.chef.io/modules/getting-started-with-chef-lcr#/] I proceed to the recommended basics course "Infrastucture automation". Since I'm using Xubuntu i chose Ubuntu from the oferred options for OS and I wanted to use my ow n computer for initial testing. The guide seems comprehensive but right away it sems to me that some unneeded instructions are provided since i already chose a set of options. Why are these being provided if the instructions are not tailored to the choices? The instructions are provided very clearly separated between terminal comands and other advice. Copypasting from the website also seems to work without problems. Having now installed the basics required to use chef i was a bit surprised thet the guide now seemed to suggest that i was done and should remove my progress so far the learning module semed a bit on the short side for simply instaling the basics and not even using them. Proceeding to the next module i copied their helloworld but chose to use a different directory because i want ot push the results out with and established git-repo. Despite this the tutorial worked as expected. Iwas very plesantly susrprised to see that deletion of files was present in the tutorial my understanding has been that rollback functionality is not a strenght of CCM systems and Chef seems to include deletion at the least. Thse second resource was much more interesting with some basic commands and a hello world. Seems that the modules try to be bite sized for convinience. The third module installs an apache2 webserver which seems to me to be a good starting point for learning a CCM although 'helloworld' is customary. The modules completes with a taste of a cookbook a organizational unit in chef.

The second module of chef learning requires a separate instances for a server, a workstation and a node  so I decided to set this up using vagrant. The install instrution for ChefDK refer to a set of downloads which dont seem to wrok in ubuntu which was a bit discouraging. I would have hoped for a command line install. I decided to try and continue despite not installing chef DK as per the instructions. The guide offers the option to follow the setup instructions [https://docs.chef.io/install_server.html] or do it by continuing to follow the guide. I decided to follow the guide for now. The guide provides install scripts to use for setting up the chef server via command line. Having initiated the install script it took a surprisingly long time for the install to complete I was certain the install had hung but waited for arounf 15 minutes to make sure and it finally started going forward. I then went back to the fisrt learning module to install the chef tools given there. I had some trouble getting the certs to work since the guide dosent tell you how to connect using an IP address and while possible changing the hostname of the server to match its ip address did not work with vagrant (bento/ubuntu-16.04) so i had some trouble getting past this bit. Once the certificates worked i proceeded to get the learning apache 2 git stuff as instructed. and read through the bootstrap guide, both were easy ut again theres a guide for microsoft azure when im working with linux even though they asked it at start of the guide. Otherwise the lesson was very straighforward setup an instance enter the command and see what happens. In the next lesson the examples provided for connecting with ssh seemed simple enough but i had some trouble and the "--attribute ipaddress" was a problem on a vgrant platform since in my setup vagrant gets 2 different IP addresses and the wrong one was picked up by --attribute ipaddress. By using ip to connect the tutorial script for declaring the FQDN name dosent work since the computer dosenr have a valid FQDN name. After completing the tutorial on roles i tried to use a cookbook from the chef repository to install LAMP stack since its one ofthe things we agreed we sould demostrate in his assgnment. It was relatively easy to install lamp_role cookbook simply by adding it to the web role from the tutorial. I followed the previous instructions for adding a role then modified the old file to include the new cookbook that i retrieved with berks. The lamp_role cookbook did not work right away so i decided to proceed with the tutorial instead. The rest of the tutorial deals with dismantling your chef network again itsmostly just issuing the commands and wahtching waht happens. 

To summarize the utorial it gives a good deal of useful tols quickly but goes a bit light on seome things which actually gave me problems like the fqdn requirements. Other than the few places where i thought that the instruction was not quite delailed enough it gives oyu the tools to continue doing stuff with chef as you have some idea what its capable of and you know how to use the basic blocks to manage your infrastructure. 


## redoing the install 

Chef requires three components to work as intenden. A workstation, a server and a node. Workstation is where the cookbooksare written and stored for deployment to your server. The server issues instructions to your nodes based on the contents of the cookbooks. When you star installing Chef you'll need to install ChefDK for your workstation and ChefServer for your server. This wil be a shot guide on how to install a chef server, a chefDK ewuipped worktation and a few nodes with some useful content. 

ChefDK's latest version is available at [https://downloads.chef.io/chefdk] once you doenload it to your desktop you can instal it with apt.
You can install chef server by using wget to download the install fiel if you want the latest version at the time of writing the vesrion that came from apt was 12.3.0 while latst stable was 12.16.14. I got the file with   

´´´
wget https://packages.chef.io/files/stable/chef-server/12.16.14/ubuntu/16.04/chef-server-core_12.16.14-1_amd64.deb

´´´
and then install use apt and the path to the file

´´´
sudo apt install /home/vagrant/chef-server-core_12.16.14-1_amd64.deb 

´´´
once apt is doen give the command to prepare the server

´´´
sudo chef-server-ctl reconfigure

´´´
