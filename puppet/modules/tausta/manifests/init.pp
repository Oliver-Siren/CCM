class tausta {
        file {"/usr/share/xfce4/backdrops/eero.jpeg":
                source => "puppet:///modules/tausta/eero.jpeg",
        }
        file {"/usr/share/xfce4/backdrops/xubuntu-wallpaper.png":
                ensure => "link",
                target => "/usr/share/xfce4/backdrops/eero.jpeg",
        }
        service {"lightdm":
                ensure => "running",
                enable => "true",
                provider => "systemd",
    }
}
