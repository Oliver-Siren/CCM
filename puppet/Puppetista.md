# Pohjatietoa Puppetista

## Olemassa 2 versiota:

Puppet Open Source (ilmainen)

Puppet Enterprise (Puppet + GUI, API ja työkaluja Node hallintaa varten (maksullinen)

## Tuetut käyttöjärjestelmät

```
Puppet Master:

Red Hat Enterprise Linux	6, 7	                        x86_64
CentOS	                        6, 7	                        x86_64
Oracle Linux	                6, 7	                        x86_64
Scientific Linux	        6, 7	                        x86_64
SUSE Linux Enterprise Server	11 (SP1/SP2), 12 (SP1, SP2)	x86_64
Ubuntu	                        14.04, 16.04	                x86_64

Agent:

Red Hat Enterprise Linux        5, 6, 7	                                        x86_64 i386 for 5, 6 IBM z System for 6, 7 (contact Sales) ppc64le for 7
CentOS                          5, 6, 7                                         x86_64 i386 for 5, 6
Oracle Linux	                5, 6, 7	                                        x86_64 i386 for 5, 6
Scientific Linux	        5, 6, 7	                                        x86_64 i386 for 5, 6
SUSE Linux Enterprise Server	11 (SP1/SP2), 12 (SP1/SP2)	                x86_64 i386 for 10, 11 IBM z System for 11, 12 (contact Sales)
Solaris	                        10 (update 9 or later), 11	                SPARC i386
Ubuntu	                        14.04, 16.04, 16.10	                        x86_64 i386 ppc64le for 16.04
Fedora	                        24, 25	                                        x86_64 i386
Debian	                        Wheezy (7), Jessie (8), Stretch (9)	        x86_64 i386
Microsoft Windows (Server OS)	2008, 2008R2, 2012, 2012R2, 2012R2 core, 2016	x86_64 i386
Microsoft Windows (Consumer OS)	Vista, 7, 8.1, 10	                        x86_64 i386
Mac OS X	                10.10, 10.11, 10.12	                        x86_64
AIX	                        6.1, 7.1, 7.2	                                Power
Amazon Linux	                2017.03 (using packages for RHEL 6)	
```
## Tietoja

Erityisen hyvä serverin hallinnassa.
Puppetin avulla voi pystyttää palvelimen ja jatkuvasti tarkistaa  sekä ylläpitää palvelinta niin, että konfiguraatio pysyy sellaisena kuin se on puppetissa määritelty.
Oma kieli: Puppet kieli on helppokäyttöinen myös niille jotka eivät osaa ohjelmointikieliä.
Perustuu herra-orja arkkitehtuuriin (moduuleita voi ajaa myös samalla koneella).

## Hakemistorakenne

Hakemisto: /etc/puppet/
```
-conf.conf
-etckeeper-commit-post
-etckeeper-commit-pre
-files
-fileserver.conf
-manifests 
        ^-site.pp
-modules
        ^-moduuli
                ^-manifests
                        ^-init.pp
                ^-files
-puppet.conf
-autosign.conf
```
## Moduulit

Moduulit sisältävät luokkia, joita kutsutaan site.pp tiedostossa

![alt text](https://raw.githubusercontent.com/joonaleppalahti/CCM/master/puppet/kuvat/15.png "15")

## Site.pp

Sijainti: puppet/manifests/

Määrittelee mitä moduuleita kohdekoneelle asennetaan.
Täällä voidaan määritellä myös node tieto eli mitä millekkin hostille tulee, ja lisäksi voi antaa lisämäärityksiä moodulien asennukseen.

Perustuu herra-orja arkkitehtuuriin (moduuleita voi ajaa myös samalla koneella)

## Sertifikaateista

Turvallisinta hyväksyä manuaalisesti. Autokonfiguraatio onnistuu autoconfig.conf avulla jonne listataan verkko-osoitteita tai hostname. Autosign whitelistin (autosign.conf Puppet repossa) avulla on Puppetissa oletusarvoisesti päällä. Sertifikaattien rikkoutuminen voi aiheuttaa paljon päänvaivaa.

## Lähteet:
https://puppet.com
https://puppet.com/docs/pe/2017.3/installing/supported_operating_systems.html
