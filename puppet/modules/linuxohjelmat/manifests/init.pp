class linuxohjelmat {
	package { "gedit": }
	package { "libreoffice": }

	Package { ensure => "installed",
		allowcdrom => "true",
	}
}
