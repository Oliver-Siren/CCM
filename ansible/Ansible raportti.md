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

## Testiympäristö Vagrantilla

Vagrantin avulla voi luoda ja tuhota nopeasti virtuaalikoneita, joten se sopii mainiosti keskitetyn hallinnan testaamiseen. Yritin aluksi käyttää Vagrantia VirtualBoxin sisällä, jolloin se olisi luonut virtuaalikoneita virtuaalikoneen sisään, mutta törmäsin jatkuvasti ongelmiin, jotka todennäköisesti johtuivat sisäkkäisistä virtuaalikoneista. Lopulta päädyin asentamaan Vagrant ja Cygwin ohjelmat Windowsille. Cygwinin avulla pystyin käyttämään tuttuja Linux-komentoja Vagrantin hallintaan. Cygwinin emulaattorissa annoin seuraavat komennot: 
```
mkdir vagrant
cd vagrant
vagrant init bento/ubuntu-16.04
```
Tämän jälkeen virtuaalikoneen saa käyntiin `vagrant up` komennolla, mutta Ansible tarvitsee SSH-avaimen kohteelle, jotta se pystyy ottamaan siihen yhteyden. Siispä konfiguroin seuraavaksi provisioinnin, joka lisää virtuaalikoneeseen käyttäjän ja asettaa SSH-avaimen paikalleen.

### Provisiointi

