takeown /f C:\Windows\Web\Wallpaper\Windows\img0.jpg
icacls C:\Windows\Web\Wallpaper\Windows\img0.jpg /Grant 'System:(F)'
Remove-Item c:\windows\WEB\wallpaper\Windows\img0.jpg
Copy-Item C:\Windows\Web\Wallpaper\Windows\4k\img0.jpg C:\Windows\Web\Wallpaper\Windows\img0.jpg

