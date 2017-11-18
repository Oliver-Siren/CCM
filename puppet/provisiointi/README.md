# Linux provisiointi testaus omilla tietokoneilla
Aloitin Palvelinympäristön valmistelun Xubuntu 16.04.3 LTS Puppetmaster viertuaalikoneessani.

Olin Kokeillut verkkoboottia jo Tero Karvisen kurssilla, mutta käytin ohjeena Joona Leppälahden tekemiä kattavia artikkeleita aiheesta: 
https://joonaleppalahti.wordpress.com/2016/12/11/pupxegrant-puppet-pxe-ja-vagrant-konfiguraatio/ https://joonaleppalahti.wordpress.com/2016/11/18/palvelinten-hallinta-harjoitus-8/
https://joonaleppalahti.wordpress.com/2016/11/18/palvelinten-hallinta-harjoitus-9/

Mietin aluksi ryhmän jäsenen kanssa sitä, miten haluamme hyväksyä sertifikaatit. Päädyimme ratkaisuun, jossa hyväksymme autosign.conf tiedoston whitelistissa olevien osoitteiden sertifikaatit automaattisesti. Mikäli Haluaa noudattaa tiukempaa turvallisuuslinjaa, niin sertifikaatit pitää silloin hyväksyä masterilla käsin.

Autosign.conffin sisältö:

```
provorja.zyxel.setup
*.zyxel.setup
*.local
provorja
```

Tämän jälkeen asensin koneelle sellaisia ohjelmia, joita tulisin tarvitsemaan provisionnissa. (Puppetmaster oli jo koneella asennettuna).

sudo apt-get install -y wakeonlan

sudo apt-get install -y isc-dhcp-server

sudo apt-get install -y tftpd-hpa

sudo apt-get install -y squid-deb-proxy

Tarkistin aluksi kohdekoneen mac osoitteen. Sitten yritin käynnistää kohdekoneen wakeonlan ohjelman avulla. Annoin komennon:

`wakeonlan "44:8a:5b:c1:44:9b"`

Ja kone käynnistyi. 

Seuraavaksi lisäsin masterin verkkokortin sijaintiin /etc/default/isc-dhcp-server

`INTERFACES="enp0s3"`

Sitten muokkasin dhcpd.conf tiedostoa sijainnissa: /etc/dhcp/dhcpd.conf

Sinne tuli seuraavat komennot:
```
ddns-update-style none;

default-lease-time 600;
max-lease-time 7200;

authoritative;

log-facility local7;

next-server 192.168.1.48;
filename "pxelinux.0";

subnet 192.168.1.0 netmask 255.255.255.0 {
        host provorja {
                hardware ethernet 44:8a:5b:c1:44:9b;
                fixed-address 192.168.1.44;
                option subnet-mask 255.255.255.0;
                option routers 192.168.1.1;
                option domain-name-servers 8.8.8.8, 8.8.4.4;
                option host-name "provorja";
        }
}



```

Käynnistin dhcp-palvelun uudelleen dhcpd.conf tiedoston muokkauksen jälkeen komennolla "sudo service isc-dhcp-server restart"

Tämän jälkeen latasin Ubuntun netboot version täältä: http://archive.ubuntu.com/ubuntu/dists/xenial-updates/main/installer-amd64/current/images/netboot/ 

Siirsin tar.gz tiedoston sijaintiin /var/lib/tftpboot, jossa purin sen komennolla: 

`tar -xvf netboot.tar.gz`

Sitten muokkasin syslinux.cfg tiedostoa sijainnissa /var/lib/tftpboot/ubuntu-installer/amd64/boot-screens/syslinux.cfg

```
# D-I config version 2.0
# search path for the c32 support libraries (libcom32, libutil etc.)
path ubuntu-installer/amd64/boot-screens/
include ubuntu-installer/amd64/boot-screens/menu.cfg
default ubuntu-installer/amd64/boot-screens/vesamenu.c32

label master2 
        kernel ubuntu-installer/amd64/linux
        append initrd=ubuntu-installer/amd64/initrd.gz auto=true auto url=tftp://192.168.1.48/ubuntu-installer/amd64/preseed.cfg locale=en_US.UTF-8 classes=minion DEBCONF_DEBUG=5 priority=critical preseed/url/=ubuntu-installer/amd64/prese$

prompt 1
timeout 5
default master2 
 
```
Sitten loin sijaintiin /var/lib/tftpboot/ubuntu-installer/amd64/ preseed.cfg tiedoston, jonne tuli seuraavaa:

