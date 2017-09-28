# Moduulit jotka asentuvat Xubuntuun

## Lampstack
Lampstack moduuli on muokattu versio aiemmin tekemästäni moduulista. Se asentaa tällä hetkellä Apache2, libapache2-mod-php, php7.0 ja php-mysql. Tämän lisäksi se antaa käyttäjälle luvan luoda apache sivun omaan kotihakemistoonsa, ja siirtää esimerkki php-sivun sijaintiin /etc/skel/public_html. Tämä toiminnallisuus todennäköisesti tulee muuttumaan kun pääsemme yhteisymmärrykseen siitä, millainen palvelinasennuksen tulee tarkalleenottaen olla.

```class lampstack {
	package { "apache2": }
	package { "libapache2-mod-php7.0":
		require => Package["apache2"], }
	package { "php7.0": }
	package { "php-mysql": }

	Package { ensure => "installed",
		allowcdrom => "true",
	}
	file { "/var/www/html/index.php":
		content => template("lampstack/index.php"),
		require => Package["apache2"],
	}	
	file { "/var/www/html/index.html":
		ensure => "absent",
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
	service { "apache2":
		ensure => "running",
		enable => "true",
		provider => "systemd",
		require => Package["apache2"],
	}
}
```
## MySQL
Päädyin MySQL:n kohdalla käyttämään PuppetLabsin MySQL moduulia sen vuoksi, että jos tekisin moduulin itse, niin aikaa ei jäisi paljon muuhun.
Yritin aluksi asentaa puppetlabsin uusinta moduulia (https://forge.puppet.com/puppetlabs/mysql/2.2.3), mutta huomasin että se vaati paljon kustomointia ennen asennusta. Päädyin lopulta käyttämään Vanhempaa versiota, jolla olin aiemmin asentanut MySQL:n onnistuneesti siten, että root salasanan voi asettaa site.pp tiedostossa. 
Se tapahtuu seuraavasti: 

```class { "mysql::server":
            root_password => "salasanatähän",
        }```

Linkki vanhempaan moduuliin: https://github.com/joonaleppalahti/CCM/tree/master/puppet/modules/mysql
## Tausta
 Tausta moduuli on minun aiemmalla Tero Karvisen Palvelinten hallinta kurssilla luomani moduuli, joka vaihtaa moduulin ajamisen yhteydessä käyttäjän taustakuvan.
