class lampstack {
	package { "apache2": }
	package { "libapache2-mod-php7.0":
		require => Package["apache2"], }
	package { "php-mysql": }
	package { "phpmyadmin":}

	Package { ensure => "installed",
		allowcdrom => true,
	}
	file { "/var/www/html/index.php":
		content => template("lampstack/index.php"),
		require => Package["apache2"],
	}	
	file { "/var/www/html/index.html":
		ensure => "absent",
		require => Package["apache2"],
	}
	file { "/etc/apache2/sites-available/${title}.com.conf":
		content => template("lampstack/vhost.conf.erb"),
		require => Package["apache2"],
	}
	file { "/etc/apache2/sites-enabled/${title}.com.conf":
		ensure => "link",
		target => "../sites-available/${title}.com.conf",
		require => Package["apache2"],
	}
	file { "/etc/hosts":
		content => template("lampstack/hosts"),
		require => Package["apache2"],
	}
	file { "/etc/skel/public_html":
		ensure => "directory",
		require => Package["apache2"],
	}
	file { "/etc/skel/public_html/index.php":
		content => template("lampstack/public_html/index.php"),
		require => Package["apache2"],
	}
	service { "apache2":
		ensure => "running",
		enable => "true",
		provider => "systemd",
	}
	exec { "userdir":
		notify => Service["apache2"],
		command => "/usr/sbin/a2enmod userdir",
		require => Package["apache2"],
	}
	file { "/etc/apache2/mods-available/php7.0.conf":
		content =>template("lampstack/php7.0.conf"),
		notify => Service["apache2"],
		require => Package["apache2"],
	}
	file { "/etc/apache2/apache2.conf":
		content => template("lampstack/apache2.conf"),
		notify => Service["apache2"],
		require => Package["apache2"],
	}
}