```
d-i mirror/http/proxy string http://192.168.1.48:8000/

d-i passwd/user-fullname string opiskelija
d-i passwd/username string opiskelija
d-i passwd/user-password password salainen
d-i passwd/user-password-again password salainen

d-i partman-auto/method string regular

d-i partman-lvm/device_remove_lvm boolean true
d-i partman-lvm/confirm boolean true
d-i partman-lvm/confirm_nooverwrite boolean true

d-i partman-auto/choose_recipe select atomic

d-i partman-partitioning/confirm_write_new_label boolean true
d-i partman/choose_partition select finish
d-i partman/confirm boolean true
d-i partman/confirm_nooverwrite boolean true

d-i pkgsel/include string puppet ssh tftp-hpa avahi-daemon xubuntu-desktop

d-i pkgsel/update-policy select none

d-i grub-installer/only_debian boolean true
d-i grub-installer/with_other_os boolean true

d-i finish-install/reboot_in_progress note

d-i preseed/late_command string \
in-target tftp 192.168.1.48 -c get postinstall.sh ; \
in-target /bin/bash postinstall.sh
```

Yritin käynnistää koneen mutta TFTP yhteys ei mennyt läpi masteriin.

Sain Virheilmoituksen: 

`PXE-E32: TFTP open timeout`

Tajusin että masterissa oli palomuuri päällä, ja kun suljin sen, niin TFTP yhteys toimi.

Asennus onnistui, ja tarkistin että ohjelmat olivat myös asentuneet. Huomasin että sisällyttämäni xubuntu-desktop pidensi asennusaikaa huomattavasti, joten jatkossa testaisin ilman sitä.

Seuraavaksi rupesin testaamaan firsboot skriptiä. Päätin toimia hieman eri tavalla kuin Joona, ja ajaa firstbootin suoraan preseed tiedoston lopusta.

Tein muutoksia preseedin loppuun:
(Hylkäsin tämän tavan, ja palasin edelliseen.)
```
d-i mirror/http/proxy string http://192.168.1.48:8000/

d-i passwd/user-fullname string opiskelija
d-i passwd/username string opiskelija
d-i passwd/user-password password salainen
d-i passwd/user-password-again password salainen

d-i partman-auto/method string regular

d-i partman-lvm/device_remove_lvm boolean true
d-i partman-lvm/confirm boolean true
d-i partman-lvm/confirm_nooverwrite boolean true

d-i partman-auto/choose_recipe select atomic

d-i partman-partitioning/confirm_write_new_label boolean true
d-i partman/choose_partition select finish
d-i partman/confirm boolean true
d-i partman/confirm_nooverwrite boolean true

d-i pkgsel/include string puppet ssh tftp-hpa avahi-daemon

d-i pkgsel/update-policy select none

d-i grub-installer/only_debian boolean true
d-i grub-installer/with_other_os boolean true

d-i finish-install/reboot_in_progress note

d-i preseed/late_command string \
in-target tftp 192.168.1.48 -c get /var/lib/tftpboot/firstboot ; \
in-target sudo mv firstboot /etc/init.d/ ; \
in-target sudo chmod +x /etc/init.d/firstboot ; \
in-target update-rc.d firstboot defaults
```

 postinstall.sh
```
#!/bin/bash

sleep 10

service puppet stop

hostnamectl set-hostname provorja

cat <<EOF > /etc/hosts

127.0.0.1       localhost
127.0.1.1       ubuntu provorja
192.168.1.48    master2.zyxel.setup

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters

EOF

service avahi-daemon restart

cat <<EOF > /etc/puppet/puppet.conf

[main]
logdir=/var/log/puppet
vardir=/var/lib/puppet
ssldir=/var/lib/puppet/ssl
rundir=/run/puppet
factpath=$vardir/lib/facter
prerun_command=/etc/puppet/etckeeper-commit-pre
postrun_command=/etc/puppet/etckeeper-commit-post

[master]
ssl_client_header = SSL_CLIENT_S_DN
ssl_client_verify_header = SSL_CLIENT_VERIFY

[agent]
server = master2.zyxel.setup

EOF

rm -r /var/lib/puppet/ssl
puppet agent --enable
service puppet restart

```

Päätin kokeilla aluksi tätä. Kun asennus valmistui kävin tutkimassa oliko firstboot scriptiä ajettu, mutta näin ei ollut. Jatkan ensiviikolla tämän tutkimista.

Sain postinstall.sh toimimaan muuten paitsi puppet yhteyden osalta. Kun ajoin testin, kertoi puppet että sertifikaattia ei ollut hyväksytty. Huomasin tämän jälkeen että sertifikaatti oli saapunut koneelle, mutta väärän nimisenä. Tämän vuoksi autosign.conf ei toiminut. Tämä johtui siitä, että koneen hostname ei muuttunut, vaikka postinstall.sh skriptissä oli niin määrätty. Päätin lisätä hostnamen vaihtokohdan dhcpd.conffiin ja kokeilla uudestaan. Tällä kertaa hostname muuttui, ja puppet ajo onnistui.

# HUOM!
Päädyin käyttämään ylempää postinstall skriptiä sillä alempaa en saanut toimimaan. Tässä kansiossa olevat skriptittiedostot ovat muokattuja versioita näistä aiemmista kotona testaamistani skripteistä. Jos käytät skriptejä niin huomioi se, että joudut muokkaamaan osaa niistä ympäristöön sopivaksi.
