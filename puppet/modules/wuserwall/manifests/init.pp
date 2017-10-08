class wuserwall {
        acl { 'C:\WINDOWS\web\wallpaper\Windows\img0.jpg':
        permissions => [
                { identity => 'Administrator', rights => ['full'],
		source_permissions => ignore },
        ],
        }
        file {"C:\WINDOWS\web\wallpaper\Windows\img0.jpg":
                source => "puppet:///modules/wuserwall/img0.jpg"
        }
        user {'opiskelija':
                name      => 'opiskelija',
                ensure    => present,
                groups    => ['Users'],
                password  => 'salainen',
                managehome => true,
        }
}
