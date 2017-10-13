sudo tftp 10.0.0.221 -c get firstboot
sudo mv firstboot /etc/init.d/
sudo chmod +x /etc/init.d/firstboot
update-rc.d firstboot defaults
