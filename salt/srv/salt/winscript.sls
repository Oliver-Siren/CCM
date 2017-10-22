 C:\Replacewallpaper.ps1:
   file:
     - managed
     - source: salt://ReplaceWallpaper.ps1
 
 Run myscript:
   cmd:
     - run
     - name: C:\ReplaceWallpaper.ps1
     - shell: powershell
