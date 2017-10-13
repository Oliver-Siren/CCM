# Puppet moduulin tekeminen Windowsiin

Asensin Puppet version aiemmin tekemäni ohjeen mukaan Windows 10 pro orjakoneelle. Käytin matchaavaa versiota Puppetmasterini Puppetista (3.8.5). Olisin voinut myös käyttää agent versiota, mutta aiemmissa ohjeissa sanottiin että tulee käyttää samaa versiota kuin Puppetmaster, joten päätin pysyä tässä ratkaisussa.

Päätin kuitenkin ennen asennusta tehdä uuden master koneen tätä varten virtualboxiin, jotta moduulin rakentaminen olisi helpompaa. 

## Ohjelmamoduulin luonti

Kun sain uuden Puppetmasterin asennettua, niin ensimmäiseksi asensin puppetlabsin windows moduulit komennolla

`sudo puppet module install puppetlabs/windows`

Komento asensi ison kasan Puppetlabsin moduuleita, joiden joukossa oli tarvitsemani chocolatey moduuli.

Ohjeita seuraamalla loin choco nimisen moduulin joka asentaa WinSCP, notepad ++, putty ja libre office. Valitsin asennettavaksi .install pääteiset versiot muista paitsi libreofficesta, sillä ne voidaan poistaa yksinkertaisesti. 

```

class choco {
    include chocolatey

    Package {
        ensure => "installed",
        provider => "chocolatey",
    }

    package {["winscp.install", "notepadplusplus.install", "putty.install", "libreoffice"
    ]:}
}

```

Koska .local eivät toimi puppetmaster-orja rakenteessa kotiverkossani, niin jouduin luomaan hosts tiedoston windows orjalle, jossa oli reitittimeni käyttämä DNS nimi masterista (master2.zyxel.setup). Jouduin tekemään näin siksi, koska sertifikaatit saapuvat tällä nimellä masterille.

## Käyttäjän lisäys ja taustakuvan vaihto

Katsoin aluksi dokumentaatiota täältä: https://docs.puppet.com/puppet/3.6/resources_user_group_windows.html

Päädyin lopulta luomaan moduulin:

```
class wuserwall {
    user {'opiskelija':
        name      => 'opiskelija',
        ensure    => present,
        groups    => ['Users'],
        password  => 'salasana',
        managehome => true,
    }
}

```
(Managehome true luo käyttäjälle kotihakemiston, en ole varma tapahtuuko tämä itsestään).

Siirsin moduulin Puppetmasterille, ja päivitin site.pp tiedoston. 

Sitten ajoin Windows orjalla komennon puppet agent -tdv ja kirjauduin ulos.

Uusi käyttäjä oli ilmestynyt. Testasin kirjautua sisään, ja se toimi.

Sitten lisäsin siihen kohdan joka antaa Administratorille täydet oikeudet muuttaa Windowsin uudelle tilille tulevaa taustakuvaa.

```
acl { 'C:\WINDOWS\web\wallpaper\Windows\img0.jpg':
        permissions => [
                { identity => 'Administrator', rights => ['full'],
		        source_permissions => ignore },
        ],
}
```
Lopuksi lisäsin kohdan joka siirtää uuden taustakuvan masterilta orjalle, ja koska oikeudet ovat kunnossa, niin Puppet onnistuu vaihtamaan alkuperäisin kuvan tilalle uuden.

Valmis moduuli:
```
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
```

Katsoin tätä tehdessäni mallia Tero Karvisen ja Joona Leppälahden artikkeleista: http://terokarvinen.com/2016/automatically-install-a-list-of-software-to-windows-chocolatey-puppet-provider
https://joonaleppalahti.wordpress.com/2016/12/01/palvelinten-hallinta-harjoitus-12/
https://github.com/joonaleppalahti/CCM/blob/master/ansible/Ansible%20raportti.md
        
## Lopputuloksia

![alt text](https://raw.githubusercontent.com/joonaleppalahti/CCM/master/puppet/kuvat/10.png "10")
