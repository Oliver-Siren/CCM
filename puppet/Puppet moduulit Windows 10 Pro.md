# Puppet moduulin tekeminen Windowsiin

Katsoin tätä tehdessäni mallia Tero Karvisen ja Joona Leppälahden artikkeleista: http://terokarvinen.com/2016/automatically-install-a-list-of-software-to-windows-chocolatey-puppet-provider
https://joonaleppalahti.wordpress.com/2016/12/01/palvelinten-hallinta-harjoitus-12/

Asensin Puppet version aiemmin tekemäni ohjeen mukaan Windows 10 pro orjakoneelle. Käytin matchaavaa versiota Puppetmasterini Puppetista (3.8.5). Olisin voinut myös käyttää agent versiota, mutta aiemmissa ohjeissa sanottiin että tulee käyttää samaa versiota kuin Puppetmaster, joten päätin pysyä tässä ratkaisussa.

Päätin kuitenkin ennen asennusta tehdä uuden master koneen tätä varten virtualboxiin, jotta moduulin rakentaminen olisi helpompaa. 

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
