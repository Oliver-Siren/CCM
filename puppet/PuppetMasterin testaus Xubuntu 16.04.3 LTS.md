# Puppetmaster testi Xubuntu 16.04.3 LTS

Aloitin Puppetin testauksen asentamalla Oracle VirtualBoxin version 5.1.26-117224 Windows 10 pro koneelleni. Edellinen VirtualBoxini ei enää toiminut koska koneeni oli päivittynyt Windows 10 Anniversary Updateen. Loin tämän jälkeen VirtualBoxin Ubuntun 64bit default asetuksilla ja Xubuntun 16.04.3 LTS levykuvalla. (https://xubuntu.org/getxubuntu/#lts)

Tämän jälkeen ajoin komennot 

`sudo apt-get update`

`sudo apt-get upgrade`

Seuraavaksi loin uuden virtuaalikoneen, joka tulisi toimimaan orjakoneena aiemmin luomalleni virtuaalikoneelle. Päätin seuraavaksi valmistella puppetmasterina toimivan virtuaalixubuntun valmistelun. Seurasin masteria luodessani Joona Leppälahden (https://joonaleppalahti.wordpress.com/2016/10/31/palvelinten-hallinta-harjoitus-3/) ja Tero Karvisen (http://terokarvinen.com/2012/puppetmaster-on-ubuntu-12-04) sivuilta ohjeita ettei tule turhia virheitä.
Aion myöhemmin tehdä skriptit, joilla voin automatisoida prosessin. Jos haluaa itse konffata masterin ja orjan, niin edellä mainitsemieni linkkien avulla se onnistuu helposti. 

## Puppetmaster asennus

Ensin annoin masterille hostnamen

`sudo hostnamectl set-hostname master`

ja sen jälkeen lisäsin kyseisen hostnamen `/etc/hosts` tiedostoon oman koneeni nimen perään. 
![alt text](https://raw.githubusercontent.com/joonaleppalahti/CCM/master/puppet/kuvat/1.png "1")

Tämän jälkeen käynnistin Avahi-daemonin uudelleen

 `sudo service avahi-daemon restart`

Sitten asensin PuppetMasterin.

`sudo apt-get -y install puppetmaster`

Seuraavaksi pysäytin PuppetMasterin ja poistin SSL sertifikaatit

`sudo service puppetmaster stop`

`sudo rm -r /var/lib/puppet/ssl`

Sitten lisäsin masterin nimen puppet.conf tiedoston loppuun [master] kohdan sisälle. Koska kyseessä on testi niin lisäsin tänne myös autosign = true joka hyväksyy sertifikaatit automaattisesti (HUOM! tämä on turvallisuuden kannalta todella huono asia).

`dns_alt_names = master.local`

`autosign = true`

Lopuksi käynnistin PuppetMasterin uudelleen

`sudo service puppetmaster start`

## Orjakoneen asennus

Ensin asensin puppetin 

`sudo apt-get -y install puppet`

ja lisäsin masterin DNS-nimen /etc/puppet/puppet.conf tiedoston loppuun

`[agent]
server = master.local`

Tämän jälkeen määräsin koneen orjaksi

`sudo puppet agent --enable`

Yhdistin orjan masteriin 

`sudo service puppet restart`

Testasin että yhteys toimii antamalla komennon "sudo puppet agent --test -dv" orjakoneessa, ja huomasin että moduuli siirtyi PuppetMasterilta. (Huom komennon joutuu ajamaan kaksi kertaa).
![alt text](https://raw.githubusercontent.com/joonaleppalahti/CCM/master/puppet/kuvat/2.png "2")
