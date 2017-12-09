#!/bin/bash

# create staging directories
if [ ! -d /downloads ]; then
  mkdir /downloads
fi

# download the ChefDK package
if [ ! -f /downloads/chefdk_2.4.17-1_amd64.deb ]; then
  echo "Downloading the ChefDK package..."
  wget -nv -P /downloads https://packages.chef.io/files/stable/chefdk/2.4.17/ubuntu/16.04/chefdk_2.4.17-1_amd64.deb
fi

# install ChefDK
echo "Installing ChefDK..."
dpkg -i /downloads/chefdk_2.4.17-1_amd64.deb
echo "Your ChefDK is ready"
