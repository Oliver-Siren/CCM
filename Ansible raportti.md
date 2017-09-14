# Ansible
## Tutustuminen Ansibleen
Aloitin testauksen asentamalla kaksi kappaletta Xubuntua (16.04.3) Virtualboxiin. Toinen kone toimii masterina ja toinen kohteena. Tämän jälkeen aloin lukemaan Ansiblen [dokumentaatiota](https://docs.ansible.com/ansible/latest/intro.html) ja [Wikipedia-artikkelia](https://en.wikipedia.org/wiki/Ansible_(software)). 

Asennus masterille kävi kätevästi komennolla `sudo apt-get -y install ansible`. Lisäsin kohdekoneen IP-osoitteen `/etc/ansible/hosts` tiedostoon ja tein sille ryhmän test.
``` 
[test]
10.0.0.64
```
Ansible toimii SSH:n yli, joten asensin kohteelle SSH:n `sudo apt-get -y install ssh`. Tämän jälkeen lisäsin masterin julkisen avaimen kohteelle.
```
ssh-keygen -t rsa
ssh-copy-id joona@10.0.0.64
```
Kokeilin yhteyttä masterilla komennolla `ansible test -m ping`. Test on ryhmän nimi, johon kohde kuuluu ja ping on moduuli joka ajetaan.
```
10.0.0.64 | SUCCESS => {
    "changed": false, 
    "ping": "pong"
}
```
Pingi meni läpi ja kohde vastasi.

## Playbook

Playbookit ovat YAML-formaatissa kirjoitettuja ohjeita, jotka määrittelevät tehtävät kohteille. Kokeilin esimerkkinä äskeistä ping-komentoa. `sudoedit /etc/ansible/apache.yml`. Tiedoston nimenä on apache, sillä pingin jälkeen kokeilen apachen asennusta.
```
---
- hosts: test
  remote_user: joona
  tasks:
    - name: testing ping
      ping:
```
Ajoin playbookin komennolla `ansible-playbook /etc/ansible/apache.yml`
```
PLAY *************************

TASK [setup] ********************
ok: [10.0.0.64]

TASK [testing ping] **********
ok: [10.0.0.64]

PLAY RECAP ********************
10.0.0.64                  : ok=2    changed=0    unreachable=0    failed=0 
```
Tulosteesta näkyy, että playbookin ajaminen onnistui.

### Pakettien asennus playbookilla

Lisäsin apache.yml playbookiin Apachen asennuksen [dokumentaation](https://docs.ansible.com/ansible/latest/package_module.html) mukaan.
```
---
- hosts: test
  remote_user: joona
  tasks:
    - name: testing ping
      ping:
    - name: install apache
      package:
        name: apache2
        state: latest
```
Ennen playbookin ajamista avasin kohteella selaimen ja tarkastin ettei localhost osoitteessa näy mitään. Selain tarjosi "Unable to connect", joten Apachea ei koneesta löytynyt. Ajoin playbookin komennolla `ansible-playbook /etc/ansible/apache.yml`  ja sain pitkän virheilmoituksen käyttöoikeuksien puutteesta. Lisäsin playbookin loppuun `become: true`, jotta asennus ajetaan pääkäyttäjänä.
```
---
- hosts: test
  remote_user: joona
  tasks:
    - name: testing ping
      ping:
    - name: install apache
      package:
        name: apache2
        state: latest
      become: true
```
sain virheilmoituksen jossa valitetaan puuttuvaa salasanaa.
```
fatal: [10.0.0.64]: FAILED! => {"changed": false, "failed": true, "module_stderr": "", "module_stdout": "sudo: a password is required\r\n", "msg": "MODULE FAILURE", "parsed": false}
```
Dokumentaation kaivelemisen jälkeen lisäsin `--ask-become-pass` playbookin ajokomennon loppuun. Ajoin playbookin `ansible-playbook /etc/ansible/apache.yml --ask-become-pass` komennolla ja syötin kysytyn salasanan.
```
PLAY ***********************************

TASK [setup] *************************
ok: [10.0.0.64]

TASK [testing ping] ********************
ok: [10.0.0.64]

TASK [install apache] ***************
changed: [10.0.0.64]

PLAY RECAP *************************
10.0.0.64                  : ok=3    changed=1    unreachable=0    failed=0   
```
Tuloste kertoo että Ansible on tehnyt kohteessa muutoksia, eli asentanut Apachen. Avasin kohteella selaimen ja localhost osoitteessa komeili Apachen oletussivu. Playbookia uudelleen ajettaessa Ansible ilmoittaa että kaikki on ok ja muutoksia ei tehty. Kokeilin myös poistaa Apachen muuttamalla playbookissa Apachen kohdalla `state: absent`.  Ajoin playbookin ja tuloste näytti samalta kuin asentaessa, mutta nyt selain näyttää "Unable to connect" joten Apache on poistettu.