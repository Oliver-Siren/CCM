# Puppet moduulit Linux työasemalle

Päätin aloittaa SSH moduulista. Siitä tuli seuraavanlainen:

```
class ssh2 {
        package { "ssh":
                ensure => "installed",
                allowcdrom => "true",
        }
        exec { "sudo ufw enable":
                path => "/bin/:/usr/bin/:/sbin/:/usr/sbin/",
                unless => 'sudo ufw status verbose|grep "Status: active"',
        }
        exec { "sudo ufw allow 22/tcp":
                path => "/bin/:/usr/bin/:/sbin/:/usr/sbin/",
                unless => "ufw status verbose|grep 22/tcp",
        }
        exec { "sudo ufw allow 8140/tcp":
                path => "/bin/:/usr/bin/:/sbin/:/usr/sbin/",
                unless => "ufw status verbose|grep 8140/tcp",
        }
        service { "ssh":
                ensure => "running",
                enable => "true",
                provider => "systemd",
        }
}
```

Taustakuvan vaihto tapahtuu aiemmin tekemälläni tausta moduulilla:

```
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
```

Seuraavaksi siirryin tekemään ohjelmamoduulin, joka asentaa libreofficen ja geditin.

```
class linuxohjelmat {
	package { "gedit": }
	package { "libreoffice": }

	Package { ensure => "installed",
		allowcdrom => "true",
	}
}
```

Tämän jälkeen loin moduulin, joka lisää opiskelija käyttäjän. Katsoin mallia täältä: (https://serverfault.com/questions/524938/creating-user-accounts-with-puppet)


```
class luser {
user { 'opiskelija':
      ensure  => present,
      password => '$1$SomeSalt$4.JJVvoUTkZesyvyvpkll1',
      home => '/home/opiskelija',
      shell => '/bin/bash',
      managehome => true,
    }
}
```

Katsoin Joona Leppälahden ansible repositorystä mallia salasanan kryptaukseen ja suolaukseen.

Loin lopuksi site.pp tiedoston:

```
class {"luser":}
class {"ssh2":}
class {"linuxohjelmat":}
class {"tausta":}
```

Ajoin moduulit komennolla sudo puppet apply /etc/puppet/manifests/site.pp

Kaikki näytti hyvältä: (KUVA13)

Mutta käyttäjätilin luonnissa jotain meni pieleen. En päässyt kirjautumaan käyttäjälle muualta kuin komentorivin kautta SSH:lla ja kotihakemistoa ei ollut. Luulin että Puppet tekisi nämä itsestään, mutta ilmeisesti ei. Lisäsin seuraavaksi lisää määrityksiä käyttäjätilin luonti moduuliin ja kokeilin uudestaan. Etsin pitkään tietoa netistä, ja lopulta huomasin sivulta http://www.bogotobogo.com/DevOps/Puppet/puppet_creating_managing_user_accounts_ssh_control_user_privileges.php että ilman "managehome => true" määristystä puppet ei luo käyttäjän kotihakemistoa ollenkaan. Tämän lisäyksen jälkeen käyttäjän luonti onnistui.



