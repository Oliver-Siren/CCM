class wuserwall {
	
	acl { 'C:\WINDOWS\web\wallpaper\Windows\img0.jpg':
	permissions => [
		{ identity => 'Administrator', rights => ['full'] },
	],
    }

    file {"C:\WINDOWS\web\wallpaper\Windows\":
        source => "puppet:///modules/wuserwall/img0.jpeg"
    }

    user {'opiskelija':
        name      => 'opiskelija',
        ensure    => present,
        groups    => ['Users'],
        password  => 'salainen',
        managehome => true,
    }
}
