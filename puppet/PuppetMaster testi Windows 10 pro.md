## PuppetMaster testi Xubuntu 16.04.3 LTS koneelta Windows 10 pro orjakoneelle. 

Kun Windows 10 pro oli asentunut VirtualBoxiini, niin aloitin valmistelemalla sen Puppetin asennusta varten. Käytin ohjeena tätä tehdessä Tero Karvisen artikkelia aiheesta (http://terokarvinen.com/2016/windows-10-as-a-puppet-slave-for-ubuntu-16-04-master). 

Ensimmäiseksi piti poistaa UAC käytöstä ja käynnistää kone uudelleen. Tässä kohtaa täytyy muistaa että Puppetin on oltava samaa versiota kuin PuppetMaster koneen puppet. Version voi tarkistaa komennolla `puppet --version`

Tämän jälkeen asensin Puppetin käyttäen adminstrative Powershelliä.
![alt text](https://raw.githubusercontent.com/joonaleppalahti/CCM/master/puppet/kuvat/3,5.png "3,5")
![alt text](https://raw.githubusercontent.com/joonaleppalahti/CCM/master/puppet/kuvat/3.png "3")

Asennuksen yhteydessä kysyttiin myös masterin DNS-nimeä joten kirjoitin siihen master.local.

Seuraavaksi asensin Bonjourin jotta .local osoitteet toimisivat. 

Sitten kokeilin pingata masteria komennolla ping master.local ja pingi meni läpi.

Tässä välissä tein PuppetMaster Xubuntuun esimerkkimoduulin Tero Karvisen mallin mukaan.

Ajoin puppetin Windows 10 pro virtuaalikoneessa kirjoittamalla hakukenttään puppet ja valitsin "Start Command Prompt with Puppet" ja oikealla hiiren napilla valitsin "Run as administrator". Sitten annoin komennon "puppet agent -tdv"

Tämän jälkeen hyväksyin orjan sertifikaatit PuppetMasterilla

`sudo puppet cert list`

`sudo puppet cert sign (orjan nimi)`

Lopuksi ajoin komennon "puppet agent -tdv" ja puppet moduuli helloeero oli siirtynyt Windows orjakoneelle.
![alt text](https://raw.githubusercontent.com/joonaleppalahti/CCM/master/puppet/kuvat/4.png "4")
