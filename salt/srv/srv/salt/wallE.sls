 /usr/share/xfce4/backdrops/xubuntu-wallpaper.png:
   file:
     - managed
     - source: salt://background/wallE2.png

 /etc/lightdm/lightdm-gtk-greeter.conf:
   file:
     - managed
     - source: salt://background/lightdm-gtk-greeter.conf
