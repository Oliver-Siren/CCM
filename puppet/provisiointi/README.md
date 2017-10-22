# Linux provisiointi
Aloitin Palvelinympäristön valmistelun Xubuntu 16.04.3 LTS Puppetmaster viertuaalikoneessani.

Olin Kokeillut verkkoaboottia jo Tero Karvisen kurssilla, mutta käytin ohjeena Joona Leppälahden tekemiä kattavia artikkeleita aiheesta: 
https://joonaleppalahti.wordpress.com/2016/12/11/pupxegrant-puppet-pxe-ja-vagrant-konfiguraatio/ https://joonaleppalahti.wordpress.com/2016/11/18/palvelinten-hallinta-harjoitus-8/
https://joonaleppalahti.wordpress.com/2016/11/18/palvelinten-hallinta-harjoitus-9/

Mietin aluksi ryhmän jäsenen kanssa sitä, miten haluamme hyväksyä sertifikaatit. Päädyimme ratkaisuun, jossa hyväksymme autosign.conf tiedoston whitelistissa olevien osoitteiden sertifikaatit automaattisesti. Mikäli Haluaa noudattaa tiukempaa turvallisuuslinjaa, niin sertifikaatit pitää silloin hyväksyä masterilla käsin.

Autosign.conffin sisältö:

```
provorja.zyxel.setup
*.zyxel.setup
*.local
```

Tämän jälkeen asensin koneelle sellaisia ohjelmia, joita tulisin tarvitsemaan provisionnissa. (Puppetmaster oli jo koneella asennettuna).

sudo apt-get install -y wakeonlan

sudo apt-get install -y isc-dhcp-server

sudo apt-get install -y tftpd-hpa

sudo apt-get install -y squid-deb-proxy

Tarkistin aluksi kohdekoneen mac osoitteen. Sitten yritin käynnistää kohdekoneen wakeonlan ohjelman avulla. Annoin komennon:

`wakeonlan "mac tähän"`

Ja kone käynnistyi. 

Seuraavaksi lisäsin masterin verkkokortin sijaintiin /etc/default/isc-dhcp-server

`INTERFACES="enp0s3"`
