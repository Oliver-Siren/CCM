# Arctic CCM: Ansible - *Joona Leppälahti*

Tästä hakemistosta löytyvät raportti ansibleen tutustumisesta, hakemisto esimerkkitoteutukselle, sekä kehityshakemisto.

[Tutustumisraportissa](https://github.com/joonaleppalahti/CCM/blob/master/ansible/Ansible%20raportti.md) käyn läpi ensikosketuksen Ansibleen, sekä ongelmat, joihin törmäsin matkan varrella. Esimerkkitoteutuksen tiedostot ja käyttöohje löytyvät hakemistosta versio1.0. Kehityshakemistosta löytyy uusin versio kokoonpanosta, joka sisältää osia, jotka eivät soveltuneet ensimmäiseen esimerkkiversioon.

### Master ja Linux

Esimerkkitoteutuksen avulla Ansiblen, sekä provisiointikokoonpanon asennus käy hetkessä. Provisioinnin avulla voidaan asentaa useita Ubuntu-käyttöjärjestelmiä samanaikaisesti automaattisesti. Asennetuille kohteille voidaan määrittää Ansiblella esimerkiksi webserver-rooli, joka asentaa ja määrittää seuraavat osat:

* Asentaa apache2 ja php-lisäosan
* Poistaa apachen oletussivun
* Lisää PHP-testisivun
* Lisää käyttäjän opiskelija
* Sallii portit 22 ja 80 palomuurin läpi
* Ottaa palomuurin käyttöön
* Tarkastaa että apache on käynnissä

### Windows

Ansiblella voidaan hallita myös Windowsia. Esimerkkitoteutus ei sisällä Windowsin automaattista asennusta, joten se täytyy hoitaa itse.

## Projektin muut osat

Käy myös tutustumassa projektin muihin osiin:

* [Salt](https://github.com/joonaleppalahti/CCM/tree/master/salt)  - Jori Laine
* [puppet](https://github.com/joonaleppalahti/CCM/tree/master/puppet) - Eero Kolkki
* [Chef](https://github.com/joonaleppalahti/CCM/tree/master/chef/Chef) - Jarkko Koski
