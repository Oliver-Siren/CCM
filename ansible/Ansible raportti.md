# Ansible

## Sisällysluettelo
1. [Tutustuminen Ansibleen](#tutustuminen-ansibleen)
	1. [Playbook](#playbook) 
	2. [Pakettien asennus playbookilla](#pakettien-asennus-playbookilla)
2. [Testiympäristö Vagrantilla](#testiympäristö-vagrantilla)
	1. [Vagrantin provisiointi](#vagrantin-provisiointi)
	2. [Vagrantfile](#vagrantfile)
	3. [Provisiointi Ansiblella](#provisiointi-ansiblella)
3. [LAMP, roolit ja hakemistorakenne](#lamp-roolit-ja-hakemistorakenne)
	1. [MariaDB](#mariadb)
4. [Windowsin hallinta](#windowsin-hallinta)
	1. [Masterin valmistelu](#masterin-valmistelu)
	2. [Windowsin valmistelu](#windowsin-valmistelu)
	3. [Windows ping moduulin testaus](#windows-ping-moduulin-testaus)
	4. [Pakettien asennus](#pakettien-asennus)
5. [Taustakuvan vaihto Linux-desktop roolille](#taustakuvan-vaihto-linux-desktop-roolille)
6. [Ublock-Origin Firefoxiin](#ublock-origin-firefoxiin)
7. [Taustakuva Windowsiin](#taustakuva-windowsiin)
	1. [Taustakuvan vaihto kaikille käyttäjille](#taustakuvan-vaihto-kaikille-käyttäjille)
8. [Käyttäjän lisäys, Linux](#käyttäjän-lisäys-linux)
9. [Käyttäjän lisäys, Windows](#käyttäjän-lisäys-windows)
10. [Päivitys versioon 2.4](#päivitys-versioon-24)
	1. [Playbookin testiajo päivityksen jälkeen](#playbookin-testiajo-päivityksen-jälkeen)
11. [Windowsin taustakuvan vaihto, jatkoa](#windowsin-taustakuvan-vaihto-jatkoa)
12. [Pull-arkkitehtuuri](#pull-arkkitehtuuri)
	1. [Ansible-pull repository](#ansible-pull-repository)
	2. [Pull testaus](#pull-testaus)
13. [Provisiointi](#provisiointi)
	1. [DHCP](#dhcp)
	2. [TFTP](#tftp)
	3. [Preseed](#preseed)
	4. [Ansiblen provisiointi](#ansiblen-provisiointi)
14. [Käytettyjä lähteitä](#käytettyjä-lähteitä)

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

### Vagrantin provisiointi

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

### Playbookin testiajo päivityksen jälkeen

Käynnistin kaikki kohdevirtuaalikoneeni ja ajoin `ansible-playbook masterbook.yml --ask-become-pass` ja varauduin pahimpaan. Yllättäen kaikkien roolien tehdävät menivät läpi. Ainoa ilmoitus liittyi servicekomennon nimenmuutokseen.
```
[DEPRECATION WARNING]: state=running is deprecated. Please use state=started. This feature will be removed in version 2.7. 
Deprecation warnings can be disabled by setting deprecation_warnings=False in ansible.cfg.
```
Tein työtä käskettyä, vaihdoin running startediin ja ilmoitusta ei näkynyt seuraavan ajon yhteydessä.

## Windowsin taustakuvan vaihto, jatkoa

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

# Pull-arkkitehtuuri

Ennen provisiointia päätin toteuttaa pull arkkitehtuurin, jotta provisioituja koneita on helpompi hallita.

Muistin että dokumentaation playbook osiossa mainittiin ansible-pull. Sieltä löytyi linkki [playbookiin](https://github.com/ansible/ansible-examples/blob/master/language_features/ansible_pull.yml), jolla voidaan valmistella kohdekone kyselemään ohjeita. Ongelmia ratkoessani päädyin muuttamaan useampaa kohtaa:
```
- hosts: pull_mode_hosts
  remote_user: joona
  become: yes
```
```
# schedule is fed directly to cron
    schedule: '*/1 * * * *'
```
```
# Directory to where repository will be cloned
    workdir: /etc/ansible/local
```
```
- name: Create local directory to work from
      file: path={{workdir}} state=directory owner=root group=root mode=0755
```

Repo_url kohtaan lisäsin `git://github.com/joonaleppalahti/ansible-pull.git`, jonka loin ansible-pull testausta varten.

Playbookin lopussa olevat templatetiedostot hain GitHubista ja lisäsin ne masterille `/etc/ansible/templates` hakemistoon.

### Ansible-pull repository

Loin GitHubiin ansible-pull repositoryn, jonne tein localhost.yml playbookin. https://github.com/joonaleppalahti/ansible-pull
```
---
- hosts: webserver
  remote_user: vagrant
  become: yes
  roles:
    - webserver
```
Päätin asentaa testiksi vain webserver roolin, jonka sisällön otin suoraan masterilta. 

Myöhemmin muutin playbookin ja hosts sisältöä [Ansible-Pull-Example](https://github.com/RaymiiOrg/Ansible-Pull-Example) repositoryn perusteella.
```
---
- hosts: localhost
  remote_user: root
  roles:
    - webserver
```
Hosts tiedoston sisällöksi tuli:
```
localhost              ansible_connection=local
```
### Pull testaus

Käytin Vagrantin avulla tehtyä virtuaalikonetta. `ansible-playbook ansible_pull.yml --ask-become-pass` komento meni masterilla läpi, mutta kun kohde ajoi Ansiblea cronin kautta, sain virheilmoituksia `/var/log/ansible-pull.log` tiedostoon.
```
/usr/bin/ansible-pull -d /var/lib/ansible/local -U git://github.com/joonaleppala
hti/ansible-pull.git
 [WARNING]: Could not match supplied host pattern, ignoring: vagrant
 [WARNING]: Could not match supplied host pattern, ignoring: vagrant.vm
ERROR! Specified --limit does not match any hosts
```
Etsiessäni ratkaisua ongelmaan, päädyin vaihtamaan localhost.yml nimen local.yml, sekä loin hosts tiedoston, jossa oli vain testattava kone.

En päässyt eteenpäin ja päätin asentaa tavallisen Virtualbox-koneen, sillä Vagrant on ennenkin aiheuttanut ongelmia.

Uudella koneella sain erilaisen virheilmoituksen, edistystä!
```
/usr/bin/ansible-pull -d /var/lib/ansible/local -U git://github.com/joonaleppalahti/ansible-pull.git
127.0.0.1 | FAILED! => {
	"changed": false,
	"failed": true,
	"msg": "Failed to find required executable git"
}
localhost | FAILED! => {
	"changed": false,
	"failed": true,
	"msg": "Failed to find required executable git"
}
```
Näyttää siltä että git täytyy asentaa, lisäsin sen masterille ansible_pull.yml.

Repository kopioitui kohdekoneelle, mutta playbookin ajo pysähtyi heti apachen asennukseen. Virheilmoitus oli todella pitkä, mutta lopusta löytyi oleellisin.
```
"dpkg: warning: 'ldconfig' not found in PATH or not executable", "dpkg: warning: 'start-stop-daemon' not found in PATH or not executable", "dpkg: error: 2 expected programs not found in PATH or not executable", "Note: root's PATH should usually contain /usr/local/sbin, /usr/sbin and /sbin"
```
Manuaalisesti ajettuna `sudo ansible-pull -d /etc/ansible/local -U git://github.com/joonaleppalahti/ansible-pull.git` toimi ja apache ja muut roolin osat asentuivat.

Etsin pitkään ratkaisua ongelmaan. Tarkastin muun muassa että PATH oli kunnossa, sekä sudoers tiedosto oli kunnossa.
```
sudo -s
echo "$PATH"
```
```
less /etc/sudoers
```
Molempien polut näyttivät olevan kunnossa.

Lopulta löysin [stavros.io](https://www.stavros.io/posts/automated-large-scale-deployments-ansibles-pull-mo/) sivustolla Ansible-pullia käsittelevän artikkelin, jossa cron tiedostoon oli määritelty PATH.
```
# Cron job to git clone/pull a repo and then run locally
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

{{ schedule }} {{ cron_user }} ansible-pull -d {{ workdir }} -U {{ repo_url }} >>{{ logfile }} 2>&1
```
Tämän lisäyksen jälkeen playbook pyörähti läpi ja Apache asentui. Ansible-pull on nyt testattu onnistuneesti, mutta se tarvitsee vielä säätämistä, sillä nyt se ajaa playbookin joka kerta, vaikka muutoksia ei olisi tehty. Tämä tyyli ei myöskään sovi suoraan provisiointiin, sillä ansible_pull.yml playbook täytyy ajaa kerran manuaalisesti.

# Provisiointi

Käytin hyväkseni aikaisemmin toteuttamaani provisiointikonfiguraatiota https://joonaleppalahti.wordpress.com/2016/11/18/palvelinten-hallinta-harjoitus-8/. Ensin käynnistin kohteen ja aktivoin verkkobootin manuaalisesti, jotta sain selville kohteen MAC-osoitteen. Sitten kokeilin wake-on-lan komentoa.
```
sudo apt-get -y install wakeonlan
wakeonlan 00:21:85:01:6E:2E
```
Kone käynnistyi ja lähti tekemään verkkoboottia. 

## DHCP

Seuraavaksi asensin DHCP-palvelun masterille, joka antaa kohteelle IP-osoitteen, sekä toimintaohjeet.
```
sudo apt-get -y install isc-dhcp-server
```
Lisäsin `etc/default/isc-dhcp-server` tiedostoon INTERFACES tiedon masterin verkkokortista, jonka katsoin `ip addr` komennolla.
```
INTERFACES="enp0s3"
```
Sitten muokkasin `etc/dhcp/dhcpd.conf` tiedostoa, jonka sisällöksi tuli:
```
ddns-update-style none;

default-lease-time 600;
max-lease-time 7200;

authoritative;

log-facility local7;

next-server 10.0.0.221;
filename "pxelinux.0";

subnet 10.0.0.0 netmask 255.255.255.0 {
        host ansible {
                hardware ethernet 00:21:85:01:6e:2e;
                fixed-address 10.0.0.9;
                option subnet-mask 255.255.255.0;
                option routers 10.0.0.1;
                option domain-name-servers 8.8.8.8, 8.8.4.4;
        }
}
```
Kokeilin jälleen käynnistää kohteen taikapaketilla. Kohde sai määritetyn IP-osoitteen 10.0.0.9 ja kävi kyselemään TFTP-palvelua.

## TFTP

Asensin TFTP-palvelun, jonka jälkeen loin työskentelyhakemiston, jonne latasin Ubuntun netboot version, purin sen, poistin pakatun tiedoston ja kopioin puretut tiedostot hakemistoon `/var/lib/tftpboot/`
```
sudo apt-get -y install tftpd-hpa
mkdir netboot
cd netboot
wget http://archive.ubuntu.com/ubuntu/dists/xenial-updates/main/installer-amd64/current/images/netboot/netboot.tar.gz
tar -xvf netboot.tar.gz
rm netboot.tar.gz
sudo cp -r * /var/lib/tftpboot
```
Näytin kohteelle taikapakettia ja nyt pääsin jo Ubuntun asennusvalikkoon.

Lisäsin vielä valmistelut preseediä varten muokkaamalla `/var/lib/tftpboot/ubuntu-installer/amd64/boot-screens/syslinux.cfg` tiedostoa.
```
path ubuntu-installer/amd64/boot-screens/
include ubuntu-installer/amd64/boot-screens/menu.cfg
default ubuntu-installer/amd64/boot-screens/vesamenu.c32

label ansible
        kernel ubuntu-installer/amd64/linux
        append initrd=ubuntu-installer/amd64/initrd.gz auto=true auto url=tftp://10.0.0.221/ubuntu-installer/amd64/preseed.cfg locale=en_US.UTF-8 classes=minion DEBCONF_DEBUG=5 priority=critical preseed/url/=ubuntu-installer/amd64/preseed.cfg netcfg/choose_interface=auto

prompt 1
timeout 5
default ansible
```
Huom. append kohta täytyy olla samalla rivillä.

Tiedoston muokkauksen jälkeen asennus etenee preseedin hakemiseen asti.

## Preseed

Kohde tarvitsee asennusohjeet, jotka määritellään preseedissä. Verkkokortin valinta määritellään syslinuxissa, sillä se ei toimi preseedissä. Loin `preseed.cfg` tiedoston hakemistoon `/var/lib/tftpboot/ubuntu-installer/amd64/`
```
d-i mirror/http/proxy string http://10.0.0.221:8000/

d-i passwd/user-fullname string Joona
d-i passwd/username string joona
d-i passwd/user-password-crypted password $1$suola$x3q8bwB9K87WryJYwGJ2j.

d-i partman-auto/method string regular

d-i partman-lvm/device_remove_lvm boolean true
d-i partman-lvm/confirm boolean true
d-i partman-lvm/confirm_nooverwrite boolean true

d-i partman-auto/choose_recipe select atomic

d-i partman-partitioning/confirm_write_new_label boolean true
d-i partman/choose_partition select finish
d-i partman/confirm boolean true
d-i partman/confirm_nooverwrite boolean true

d-i pkgsel/include string ansible git ssh tftp-hpa

d-i pkgsel/update-policy select unattended-upgrades

d-i grub-installer/only_debian boolean true
d-i grub-installer/with_other_os boolean true

d-i finish-install/reboot_in_progress note
```
Asensin tässä vaiheessa `squid-deb-proxy` palvelun, joka säästää aikaa seuraavien asennuskertojen kohdalla. Lisäsin myös preseediin sille kohdan.

Ajoin asennuksen ensin ensin niin että `d-i passwd/user-password password $1$suola$x3q8bwB9K87WryJYwGJ2j.` kohdassa ei ollut crypted sanaa, jolloin password jälkeinen merkkijono oli selkokielinen salasana, cryptedin lisättyäni cryptattu salasana tulkittiin oikein ja pääsin kirjautumaan käyttäjälleni asennuksen valmistuttua.

Tämä konfiguraatio ei vielä aseta kohdetta vastaanottamaan käskyjä Ansiblella.

### Ansiblen provisiointi

Haluan että ansible hallitsee konetta automaattisesti, ilman että asentava playbook tarvitsee ajaa. Aikaisemman toteutukseni https://joonaleppalahti.wordpress.com/2016/11/22/palvelinten-hallinta-harjoitus-9/ pohjalta lisäsin preseedin loppuun late command osion:
```
d-i preseed/late_command string \
in-target tftp 10.0.0.221 -c get postinstall.sh ; \
in-target sudo /bin/bash postinstall.sh
```
Jonka sisältö on:
```
sudo tftp 10.0.0.221 -c get firstboot
sudo mv firstboot /etc/init.d/
sudo chmod +x /etc/init.d/firstboot
update-rc.d firstboot defaults
```
Postinstall scripti hakee firstboot scriptin, jonka se asettaa ajettavaksi ensimmäisen käynnistyksen yhteydessä. Tämä vaihe saattaa olla turha ja firstboot scripti voisi olla suoraan tämän tilalla, mutta testaan tämän vaihtoehdon ensin ja kokeilen suoraviivaistaa prosessia myöhemmin. Firstboot scriptin sisältö:
```
#!/bin/bash

sleep 10

cat <<EOF > /home/joona/.ssh/authorized_keys

ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDfr7ZiTa2/dj9mH3UVdOvQO7uitaqRD7U5mtQO/7yE4waw8aKuRxc5XCSafi1nr1l577mQVwefT9AKIoBFz9XbMk3f49fap0/kxoJ0iN70PIo22m3tVOGOh3roZAzcNQA/TKFI8QTORx7f7YlYPqi1wwdZwPh2TNoAoOwhVVL3Pj7SI1zCZB8FaEfJ/GFU6gIqHQG9NhZo3gFYZaSw8V7mY673HZUNXeyRqoFjvtwjVc06XB17xLOUeuLtk2iLF6hqdam8WlH1yh3K7VKA3L9MpDOquHY8uO6+kOvt+wo5XAEIh+I2sKVRu0XtGLz+tzc95kOLj9HXfr5VL8J1StQX joona@ansiblemaster

EOF

chown joona /home/joona/.ssh/authorized_keys

mkdir /etc/ansible/local

cat <<EOF > /etc/cron.d/ansible-pull

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

*/1 * * * * root ansible-pull -d /etc/ansible/local -U git://github.com/joonaleppalahti/ansible-pull.git >>/var/log/ansible-pull.log 2>&1

EOF

cat <<EOF > /etc/logrotate.d/ansible-pull

/var/log/ansible-pull.log {
  rotate 7
  daily
  compress
  missingok
  notifempty
}

EOF
```
Scripti lisää masterkoneen SSH-avaimen kohteelle, määrittää ansible-pull komennon ajettavaksi tietyin väliajoin cronin avulla (minuutin välein testausta varten) ja määrittää lokiasetuksia.

Kokeilin jälleen kohteen asennusta. SSH-avain ei mennyt paikoilleen, sillä .ssh hakemistoa ei löytynyt mihin authorized_keys tiedostoa yritettiin luoda. Lisäsin kyseisen hakemiston luonnin, sekä käyttöoikeuden korjauksen.
```
mkdir /home/joona/.ssh
chown joona /home/joona/.ssh
```

Esimerkkirepository https://github.com/joonaleppalahti/ansible-pull

Kone haki GitHubista esimerkkirepositoryn ja asensi Apachen ja muut webserver roolin asiat. Ansiblen lokeista löytyi rivi `[WARNING]: provided hosts list is empty, only localhost is available` sillä en kopioinut hosts tiedostoa masterilta. Mikäli käytössä on useita koneita, tulee hosts tiedosto olla mukana, mutta sitten kaikki koneet saavat tietoonsa toisten koneiden IP-osoitteet, sekä roolien tehtävät. 

Lisäsin ansible-pull komentoon -o parametrin, jotta Ansible ajaa playbookin vain jos repositoryyn on tullut muutoksia. Lisäksi poistin sleepin scriptin alusta.

Nyt pääsin kirjautumaan SSH-avainta käyttäen, mutta Ansible ei tehnyt mitään, vaan sanoi:
```
Repository has not changed, quitting.
```
Olisin olettanut että Ansible pyörähtää kerran, jonka jälkeen se ei tee mitään jos muutoksia ei ole tapahtunut, mutta Ansible ei pyörähtänyt kertaakaan, joten webserver roolia ei toteutettu.

Poistin -o parametrin ja muutin cronin ajon tiheyden viiteen minuuttiin.

Näyttää siltä että ensimmäisellä ansible-pull ajokerralla repository ladataan kohteelle, mutta sitä ei ajeta. Toisella ajokerralla repositoryn sitältö ajetaan ja webserver rooli asentuu. Eli jos ansible-pull komennon ajotiheys on esimerkiksi 30 minuuttia, roolin asennus tapahtuu vasta tunnin kohdalla.

Tilanteen korjaamiseksi lisäsin ansible-pull ajamisen firstboot scriptiin kaksi kertaa, jotta ensimmäisellä kerralla haetaan repositoryn sisältö ja toisella asennetaa ne. Aluksi lisäsin vain 10 sekuntia komentojen väliin, mutta ensimmäinen komento epäonnistui, joten lisäsin sen alkuun 30 sekuntin odotuksen ja nostin odotuksen ennen toista komentoa 15 sekuntiin. Lisäsin myös firstboot scriptin loppuun unohtamani osan, joka poistaa sen, ettei sitä ajeta enää seuraavilla käynnistyskerroilla. Lisäsin myös -o parametrin takaisin cronilla ajettavaan ansible-pull komentoon.
```
rm /etc/init.d/firstboot
update-rc.d firstboot remove
```
Nyt webserver rooli asentuu onnistuneesti firstboot scriptillä ja Ansible tarkastaa viiden minuutin välein onko repositoryyn tullut muutoksia. Muutin repositoryssä määritetyn käyttäjän opiskelija -> opiskelija2 ja Ansible huomasi muutoksen ja loi käyttäjän opiskelija2.

Otin `ansible.cfg` tiedostossa kommentin pois riviltä `host_key_checking = False` sillä useisiin uusiin palvelimiin samanaikaisesti otettava yhteys aiheuttaa ongelmia, kun kaikkiin pitäisi vastata erikseen yes.

Masterilta voi edelleen ajaa playbookeja, jotka hallitsevat kohdekonetta ja kohdekone tarkastelee ja hakee ohjeita GitHub repositorystä automaattisesti.

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
* https://github.com/ansible/ansible-examples/blob/master/language_features/ansible_pull.yml
* https://github.com/RaymiiOrg/Ansible-Pull-Example
* https://www.stavros.io/posts/automated-large-scale-deployments-ansibles-pull-mo
* https://joonaleppalahti.wordpress.com/2016/11/18/palvelinten-hallinta-harjoitus-8/
* https://joonaleppalahti.wordpress.com/2016/11/22/palvelinten-hallinta-harjoitus-9/
* https://stackoverflow.com/questions/32297456/how-to-ignore-ansible-ssh-authenticity-checking
* https://stackoverflow.com/questions/11948245/markdown-to-create-pages-and-table-of-contents