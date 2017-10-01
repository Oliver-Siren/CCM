

## Working at the Salt mines

Kaivosmiehen päiväkirja.
1.10.2017

On kulunut lähes 5 viikkoa siitä kun Arctic CCM keskitetynhallinnan projekti alkoi ja itselleni langennut Salt hallinta ohjelman toiminnan selvitys alkoi. Nopea Googletus toi minut helpolta kuulostavalle SaltStackin ohje sivulle https://docs.saltstack.com/en/latest/topics/tutorials/walkthrough.html, joka oli hienosti otsikoitu Salt in 10 Minutes!

Ehkä kuitenkin itseltäni menisi enemmän kuin 10 minuuttia. Ensimmäiseksi asensin virtuaalikoneilleni Salt-masterin ja minionit ja ohjeita seuraamalla sain perus Master-Slave rakenteen toimimaan ja tähän ei ollutkaan mennyt kuin ensimmäiset neljä ja puoli tuntia.

Salt tuntui alkuun hyvin sekavalta moninaisine toimintoineen ja asiaa ei auttanut että YAML oli itselleni kokonaan vieras kieli. Saltilla pystyisi ilmeisesti hallitsemaan järkyttäviä määriä koneita erittäin heterogeenisessä verkossa jossa olisi useita eri käyttöjärjestelmiä ja eri  versioita niistä ja niillä eri versioita käytettävistä ohjelmista. Tai sitten vaan USB tikulta määrittää yhden koneen asetukset jolloin Salt asentaa Lite ohjelman joka määrittelee koneen ja deletoi itsensä saatuaan työnsä päätökseen.  

Lähdin aluksi etsimään ja testaamaan toimintoja joita tunsin Puppet keskitetynhallinan ohjelmasta, eli moduulin tekoa, miten sillä asennetaan ohjelmia ja hallitaan, muokataa, lisätään ja poistetaan tiedostoja, joka on usein avain kysymys Linux pohjaisten käyttöjärjestelmien hallinnassa.

Alkuun asensin onnistuneesti Xubuntu käyttöjärjestelmään ohjelman antamalla one-liner komennon Salt Masterilla joka asensi halutun ohjelman Minionille.

Eihän tämä tietenkään riittänyt vaan oli saatava moduuli tehtyä. One-liner komento oli tosin auttanut hahmottamaan Salt Targeting keinoja ja olin mielestäni alkanut ymmärtää Saltin Grain ideaa. Grain on nimitys Saltin tiedonkeräys järjestelmälle, jossa Master kerää tiedon jyväsiä Minion koneista ja pystyy käyttämään niitä ainakin targeting tietona moduuleita ja muita komentoja ajettaessa.

Alkuun moduulia tehdessäni eksyin Salt Pillariin jonka tarkoituksena ymmärtääkseni on toimia jonkinlaisena tietokantana tai varastona tiedonjyväsille (Grain) ja moduuleille. Mutta useiden tuntejen dokumentaation lueskelun ja minnekkään johtavien kokeiluiden sekä suuremmoisen tuskalliselta tuntuneen turhautumisen jälkeen päädyin käyttämään saltin default tiedosto rakennetta moduuleille joka on Ubuntu koneissa /srv/salt/ jonne luotu top.sls tiedosto kertoo millä kohteilla tai tarkemmin millä ominaisuuksilla varustetuilla minion koneilla mikäkin moduuli on tarkoitus ajaa.

Nyt on mennyt noin 5 viikkoa Hello World! :ista ja tulokset ovat olleet mielestäni sangen vähäiset, tuntuu että olen vasta raapaissut vähän pintaa mitä Saltin toiminnallisuuksiin tulee ja Xubuntu minionilla on toimiva LAMP-stack asennus MySQL root salasana preseedattuna ja testattuna sekä työpöydän taustakuva vaihdettuna. Eli se mitä osasin Puppetillakin tehdä. Seuraavaksi olen siirtymässä Windows 10 hallintaan Saltilla ja hieman pelottaa edessä oleva työmäärä ja se että osaanko keskittyä työhön tarpeeksi tulevilla viikoilla jotta marraskuun tavoitteeseen jossa meillä olisi luokka täynnä koneita provisioituna ja Saltilla hallittuna.

Kuluneen viikon osalta voin myöntää että en ole paljon jaksanut paneutua Salt projektiin vaan muut kurssit ja mukavuuden halu ovat menneet etusijalle.