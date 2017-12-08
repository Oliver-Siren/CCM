# Käyttöohje Ansiblen esimerkkitoteutukselle

## Ansiblen asennus
```
sudo apt-get update && sudo apt-get -y install git && git clone https://github.com/joonaleppalahti/CCM.git
```
```
cd CCM/ansible/
```
```
./ansible_install.sh
```
Anna tarvittaessa sudo salasana ja paina enteriä sitä kysyttäessä. Nyt Ansible on asennettu ja esimerkkitiedostot siirretty paikalleen /etc/ansible/ hakemistoon.

## Linux provisioinnin valmistelu

```
sudoedit /etc/ansible/roles/master/files/dhcpd.conf.j2
```
Lisää kohteen MAC-osoite hardware ethernet kohtaan, haluttu IP-osoite fixed-address kohtaan, sekä hostname. Voit lisätä useampia koneita toistamalla host kohdan.

```
sudoedit /etc/ansible/hosts
```
Lisää määrittämäsi IP-osoitteet hosts tiedostoon. Webserver ja webdatabase ryhmät sopivat testaukseen hyvin.

```
ansible-playbook /etc/ansible/master.yml --ask-become-pass
```
Playbookin ajon jälkeen kohteet voidaan käynnistää taikapaketilla.
```
wakeonlan 00:21:86:01:6e:2e
```
Asennuksen valmistuttua ajetaan linux.yml
```
ansible-playbook /etc/ansible/linux.yml --ask-become-pass
```
Apachen pitäisi asentua ja kohteen IP-osoitteesta löytyä PHP-testisivu.

# Windows

## Windowsin valmistelu

Asenna Windows 10 käsin ja lataa CCM repository GitHubista. Avaa PowerShell pääkäyttäjänä ja anna komento `Set-ExecutionPolicy RemoteSigned` ja aja sen jälkeen https://github.com/ansible/ansible/blob/devel/examples/scripts/ConfigureRemotingForAnsible.ps1 PowerShell scripti pääkäyttäjänä.

Muuta salasanasi masterille /etc/ansible/group_vars/windows-desktop.yml tiedostoon.

Nyt voit ajaa windows.yml playbookin. --ask-become-pass ei tarvita.
