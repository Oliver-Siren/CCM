# SaltStack

## Sisällysluettelo
1. [Alkusanat](#alkusanat) 
2. [Esivalmistelut](#esivalmistelut)
3. [Minioni etsii isäntää IP asetukset](#minioni-etsii-isäntää-ip-asetukset)
4. [Löytyykö isäntä](#löytyykö-isäntä)
5. [Ensimmäisen ohjelman asennus](#ensimmäisen-ohjelman-asennus)
6. [Salt state](#salt-state)
7. [LAMP-asennus ja työpöydän taustakuvan vaihto](#lamp-asennus-ja-työpöydän-taustakuvan-vaihto)
8. [MySQL toimii](#mysql-toimii)
9. [Monen koneen hallintaa](#monen-koneen-hallintaa)
10. [Käyttäjätilin luonti onnistuu](#käyttäjätilin-luonti-onnistuu)
11. [Palomuuri asetukset](#palomuuri-asetukset)
12. [Windows](#windows)
13. [Oman ohjelman asennus moduulin lisääminen Windowsin repositoryyn](#oman-ohjelman-asennus-moduulin-lisääminen-windowsin-repositoryyn)
14. [Windows käyttäjän lisäämine](#windows-käyttäjän-lisääminen)
15. [Windows wallpaper vaihto](#windows-wallpaper-vaihto)
16. [Käytettyjä lähteitä](#käytettyjä-lähteitä)


## Alkusanat

SaltStack projekti on panokseni Arctic CCM projektiin jossa tarkoituksena on tutkia eri keskitetynhallinnan ohjelmia.
Alkuun lähdin kokeilemaan Salttia aivan sokkona ja alla oleva dokumentti heijastaa mielestäni juuri tätä. Usein en tiennyt mitä tein ja ajoittan
vedin vääriä johtopäätöksiä asioista joita sain sitten korjailla jälkeenpäin. Testaus on ollut kuitenkin hauskaa ja vaikka itsestä tuntuu että olen vasta tehnyt pintaraapaisun Saltin moniin ominaisuuksiin,
niin toivottavasti tämä dokumentti antaa edes jonkinlaisen kuvan siitä mitä kaikkea olen tutkinut ja missä olen pysähtynyt lyömään päätäni seinään.

![alt text](https://github.com/joonaleppalahti/CCM/blob/master/salt/saltimg/virtuaalikoneet.png "Virtuaalikoneet")
Projektin testiympäristö on yhdellä Windows PC:llä toimivat neljä virtuaalikonetta, joista 2 Linux Xubuntu ja 1 Windows 10 pro kone.

## Esivalmistelut

Salt testaus alkoi osaltani asentamalla (Lataa tämä jos tarvitset VirtualBoxin) Oracle VM VirtualBox Version 5.1.26 r117224 (Qt5.6.2),
jonne loin Ubuntu 64-bittisen Virtualikoneen, kone tuli luotua default asetuksilla.

Latasin osoitteesta https://xubuntu.org/getxubuntu/#lts itselleni Xubuntun viimeisimmän LTS version 16.04.3. ja asensin tämän
virtuaalikoneeseeni. 

Kun Xubuntu oli asentunut ajoin terminaalissa komennot:
`sudo apt-get update`
`sudo apt-get upgrade`

sekä ensimmäisen komennon saltin asentamiseksi.
`sudo apt-get install -y salt-master`


Lähdin seuraamaan ohjeita sivustolta https://docs.saltstack.com/en/latest/topics/installation/index.html
tällä sivustolla kehoitettiin ensin asentamaan yhdelle koneelle tai virtuaalikoneelle salt-master jonka teinkin.
Ohjeena seurasin Ubuntulle tarkoitettua ohjetta.

Seuraavaksi loin uuden Virtuaalikoneen josta tulee salt-minion.
Sama Xubuntu asennus ja päivitykset kuin edellisessä.
Salt minion asentuu komennolla:
`sudo apt-get install -y salt-minion`

## Minioni etsii isäntää IP asetukset

![alt text](https://github.com/joonaleppalahti/CCM/blob/master/salt/saltimg/saltconf.png "Salt Conf guide")

Ohjeessa IP tulee vaihtaa Masterin IP:hen.

## Löytyykö isäntä

Kun salt on asennettu on seuraavaksi aika testata löytääkö Master Minioninsa ja toisinpäin.

Sivulla https://docs.saltstack.com/en/latest/ref/configuration/index.html#configuring-salt on ohje jos tahtoo tehdä käyttö oikeudet muillekkin kuin root käyttäjälle (eli käyttäjälle jolla ei ole sudo oikeuksia), mutta nyt testatessani ohitin tämän.

Yhteyden tarkistamiseksi
ajoin Masterilla komennon:

`sudo salt-master`
 
ja Minionilla:

`sudo salt-minion`

Masterilla tuli monta riviä Warning tekstiä.
![alt text](https://github.com/joonaleppalahti/CCM/blob/master/salt/saltimg/saltwarnings.png "Salt warning messages")

Näistä ei ainakaan tässä vaiheessa ole tarvinnut erityisesti välittää, toinen rivi koskee salaus tekniikkaa jonka viesti kehoittaa vaihtamaan parempaan.

Minion antoi error viestiä 
![alt text](https://github.com/joonaleppalahti/CCM/blob/master/salt/saltimg/minionwarnings.png "Salt warning messages")

Ohjeessa kehoitetaan tarkistamaan tunnistus avaimet masterilla komennolla:
`sudo salt-key -F master`

Minion koneeni salt-minion näkyi listattuna kohdassa Unaccepted Keys ja tämän korjatakseni syötin komennon:
`sudo salt-key -A`
-A hyväksyy kaikki hyväksymättömät avaimet.

Komento joka poistaa kaikki sammuksissa olevien minioneiden avaimet:
`sudo salt-run manage.down removekeys=True`

Yhteyden varmistamiseksi ohjeessa kehoitettiin pingaamaan minionia komennolla:
`sudo salt salt-minion test.ping`

Komennossa  sudo salt salt-minion test.ping, salt-minion viittaa minion koneen nimeen.

![alt text](https://github.com/joonaleppalahti/CCM/blob/master/salt/saltimg/saltminiontrue.png "Ping")

Minion vastasi pingiin.

## Ensimmäisen ohjelman asennus

Salt voi antaa ohjelman asennuskäskyjä, kuten:
`sudo salt salt-minion pkg.install apache2`
![alt text](https://github.com/joonaleppalahti/CCM/blob/master/salt/saltimg/saltinstall.png "Istalling something via salt")

Asennus onnistui ja apache toimii koneella salt-minion, tämä tuli todettua hakemalla salt-minionin firefox selaimella osoitetta localhost.

![alt text](https://github.com/joonaleppalahti/CCM/blob/master/salt/saltimg/saltapache.png "Apache is alive")

## Salt state

Saltissa voidaan luoda puppet moduulien kaltaisia state tiedostoja jotka kuvaavat minionille halutun tilan jonka mukaiseksi minionin tulee muuttua.
Aluksi luodaan top.sls joka kertoo saltille missä minion koneessa ajetaan mikäkin salt state moduuli.
Itse loin kansioon /srv kansion pillar ja pillar kansioon tiedoston top.sls.

`sudo mkdir /srv/pillar`
`sudoedit /srv/pillar/top.sls`

Ensimmäinen top.sls näytti tältä:
![alt text](https://github.com/joonaleppalahti/CCM/blob/master/salt/saltimg/topsls.png "top.sls moduuli")

Seuraavaksi on aika luoda tiedosto nimeltä data.sls johon ensimmäinen top.sls tiedoston rivi -data viittaa.

`sudoedit /srv/pillar/data.sls`
jonne tuli rivi
`info: some data`

info viittaa saltin sisäiseen funktioon joka printtaa tekstiä minion koneelta masterille ja tässä tapauksessa palatutettava teksti on "some data".

Moduulin testaamiseksi ajetaan kaksi riviä komentoja:

`sudo salt '*' saltutil.refresh_pillar`
`sudo salt '*' pillar.items`

![alt text](https://github.com/joonaleppalahti/CCM/blob/master/salt/saltimg/salttest.png "top.sls moduuli reply")
Testi palautti masterilla tämän.

## LAMP-asennus ja työpöydän taustakuvan vaihto

Kun ensimmäinen salt state moduuli oli saatu toimintaan ymmärsin että mitään salt pillaria ei ole oikeasti edes toiminnassa, vaan state moduulit tulisi
luoda hakemistoon `/srv/salt/` ja niinpä loin hakemiston salt `sudo mkdir /srv/salt/`.

`sudo salt '*' salt.apply` komento moduulin ajamiseen.

Hakemistossa /srv/salt/ tein uuden top.sls tiedoston `sudoedit /srv/salt/top.sls` ja tiedoston lamp.sls `sudoedit /srv/salt/lamp.sls`, kun top.sls tiedostoon tuli
`base:
  '*':
    - lamp`
	HUOM! Sisennyksillä on väliä ja sisennyksiin tulee käyttää space:ä Tab:in sijaan!
	
Lamppi moduuli tuntui alkuun hyvin suoraviivaiselta ja tällä hetkellä yritykseni näyttää tältä:
![alt text](https://github.com/joonaleppalahti/CCM/blob/master/salt/saltimg/saltlamp.png "saltlamp state moduuli yritys")

lamp.sls asentaa onnistuneesti kaikki pyydetyt paketit ja vaihtaa samalla apachen default html sivun joka lyötyy osoitteesta `/var/www/html/index.html`. 
Moduuli epäonnistuu MySQL:n asentamisessa siltä osin että käyttäjänimet ja salasanat jäävät määrittämättä asennusvaiheessa jolloin MySQL on käyttökelvoton.
Apache palvelin toimii hyvin ja php myös joka todennetaan hakemalla selaimella osoitetta localhost.

Lisäksi top.sls moduulissa käsketään käyttämään wallE.sls tiedostoa jonka tarkoituksena on vaihtaa Xubuntu käyttöjärjestelmän työpöydän taustakuva.
Tämän saavuttamiseksi tein tiedoston wallE.sls joka näytti tältä:

![alt text](https://github.com/joonaleppalahti/CCM/blob/master/salt/saltimg/saltwallE.png "saltwallE state moduuli yritys")

WallE vaihtaa työpöydän taustakuva mutta muutokset tulevat voimaan vasta uudelleen kirjautumisen jälkeen.

## MySQL toimii

Joskus auttaa kun ottaa hieman etäisyyttä ongelmaan, ja niin myös tässä tapauksessa. Tero Karvisen sivuilta http://terokarvinen.com/2015/preseed-mysql-server-password-with-salt-stack löytyneen preseedaus menetelmän avulla, 
root salasanan syöttäminen asennusvaiheessa saltilla onnistui ja sisäänkirjautuminen myös. Nyt siis LAMP toimii.

## Monen koneen hallintaa

Loin toisen Xubuntu koneen jolle tahdon asentaa eri ohjelmat kuin edelliseen LAMP koneeseen erotellen ajettavat moduulit top.sls tiedostossa.

![alt text](https://github.com/joonaleppalahti/CCM/blob/master/salt/saltimg/tablesalt.png "top.sls state moduuli yritys")
Viallinen Salt Top.sls state moduuli, joka antoi virhe ilmoituksen.

![alt text](https://github.com/joonaleppalahti/CCM/blob/master/salt/saltimg/tablesalterror.png "top state moduuli yritys virhe")

Virheilmoitus tuli väärin tehdystä top.sls tiedostosta

```
base:
  '*':
    - wallE
    - user

lamp:
  'm2':
    - lamp
    - mysql

desktop:
  'mWS':
    - workstation
```

kun toimiva on (huom! toimii vain kun kaikki koneet ovat Ubuntuja)

```
base:
  '*':
    - wallE
    - user
  'm2':
    - lamp
    - mysql
  'mWS':
    - workstation
```

## Käyttäjätilin luonti onnistuu

Löysin ohjeen käyttäjätilien luontiin ja salasanan cryptaukseen https://gist.github.com/UtahDave/3785738 jota sitten hieman muokkasin omiin tarpeisiini.

valmis state moduuli näytti tältä:

```
 opiskelija:
   user.present:
     - fullname: opiskelija
     - shell: /bin/bash
     - home: /home/opiskelija
     - password: $6$7o5/CdYSAA9nKCSc$RfBbK6WDmJYdw/BeytFj8nyPWBEJJwenIPxZsgpk4IZMPVNDh5ZXe4WhqYcaMWR4XG0fjPT7ANuBfybOieN1/0
     - enforce_password: True
```

Salasanan cryptaus:

`python -c "import crypt; print(crypt.crypt('password', crypt.mksalt(crypt.METHOD_SHA512)))"`
kohdallani tuli virheviesti joka ehdotti python3.5

ja toimiva koodi oli lopulta

`python3.5 -c "import crypt; print(crypt.crypt('password', crypt.mksalt(crypt.METHOD_SHA512)))"`

## Palomuuri asetukset

Palomuurin asetukset päätin tehdä muuttamalla ensin yhdellä linux koneella palomuurin asetukset komennolla:
`sudo ufw allow portti/protokola` esim. `sudo ufw allow 80/tcp` ja sitten kopioimalla tiedostot etc/ufw/user6.rules ja /etc/ufw/user.rules masterin kansioon josta käytän niitä templatena.

https://github.com/patmcnally/salt-states-webapps/blob/master/firewall/ufw.sls palomuurin käynnistämiseen katselin tätä sivua.


## Windows

Windows asentui https://docs.saltstack.com/en/latest/topics/installation/windows.html sivulta ottamastani .exe asennustiedostosta onnistuneesti.
Asennus kysyy tarvittavat tiedot ja luo tiedostopolun joten masterilla täytyy vain käydä hyväksymässä avain. Lisäksi Windows palomuuriin piti tehdä muutos sallien tcp liikenteen porttiin 4505 ja 4506. 

Windowsilla ei ole omaa pakettivarastoa joten sille täytyy luoda sellainen, onneksi SaltStackillä on jo olemassa sellainen ja sen lataamiseen löytyy pätevät ohjeet sivulta https://docs.saltstack.com/en/latest/topics/windows/windows-package-manager.html
Huom! Itselläni ongelmia tuotti ohjeen ja käyttämäni salt-masterin versioiden yhteensopimattomuus joten jouduin poistamaan vanhan version
`sudo apt-get purge salt-master` ja asentamaan uuden sivun https://repo.saltstack.com/ ohjeiden mukaisesti, Bootstarp - multi-platform tuntui helpoimmalta tavalta suorittaa tämä ja ohje toimi hyvin. Ensin oli asennettava curli 
`sudo apt-get install -y curl` ja tämän jälkeen komennot bootstrapin ajamiseksi `curl -L https://bootstrap.saltstack.com -o install_salt.sh` sekä `sudo sh install_salt.sh -P -M` tämä määrittelee isäntäkoneen OS:n ja asentaa sille sekä Masterin että Minionin.
Lopuksi kannattaa tarkistaa masterin asetus tiedostosta interface osoite masterille `sudoedit /etc/salt/master`.

Kun versio ongelmat on korjattu siirrytään Windows repositoryn rakentamiseen. 
`sudo salt-run winrepo.update_git_repos` joka lataa windows repon masterille.
`sudo salt -G 'os:windows' pkg.list_pkg`

Windows state moduuli ohjelmien asentamiseksi valmiista reposta onkin aivan triviaali asia sillä se tapahtuu kuten linux koneille tarkoitetissa moduuleissa.
esim.
```
 install_windows:
   pkg.installed:
     - pkgs:
       - firefox
       - libreoffice
```


## Oman ohjelman asennus moduulin lisääminen Windowsin repositoryyn

Aluksi otin mallia muista asennus moduuleista ja tein oman moduulin joka asentaisi Blizzard App:in.
Tätä varten tein kaksi tiedostoa nimellä battlenet.sls. Ensimmäiseen laitoin:
```
battlenet:
  '1.9':
    full_name: 'Battle.net'
    installer: 'https://eu.battle.net/download/getInstaller?os=win&installer=Battle.net-Setup.exe'
    install_flags: '/S'
    uninstaller: 'https://eu.battle.net/download/getInstaller?os=win&installer=Battle.net-Setup.exe'
    msiexec: False
    locale: en_US
    reboot: False
```
Tämä meni kansioon /srv/salt/win/repo/salt-winrepo/
ja toiseen tuli:
```
# just 32-bit x86 installer available
{% if grains['cpuarch'] == 'AMD64' %}
    {% set PROGRAM_FILES = "%ProgramFiles(x86)%" %}
{% else %}
    {% set PROGRAM_FILES = "%ProgramFiles%" %}
{% endif %}
battlenet:
  '1.9':
    full_name: 'Battle.net'
    installer: 'https://eu.battle.net/download/getInstaller?os=win&installer=Battle.net-Setup.exe'
    install_flags: '/S'
    uninstaller: 'https://eu.battle.net/download/getInstaller?os=win&installer=Battle.net-Setup.exe'
    msiexec: False
    locale: en_US
    reboot: False
```
Tämä tiedosto tuli kansioon /srv/salt/win/repo-ng/salt-winrepo-ng/

Ajoin tämän käskyn one-liner komennolla `sudo salt 'WinMin' pkg.install 'battlenet'`
tuloksena hieman odottelua ja kun katsoin windows minionin task manageria näkyi sielä nyt Blizzard App Setup. Moduuli oli siis onnistunut lataamaan exe paketin mutta jossakin oli vikaa koska asennus ei näyttänyt etenevän.
Luettuani Salt dokumentaatiota https://docs.saltstack.com/en/latest/topics/windows/windows-package-manager.html#creating-a-package-definition-sls-file windows repository moduulin luonnista päädyin lopputulokseen että asennusohjelma odotti vastauksia asennusprosessin aikana esitettäviin kysymyksiin kuten asennuskieli ja asennus polku.
Kokeilin erilaisia install_flagsejä mutta mikään ei näyttänyt toimivan ja suuri ongelma oli löytää mahdollisia flagejä kunne törmäsin googlatessa sivuun https://msdn.microsoft.com/en-us/library/windows/desktop/aa367988(v=vs.85).aspx.

Testi epäonnistui siis ja lopulta päätin lopettaa kun löysin Blizzardin palaute osiosta keskustelun https://us.battle.net/forums/en/bnet/topic/20754376631 jonka perusteella tulin johtopäätökseen että ehkä yritän mahdotonta.

Ehkäpä olisi pitäny valita jokin muu ohjelma asennettavaksi ja voihan olla että kokeilen myöhemmin uudestaan luoda vastaavan moduulin asentamaan jotakin muuta.

## Windows käyttäjän lisääminen

Windows käyttäjän lisääminen oli yllättävän helppo ja lähes samanlainen kuin Linux käyttäjän lisääminen.
```
 CreateUser:
   user.present:
    - name: opiskelija
    - fullname: opiskelija
    - password: 'salainen'
    - groups:
      - Administrators
```
Windowsissa salasana meni plaintext muodossa eikä se edes hyväksynyt cryptattua salasanaa.

## Windows wallpaper vaihto

Ensinnäkin yritin vaihtaa Windowsin default taustakuvan kansiosta C:\Windows\Web\Wallpaper\Windows\img0.jpg mutta eihän se onnistunut koska Windowsin mukaan minulla ei ollut oikeuksia kyseiseen tiedostoon.
Lyhyt kuvan tarkastelu kertoi käyttäjällä TrustedIstaller olevan tämän kuvan oikeudet. No tästä alkoi selvittely että miten saisin oikeudet itselle. http://ccmexec.com/2015/08/replacing-default-wallpaper-in-windows-10-using-scriptmdtsccm/
sivulla kerrottiin asiasta ja tein ohjeen mukaisen scriptin siirtämään ensin omistuksen ja sitten antamaan täydet oikeudet käyttäjälle System jonka jälkeen kuva korvattaiin.

Scripti ei itselläni ainakaan suoraan toiminut ja päädyin kokeilemaan scriptiin kirjoitettuja käskyjä itse admin oikeuksilla varustetulla Powershellissä rivi riviltä. Tämä toimi ja mutta itse scriptin pyöräyttäminen ei.
Päädyin tulokseen että scripti ei oletuksena pyörähtänyt admin oikeuksilla joten lisäsin scriptiin rivin. `if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }`

Salt moduulini ei siltikään onnistunut ajamaan scriptiä ja kokeiltuani montaa eri formaattia ja tapaa kirjoittaa moduuli joka ajaisi Powershell scriptini Windows minionilla, tuloksena oli silti pyöreä nolla.
Lopulta korjattuani useat kirjoitusvirheet ja saatuani hieman apua päädyin ensin siirtämään scriptin Windows minionille ja sitten ajamaan sen sielä.
```
 C:\Replacewallpaper.ps1:
   file:
     - managed
     - source: salt://ReplaceWallpaper.ps1
 
 Run myscript:
   cmd:
     - run
     - name: C:\ReplaceWallpaper.ps1
     - shell: powershell
```

No nyt yllättäen virheilmoitus salt moduulia ajaessa muuttui. Tuli ilmoitus joka kertoi scriptien ajamisen etänä olevan estetty tietoturvasyistä Windows 10 koneissa. Kerroin tästä Artic projektitiimin jäsenille ja sain nopean vastauksen,
joka korjasi ongelman.

`Set-ExecutionPolicy RemoteSigned`
