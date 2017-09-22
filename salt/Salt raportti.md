# SaltStack

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

## Minioni etsii isäntää (IP asetukset)

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

Yhteyden varmistamiseksi ohjeessa kehoitettiin pingaamaan minionia komennolla:
`sudo salt salt-minion test.ping`

Komennossa  sudo salt salt-minion test.ping, salt-minion viittaa minion koneen nimeen.

![alt text](https://github.com/joonaleppalahti/CCM/blob/master/salt/saltimg/saltminiontrue.png "Ping")

Minion vastasi pingiin.

## Ensimmäisen ohjelman asennus.

Salt voi antaa ohjelman asennuskäskyjä, kuten:
`sudo salt salt-minion pkg.install apache2`
![alt text](https://github.com/joonaleppalahti/CCM/blob/master/salt/saltimg/saltinstall.png "Istalling something via salt")

Asennus onnistui ja apache toimii koneella salt-minion, tämä tuli todettua hakemalla salt-minionin firefox selaimella osoitetta localhost.

![alt text](https://github.com/joonaleppalahti/CCM/blob/master/salt/saltimg/saltapache.png "Apache is alive")

## Salt state of the minions speech

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

## LAMP -asennus ja työpöydän taustakuvan vaihto

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

## MySQL toimii!!

Joskus auttaa kun ottaa hieman etäisyyttä ongelmaan, ja niin myös tässä tapauksessa. Tero Karvisen sivuilta http://terokarvinen.com/2015/preseed-mysql-server-password-with-salt-stack löytyneen preseedaus menetelmän avulla, 
root salasanan syöttäminen asennusvaiheessa saltilla onnistui ja sisäänkirjautuminen myös. Nyt siis LAMP toimii ja on aika siirtyä Windowsin ihmettelyyn.


## Lets open the Windows

