 C:\Windows\Web\Wallpaper\Windows\4K:
   file:
     - directory
     - makedirs: True
     - source: salt://replacewallpaper/4K

 C:\Windows\Web\Wallpaper\Windows\4K\img0.jpg:
   file:
     - managed
     - source: salt://replacewallpaper/4K/img0.jpg
