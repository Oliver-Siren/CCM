# Käyttöohje Ansiblen esimerkkitoteutukselle

Testattu Haaga-Helian labraluokassa 5004.

Konfiguraatio hakee käyttäjänimen ja muut masterin tiedot automaattisesti, joten muokattavia tiedostoja on vain kaksi. DHCP-palvelulle täytyy määritellä kohdekoneet ja lisätä niiden IP-osoitteet hosts tiedostoon. 

## Ansiblen asennus

Asenna masterkoneelle Xubuntu 16.04.3. Livetilaa ei ole testattu. Asennuksen valmistuttua anna seuraavat komennot:
```
sudo apt-get update && sudo apt-get -y install git && git clone https://github.com/joonaleppalahti/CCM.git
```
```
cd CCM/ansible/
```
```
./ansible_install.sh
```
Anna tarvittaessa sudo salasana ja paina enteriä sitä kysyttäessä. Nyt Ansible on asennettu ja esimerkkitiedostot siirretty paikalleen /etc/ansible/ hakemistoon. Ansible on nyt käytettävissä ja seuraavaa osaa ei tarvitse tehdä, ellei halua käyttää provisiointia.

## Linux provisiointi

```
sudoedit /etc/ansible/roles/master/files/dhcpd.conf.j2
```
Lisää kohteen MAC-osoite hardware ethernet kohtaan, haluttu IP-osoite fixed-address kohtaan, sekä hostname. Voit lisätä useampia koneita toistamalla host kohdan.

Huom! Hostnamen määritys ei aina toimi ja asennuksen jälkeen kohteen hostname voi olla oletus "ubuntu". Ansiblea väärä hostname ei haittaa, mutta muut hallintasovellukset eivät pidä väärästä hostnamesta.

```
sudoedit /etc/ansible/hosts
```
Lisää määrittämäsi IP-osoitteet hosts tiedostoon. Webserver ja webdatabase ryhmät sopivat testaukseen hyvin.

```
ansible-playbook /etc/ansible/master.yml --ask-become-pass
```
Playbookin ajon jälkeen kohteet voidaan käynnistää taikapaketilla.
```
wakeonlan a0:8c:fd:d0:53:3c
```
Huom! Jos kone on sammutettu Windowsin kautta, ei wakeonlan toimi. Verkkobootin voi käynnistää manuaalisesti painamalla F12 käynnistyksen yhteydessä. Ongelman voi myös korjata käynnistämällä koneen ja sammuttamalla sen POST-ikkunan aikana.

Asennuksen valmistuttua kone jää sammuksiin, sillä testatut koneet käynnistyivät automaattisesti Windowsiin. Käynnistä kone manuaalisesti Linuxiin. Koneen käynnistyttyä ajetaan masterilla linux.yml.

Huom! Linux-desktop roolia varten tulee graafinen käyttöliittymä olla asennettu. Xubuntu-desktop paketti puuttuu oletuksena playbookista, sillä asennus kestää todella kauan. Voit lisätä sen halutessasi linux-desktop roolin tasks playbookiin ensimmäiseksi asennettavasti paketiksi.
```
ansible-playbook /etc/ansible/linux.yml --ask-become-pass
```
Anna preseedissä määritetty salasana, joka on oletuksena salainen.

Apachen (ja MariaDB:n) pitäisi asentua ja kohteen IP-osoitteesta löytyä PHP-testisivu. Playbook myös lisäsi kohteelle käyttäjän opiskelija.

# Windows

Asenna Windows 10. Määritä koneelle staattinen IP-osoite. Avaa PowerShell pääkäyttäjänä ja anna komento `Set-ExecutionPolicy RemoteSigned` ja aja sen jälkeen https://github.com/ansible/ansible/blob/devel/examples/scripts/ConfigureRemotingForAnsible.ps1 PowerShell-scripti pääkäyttäjänä.

Muuta salasanasi masterille /etc/ansible/group_vars/windows-desktop.yml tiedostoon ja lisää määrittämäsi IP-osoite hosts tiedostoon.

Nyt voit ajaa windows.yml playbookin. --ask-become-pass ei tarvita.

Playbook asentaa WinSCP, Notepad++ ja LibreOffice, lisää käyttäjän opiskelija, sekä vaihtaa taustakuvan. Taustakuva näkyy uusilla käyttäjillä, sekä mahdollisesti vanhoilla jos Windows on aktivoitu.