Vagrant tukee provisiointia shell-scriptillä, Puppetilla, Chefillä, Saltilla, Dockerilla ja myös Ansiblella. Tutkin Vagrantin [dokumentaatiota](https://www.vagrantup.com/docs/provisioning/ansible.html), jonka perusteella määritin Ansiblen suorittamaan provisioinnin. 

#### Vagrantfile

`Vagrant init` komento luo Vagrantfile nimisen tiedoston, joka sitältää valmiiksi kommentoituja asetuksia. otin käyttöön public networkin, jotta saan masterilta yhteyden luotuun koneeseen: `config.vm.network "public_network", ip: "10.0.0.6"`, tämän lisäksi määritin provisioinnin tehtäväksi Ansiblella:
```
config.vm.provision "ansible_local" do |ansible|
	ansible.playbook = "vagrant.yml"
end
```

#### Provisiointi Ansiblella

Loin aluksi ansiblella käyttäjätunnuksen, mutta siinä oli ongelmia joita Vagrantin luomalla tunnuksella ei ollut. Esimerkiksi cd komennolla .ssh hakemistoon siirryttäessä sain virheilmoituksen `-sh: 3: cd: can't cd to .ssh`. Päätin käyttää vagrant käyttäjää testien ajamiseen, joten SSH-avaimen lisäys riitti provisiointiin. SSH:n Vagrant asentaa automaattisesti. Tein samaan hakemistoon jossa Vagrantfile sijaitsee, authorized_keys tiedoston jossa masterin julkinen avain on. Tein lisäksi samaan hakemistoon vagrant.yml playbookin, joka siirtää avaimen paikalleen:
```
---
- hosts: default
  remote_user: vagrant
  
  tasks:
    - template:
        src: authorized_keys
        dest: /home/vagrant/.ssh
        owner: vagrant
        group: vagrant
        mode: 0644
```
Tämä korvaa olemassaolevan avaimen, joten `vagrant ssh` komennolla ei enää pääse suoraan koneeseen, mutta salasana toimii yhä. Nyt saan masterilta suoraan yhteyden helposti uudelleenasennettavaan virtuaalikoneeseen.

### LAMP, roolit ja hakemistorakenne

Asensin aikaisemmin pelkän Apachen, mutta nyt on vuorossa koko LAMP-pino. Löysin hyvän [ohjeen](http://labs.qandidate.com/blog/2013/11/21/installing-a-lamp-server-with-ansible-playbooks-and-roles/) joka käy läpi LAMP asennuksen, sekä selventää rooleja ja hakemistorakennetta.

```
├── ansible.cfg
├── hosts
├── playbook.yml
└── roles
    ├── database
    │   ├── files
    │   └── tasks
    │       └── main.yml
    └── webserver
        ├── files
        │   └── index.php
        └── tasks
            └── main.yml
```
Ansiblen hakemistorakenne. Kaiken konfiguraation voisi kirjoittaa yhteen playbookiin, mutta silloin kaikki koneet konfiguroituisivat samalla tavalla. Roolien avulla voidaan päättää eri koneiden konfiguraatiot.
```
---
- hosts: all
  remote_user: vagrant
  become: yes
  roles:
    - webserver
    - database
```
Playbook.yml sisältö. Tällä hetkellä kaikille koneille annetaan roolit webserver ja database. Tässä playbookissa määritellään mitä rooleja annetaan millekin hostille.

```
---
- name: install apache
  package: name=apache2 state=present

- name: install php
  package: name=libapache2-mod-php state=present

- name: keep apache running
  service: name=apache2 state=running enabled=yes

- name: php test page
  copy: src=index.php dest=/var/www/html/index.php mode=0664
```
roles/webserver/tasks/main.yml sitältö, jossa asennetaan Apache ja PHP, pidetään huoli että Apache on käynnissä ja laitetaan roles/webserver/files/index.php paikalleen /var/www/html hakemistoon.

Index.php sisältää yksinkertaisen PHP testin.
```
<?php
echo "hello php!";
```
10.0.0.6/index.php osoitteessa näkyi "hello php!"

#### MariaDB

Löytämäni ohje asensi MariaDB:n, mutta kokeilen MySQL:ää myöhemmin.

```
---
- name: install mariaDB server
  package: name=mariadb-server state=present

- name: start mysql service
  service: name=mysql state=started enabled=true

- name: install python mysql package
  package: name=python-mysqldb state=present

- name: create new database
  mysql_db: name=vagrant state=present collation=utf8_general_ci

- name: create database user
  mysql_user: name=vagrant password=vagrant priv=*.*:ALL host=localhost state=present
```
roles/database/tasks/main.yml sisältö. Playbook asentaa MariaDB palvelun ja varmistaa että se on käynnissä. Sitten se asentaa python-mysqldb paketin, jolla tietokantaa hallitaan. Lopuksi luodaan tietokanta ja käyttäjä.

Asennuksen jälkeen otin SSH yhteyden kohdekoneelle ja kokeilin kirjautua tietokantaan `mysql -u vagrant -p`, salasanan syöttämisen jälkeen pääsin sisään. `Welcome to the MariaDB monitor.`

# Windowsin hallinta

### Masterin valmistelu

Seurasin Ansiblen [dokumentaatiota](https://docs.ansible.com/ansible/latest/intro_windows.html) Windowsiin liittyen. Ensimmäiseksi masterille täytyi asentaa pip, jotta sain pywinrm asennettua `sudo apt-get -y install python-pip` ja `pip install "pywinrm>=0.2.2"` Seuraavaksi loin /etc/ansible/group_vars/windows.yml tiedoston, jonka sisällöksi tuli seuraava:
```
ansible_user: joona
ansible_password: salasanatähän
ansible_port: 5986
ansible_connection: winrm
ansible_winrm_server_cert_validation: ignore
```
Lisäsin myös Windows koneen IP-osoitteen hosts tiedostoon omaan ryhmäänsä
```
[windows]
10.0.0.149
```

### Windowsin valmistelu

Asensin virtualboxiin Windows 10 Pro 64-bit käyttöjärjestelmän. Hain [powershell-scriptin](https://github.com/ansible/ansible/blob/devel/examples/scripts/ConfigureRemotingForAnsible.ps1) joka valmistelee Windowsin PowerShell remoting yhteyden käyttöön ja tallensin sen työpöydälle nimellä `ansible.ps1`. Tämän jälkeen avasin PowerShellin pääkäyttäjänä ja yritin ajaa scriptin, mutta Windows sanoi että scriptien ajaminen on estetty. [Stackoverflow](https://stackoverflow.com/questions/4037939/powershell-says-execution-of-scripts-is-disabled-on-this-system) auttoi ja komennon `Set-ExecutionPolicy RemoteSigned` jälkeen scriptin ajo onnistui.

### Windows ping moduulin testaus

`Ansible windows -m win_ping` komento testaa yhteyttä Windowsiin. Vastauksena tuli:
```
10.0.0.149 | SUCCESS => {
    "changed": false, 
    "ping": "pong"
}
```

### Pakettien asennus

Tein Windowsille oman playbookin windows.yml ja roles hakemistoon sille oman roolin "lab".
```
---
- hosts: windows
  roles:
    - lab
```
Windows.yml sisältö.

Luin ensin mitä [Windows-moduuleja](https://docs.ansible.com/ansible/latest/list_of_windows_modules.html) Ansiblesta löytyy. Sen jälkeen loin ensin hakemiston `win_file` moduulilla, jonne oli tarkoitus ladata asennustiedostot. Yritin aluksi käyttää `win_get_url` moduulia, jolla olisin ladannut asennustiedoston internetistä, mutta `force: no` asetus ei toiminut, joka olisi estänyt uudelleenlatauksen jos tiedosto ei ole muuttunut. Seuraavaksi kokeilin `win_copy` moduulia, jonka avulla kopioin asennustiedoston masterilta kohteelle. Sitten `win_package` moduulilla WinSCP asennus käyntiin, mutta se ei onnistunut. Asennus lähti käyntiin mutta ei mennyt läpi, sillä en löytynyt oikeita argumentteja asennuksen ajamiseen. Lopulta päädyin käyttämään Chocolatey-paketinhallintaa.  Ensimmäisellä Chocolateyn ajokerralla sain virheilmoituksen:
```
fatal: [10.0.0.194]: FAILED! => {"changed": false, "failed": true, "msg": "Exception setting \"changed\": \"The property 'changed' cannot be found on this object. Verify that the property exists and can be set.\""}
```
Toisella ajokerralla WinSCP asentui ongelmitta, joten virheilmoituksen alkuperä jäi hämärän peittoon. Asensin aluksi WinSCP:n niin että name kohdassa luki vain winscp, ohjelma asentui, mutta sitä ei saanut poistettua muuttamalla `state: absent`. Lisäsin winscp perään .install, jolloin poistokin onnistui.
```
---
- name: create ansible directory
  win_file:
    path: C:\ansible
    state: directory
- name: copy winSCP installation file from master
  win_copy:
    src: roles/lab/files/WinSCP-5.11.1-Setup.exe
    dest: C:\ansible\
- name: install winSCP
  win_chocolatey:
    name: winscp.install
    state: present
```
/etc/ansible/roles/lab/tasks/main.yml sisältö. Hakemiston luonti ja asennustiedoston kopiointi ovat tässä tapauksessa turhia, sillä asensin WinSCP:n Chocolateyn avulla, mutta en poistanut niitä tästä esimerkistä koska niistä voi olla myöhemmin hyötyä.


## Taustakuvan vaihto Linux-desktop roolille

Lisäsin roolin Linux-desktop ja käytin alussa asentamaani virtuaalikonetta, jossa on käytössä graafinen käyttöliittymä. Muutin playbook.yml tiedoston nimen linux.yml ja lisäsin siihen linux-desktop kohdan.  Sitten katsoin Jorin [Salt raportista](https://github.com/joonaleppalahti/CCM/blob/master/salt/Salt%20raportti.md) miten hän oli vaihtanut työpöydän taustakuvan. Kokeilin aluksi pelkästään kuvan paikalleenlaittamista copy-moduulin avulla.
```
---
- name: change background image
  copy:
    src: roles/linux-desktop/files/arctic.jpeg
    dest: /usr/share/xfce4/backdrops/xubuntu-wallpaper.png
```
/etc/ansible/roles/linux-desktop/tasks/main.yml

Kuvatiedosto sijaitsee roolin files hakemistossa. Yritin ajaa playbookia, mutta Ansible valitti salasanan puuttumista.
```
fatal: [10.0.0.64]: FAILED! => {"changed": false, "failed": true, "module_stderr": "", "module_stdout": "sudo: a password is required\r\n", "msg": "MODULE FAILURE", "parsed": false}
```
Windowsia konfiguroidessani kerkesin jo unohtaa Linuxilla vaadittavan `--ask-become-pass`, jonka lisäämällä komennon perään playbook pyörähti läpi. Kuva kopioitui ja uusi taustakuva tuli heti näkyviin.

## Ublock-Origin Firefoxiin

Asensin paketinhallinnasta xul-ext-ublock-origin paketin, joka asentui mutta ei toiminut vanhasta versiosta johtuen. Yritin eri ohjeilla kopioida githubista lataamaani Ublock-Origin pakettia eri paikkoihin, kuten `/home/joona/.mozilla/extensions/` ja `/usr/lib/firefox-addons/extensions/`. Sitten huomasin että olin saattanut ladata vajaan paketin GitHubista ja latasin [1.14.11rc6](https://github.com/gorhill/uBlock/releases) version .xpi paketin. Purin paketin unzip komennolla ja löysin seuraavan paikan `/home/joona/.mozilla/firefox/nuu7ond9.default/extensions/`. Kopioin puretut tiedostot uBlock0@raymondhill.net hakemistoon, jonka laitoin äskeiseen hakemistoon.

Ublock-origin näkyi Firefoxissa, mutta se ei ollut käytössä koska en ladannut sitä luotettavasta lähteestä. Latasin lisäosan suoraan Mozillan sivuilta ja tein saman purkamisen ja siirtämisen kuin edellisen paketin kanssa ja nyt ublock toimi Firefoxissa. Lisäosa täytyy itse kytkeä päälle, sillä se on oletuksena poissa käytöstä.

Asensin uuden virtuaalikoneen, jotta pääsin testaamaan lisäosan asennusta puhtaalta pöydältä. Latasin uBlock Originin xpi-paketin Mozillan sivuilta, purin sen uBlock0@raymondhill.net hakemistoon, jonka kopioin kohteeseen `/usr/lib/firefox-addons/extensions`. Tuohon hakemistoon lisätyt lisäosat ovat käytössä kaikilla käyttäjillä. Lisäosa näkyi Firefoxissa, mutta valitti ettei se ollut luotettu, eikä sitä saanut käyttöön.

Seuraavaksi siirsin lisäosan `/home/joona/.mozilla/firefox/hwjiesab.default/extensions` hakemistoon. Välissä oleva .default kohta on käyttäjän uniikki id, joka voi aiheuttaa ongelmia uusien käyttäjien kanssa. Nyt Firefoxin käynnistyessä käyttäjän tulee hyväksyä lisäosan asennus, jonka jälkeen uBlock Origin toimii, mainokset ovat hävinneet.

Poistin uBlockin-Originin ja asensin vielä kerran `xul-ext-ublock-origin` paketin ja nyt uBlock-Origin toimi. Käytössä Firefox 54. Ajoin komennon `sudo apt-get upgrade`, jolloin firefox päivittyi versioon 55 ja uBlock-Origin on saanut merkinnän "legacy" eikä enää toimi. Versiossa 55 /usr/lib.. polkuun asennettuna lisäosa valittaa edelleen luotettavuudesta. Käyttäjäkohtaisessa asennuksessa käynnistyksen yhteydessä näkyvä ilmoitus on poistunut ja lisäosa tulee käytä erikseen laittamassa käyttöön add-ons valikosta, mutta silloin se toimii.

## Taustakuva Windowsiin

Ensin kopioin taustakuvan kohteelle:
```
- name: copy background image to created directory
  win_copy:
    src: roles/windows-desktop/files/arctic.jpeg
    dest: C:\ansible\
```
Sitten etsin miten vaihtaa taustakuva komentoriviltä, [windows-commandline.com:ista](https://www.windows-commandline.com/change-windows-wallpaper-command-line/) löysin ohjeen, jota sitten sovelsin koneen rekisteriä tutkimalla Ansiblen [win_regedit](https://docs.ansible.com/ansible/latest/win_regedit_module.html) moduuliin. 
```
- name: change background
  win_regedit:
    path: HKCU:\Control Panel\Desktop
    name: Wallpaper
    type: REG_SZ
    data: C:\ansible\arctic.jpeg
```
Sain virheilmoituksen:
```
fatal: [10.0.0.149]: FAILED! => {"changed": false, "failed": true, "msg": "Missing required argument: key"}
```
Virhettä Googletellessa löysin [groups.google](https://groups.google.com/forum/#!topic/ansible-project/VQo0Wo9VPYg) keskustelun, jonka perusteella minun tulisi käyttää eri nimiä kuin path, name ja type. Käytössäni on Ansiblen versio 2.0.0.2 ja uudet nimet ovat käytössä versiosta 2.3 eteenpäin. Vaihdoin nimet ja kokeilin uudelleen.
```
- name: change background
  win_regedit:
    key: HKCU:\Control Panel\Desktop
    entry: Wallpaper
    datatype: REG_SZ
    data: C:\ansible\arctic.jpeg
```
Sain erilaisen virheen tällä kertaa:
```
fatal: [10.0.0.149]: FAILED! => {"changed": false, "failed": true, "msg": "Argument datatype needs to be one of binary,dword,expandstring,multistring,string,qword but was REG_SZ."}
```
Kokeilin datatypen tilalle dword, expandstring ja string, mutta mitään muutosta ei tapahtunut. Otin datatypen kokonaan pois, eikä muutosta tapahtunut. Sitten kokeilin poistaa Wallpaper kohdan kokonaan:
```
win_regedit:
    key: HKCU:\Control Panel\Desktop
    entry: Wallpaper
    state: absent
```
Hupsista, Desktop osiosta hävisivät kaikki rekisteriavaimet, eli `entry: Wallpaper` ei tunnu toimivan. Ansiblen [vanhassa dokumentaatiossa](https://ansible-manual.readthedocs.io/en/stable-2.2/win_regedit_module.html) on käytetty entryn tilalla value, joten kokeilin sitä. 
```
win_regedit:
    key: HKCU:\Control Panel\Desktop
    value: Wallpaper
    data: C:\ansible\arctic.jpeg
```
Tämä toimi, Wallpaper kohtaan ilmestyi määrittämäni polku ja uudelleenkirjautumisen jälkeen uusi taustakuva tuli näkyviin.

Lisäsin vielä rekisteriavaimen, joka määrittää ettei taustakuvaa toisteta, jos se ei täytä koko ruutua. Testikuvani resoluutio oli 1440x810, joten sitä toistettiin oletuksena.
```
- name: make wallpaper fullscreen
  win_regedit:
    key: HKCU:\Control Panel\Desktop
    value: TileWallpaper
    data: 0
```
Uudelleenkirjautumisen jälkeen taustakuva peitti koko ruudun.

Tällä menetelmällä vaihdettu taustakuva vaihtuu sille käyttäjälle, jonka tunnuksilla ansiblea käytetään.

### Taustakuvan vaihto kaikille käyttäjille

Seuraavaksi lähdin kokeilemaan oletustaustakuvan korvausta omalla taustakuvallani. Törmäsin heti ongelmaan että edes admin oikeuksilla ei voi muokata kyseistä kuvaa. Kuva ja hakemisto jossa se sijaitsee kuuluu TrustedInstaller käyttäjälle. Win_owner moduuli ei toiminut versiossa 2.0.0.2, joten päädyin päivittämään uudempaan versioon Ansiblesta.

## Käyttäjän lisäys, Linux

Tein user moduulin dokumentaation pohjalta kohdan, joka lisää käyttäjän. Käytin aluksi selväkielistä salasanaa, mutta käyttäjälle ei voinut kirjautua. [Stackoverflowsta](https://stackoverflow.com/questions/19292899/creating-a-new-user-and-password-with-ansible/19318368#19318368) löytyi selvennystä salatun salasanan luontiin. `python -c 'import crypt; print crypt.crypt("This is my Password", "$1$SomeSalt$")'` komennolla voi luoda Ansiblelle sopivan salasanan.
```
- name: add user opiskelija
  user:
    name: opiskelija
    password: $1$suola$x3q8bwB9K87WryJYwGJ2j.
    shell: /bin/bash
```
Masterilta `ssh opiskelija@10.0.0.64` toimi ja salasanan syöttämisen jälkeen pääsin sisään käyttäjänä opiskelija.

## Käyttäjän lisäys, Windows

Käynnistin Windows 10 Pro 64-bit virtuaalikoneen, jossa ajoin puolen tunnin päivittämisen jälkeen windows-moduulin testiksi ja se ei toiminut. Päivitys oli rikkonut PowerShellin kautta luotavan yhteyden, mutta valmisteluscriptin uudelleenajo korjasi vian.
```
- name: create user opiskelija
  win_user:
    name: opiskelija
    password: salainen
    state: present
    groups:
      - Users
```
Win_user moduulin dokumentaation pohjalta tehty playbookin osa käyttäjän lisäykseen. Kokeilin ensin versiota, jossa ei ollut groups kohtaa. Ansible pyörähti läpi ilman ongelmia, mutta käyttäjää ei näkynyt missään. Kokeilin luoda toisen nimisen käyttäjän, jolle lisäsin groups kohdan. Lisäys korjasi ongelman ja käyttäjä ilmestyi. Ensin luotu käyttäjätili ei korjautunut uudelleenajettaessa groups kohdalla.

## Päivitys versioon 2.4

Koska win_owner moduuli ei toiminut aikaisemmin käyttämässäni versiossa 2.0.0.2, päätin päivittää uusimpaan versioon. Vanha versio johtui alkuperäisessä asennuksessa oikomisesta, sillä pakettivarastosta löytyi Ansible, mutta vanha versio. Oikein asennettuna olisi otettu käyttöön Ansiblen oma pakettivarasto, josta löytyy uusin versio.
```
sudo apt-get update
sudo apt-get install software-properties-common
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get update
sudo apt-get upgrade
```
Lisäsin Ansiblen pakettivaraston [dokumentaation](https://docs.ansible.com/ansible/latest/intro_installation.html) ohjeiden mukaan ja yritin upgradella päivittää sitä, mutta sain seuraavan ilmoituksen: 
```
The following packages have been kept back:
  ansible
```
[Askubuntu.comista](https://askubuntu.com/questions/601/the-following-packages-have-been-kept-back-why-and-how-do-i-solve-it/602#602) löysin ratkaisun, jossa kehotettiin antamaan `sudo apt-get install` komento ongelman ratkaisuksi. `sudo apt-get install ansible` komennon jälkeen asennus kysyi haluanko korvata olemassaolevat ansible.cfg ja hosts tiedostot uusilla. Ansible.cfg tiedoston korvasin, sillä en ollut tehnyt siihen muutoksia, mutta hosts tiedoston jätin korvaamatta. Asennus loi ansible.cfg.dpkg-old tiedoston, joka on vanha konfiguraatiotiedosto, sekä hosts.dpkg-dist, joka on esimerkkitiedosto. Poistin molemmat, sillä esimerkki hosts oli turha ja konfiguraatiotiedosto on tallessa GitHubissa. Tarkastin Ansiblen version komennolla `ansible --version` ja tuloste näytti 2.4.0.0.

## Playbookin testiajo päivityksen jälkeen

Käynnistin kaikki kohdevirtuaalikoneeni ja ajoin `ansible-playbook masterbook.yml --ask-become-pass` ja varauduin pahimpaan. Yllättäen kaikkien roolien tehdävät menivät läpi. Ainoa ilmoitus liittyi servicekomennon nimenmuutokseen.
```
[DEPRECATION WARNING]: state=running is deprecated. Please use state=started. This feature will be removed in version 2.7. 
Deprecation warnings can be disabled by setting deprecation_warnings=False in ansible.cfg.
```
Tein työtä käskettyä, vaihdoin running startediin ja ilmoitusta ei näkynyt seuraavan ajon yhteydessä.

## Windowsin taustakuvan vaihto jatkoa

Yritin vaihtaa oletuskuvan omistajaa win_owner moduulilla, mutta mitään ei tapahtunut. 
```
- name: change owner of default wallpaper
  win_owner:
    path: C:\WINDOWS\web\wallpaper\Windows\img0.jpg
    user: joona
```
Tiedosto täytyy luultavasti omistaa, jotta sen omistajaa voi muokata. 

Seuraavaksi yritin antaa itselleni lisää oikeuksia, jotta voin muokata kuvaa.
```
- name: change user right to access default wallpaper
  win_acl:
    path: C:\WINDOWS\web\wallpaper\Windows\img0.jpg
    user: joona
    rights: FullControl
    type: allow
    state: present
```
Sain täydet oikeudet kuvaan, joten seuraavaksi laitoin oman taustakuvani sen tilalle.
```
- name: overwrite default windows wallpaper
  win_copy:
    src: roles/windows-desktop/files/img0.jpg
    dest: C:\WINDOWS\web\wallpaper\Windows\
```
Alkuperäinen kuva korvautui omallani, mutta käyttäjien taustakuvat eivät vaihtuneet. Tarkastin rekisteristä taustakuvan polun HKEY_CURRENT_USER\Control Panel\Desktop\Wallpaper kohdasta, joka oli sama kuin korvattu tiedosto. Taustakuva on selvästi tallessa jossain muualla ja [superuser.comin keskustelusta](https://superuser.com/questions/966650/path-to-current-desktop-backgrounds-in-windows-10/977582#977582) löysin tämänhetkisen taustakuvan polkuun. `%AppData%\Microsoft\Windows\Themes\CachedFiles` hakemistosta löytyi vanha taustakuva. Sain idean kokeilla uuden käyttäjän luomista niin päin, että ensin laitetaan uusi taustakuva paikalleen windows hakemistoon, jonka jälkeen tehdään uusi käyttäjä. Tämä toimi ja uusille käyttäjille tuli käyttöön oma taustakuvani.

## Käytettyjä lähteitä

* https://docs.ansible.com/ansible/latest/intro.html
* https://docs.ansible.com/ansible/latest/intro_installation.html
* https://en.wikipedia.org/wiki/Ansible_(software)
* https://docs.ansible.com/ansible/latest/package_module.html
* https://www.vagrantup.com/docs/provisioning/ansible.html
* http://labs.qandidate.com/blog/2013/11/21/installing-a-lamp-server-with-ansible-playbooks-and-roles/
* https://docs.ansible.com/ansible/latest/intro_windows.html
* https://stackoverflow.com/questions/4037939/powershell-says-execution-of-scripts-is-disabled-on-this-system
* https://docs.ansible.com/ansible/latest/list_of_windows_modules.html
* https://github.com/gorhill/uBlock/releases
* https://www.windows-commandline.com/change-windows-wallpaper-command-line/
* https://docs.ansible.com/ansible/latest/win_regedit_module.html
* https://groups.google.com/forum/#!topic/ansible-project/VQo0Wo9VPYg
* https://ansible-manual.readthedocs.io/en/stable-2.2/win_regedit_module.html
* https://stackoverflow.com/questions/19292899/creating-a-new-user-and-password-with-ansible/19318368#19318368
* https://askubuntu.com/questions/601/the-following-packages-have-been-kept-back-why-and-how-do-i-solve-it/602#602
* https://superuser.com/questions/966650/path-to-current-desktop-backgrounds-in-windows-10/977582#977582