

## Working at the Salt mines


### 1.10.2017
#### Kaivosmiehen päiväkirja.

On kulunut lähes 5 viikkoa siitä kun Arctic CCM keskitetynhallinnan projekti alkoi ja itselleni langennut Salt hallinta ohjelman toiminnan selvitys alkoi. Nopea Googletus toi minut helpolta kuulostavalle SaltStackin ohje sivulle https://docs.saltstack.com/en/latest/topics/tutorials/walkthrough.html, joka oli hienosti otsikoitu Salt in 10 Minutes!

Ehkä kuitenkin itseltäni menisi enemmän kuin 10 minuuttia. Ensimmäiseksi asensin virtuaalikoneilleni Salt-masterin ja minionit ja ohjeita seuraamalla sain perus Master-Slave rakenteen toimimaan ja tähän ei ollutkaan mennyt kuin ensimmäiset neljä ja puoli tuntia.

Salt tuntui alkuun hyvin sekavalta moninaisine toimintoineen ja asiaa ei auttanut että YAML oli itselleni kokonaan vieras kieli. Saltilla pystyisi ilmeisesti hallitsemaan järkyttäviä määriä koneita erittäin heterogeenisessä verkossa jossa olisi useita eri käyttöjärjestelmiä ja eri  versioita niistä ja niillä eri versioita käytettävistä ohjelmista. Tai sitten vaan USB tikulta määrittää yhden koneen asetukset jolloin Salt asentaa Lite ohjelman joka määrittelee koneen ja deletoi itsensä saatuaan työnsä päätökseen.  

Lähdin aluksi etsimään ja testaamaan toimintoja joita tunsin Puppet keskitetynhallinan ohjelmasta, eli moduulin tekoa, miten sillä asennetaan ohjelmia ja hallitaan, muokataa, lisätään ja poistetaan tiedostoja, joka on usein avain kysymys Linux pohjaisten käyttöjärjestelmien hallinnassa.

Alkuun asensin onnistuneesti Xubuntu käyttöjärjestelmään ohjelman antamalla one-liner komennon Salt Masterilla joka asensi halutun ohjelman Minionille.

Eihän tämä tietenkään riittänyt vaan oli saatava moduuli tehtyä. One-liner komento oli tosin auttanut hahmottamaan Salt Targeting keinoja ja olin mielestäni alkanut ymmärtää Saltin Grain ideaa. Grain on nimitys Saltin tiedonkeräys järjestelmälle, jossa Master kerää tiedon jyväsiä Minion koneista ja pystyy käyttämään niitä ainakin targeting tietona moduuleita ja muita komentoja ajettaessa.

Alkuun moduulia tehdessäni eksyin Salt Pillariin jonka tarkoituksena ymmärtääkseni on toimia jonkinlaisena tietokantana tai varastona tiedonjyväsille (Grain) ja moduuleille. Mutta useiden tuntejen dokumentaation lueskelun ja minnekkään johtavien kokeiluiden sekä suuremmoisen tuskalliselta tuntuneen turhautumisen jälkeen päädyin käyttämään saltin default tiedosto rakennetta moduuleille joka on Ubuntu koneissa /srv/salt/ jonne luotu top.sls tiedosto kertoo millä kohteilla tai tarkemmin millä ominaisuuksilla varustetuilla minion koneilla mikäkin moduuli on tarkoitus ajaa.

Nyt on mennyt noin 5 viikkoa Hello World! :ista ja tulokset ovat olleet mielestäni sangen vähäiset, tuntuu että olen vasta raapaissut vähän pintaa mitä Saltin toiminnallisuuksiin tulee ja Xubuntu minionilla on toimiva LAMP-stack asennus MySQL root salasana preseedattuna ja testattuna sekä työpöydän taustakuva vaihdettuna. Eli se mitä osasin Puppetillakin tehdä. Seuraavaksi olen siirtymässä Windows 10 hallintaan Saltilla ja hieman pelottaa edessä oleva työmäärä ja se että osaanko keskittyä työhön tarpeeksi tulevilla viikoilla jotta marraskuun tavoitteeseen jossa meillä olisi luokka täynnä koneita provisioituna ja Saltilla hallittuna.

Kuluneen viikon osalta voin myöntää että en ole paljon jaksanut paneutua Salt projektiin vaan muut kurssit ja mukavuuden halu ovat menneet etusijalle.


### 5.10. 2017
#### Kaivosmiehen päiväkirja.

Eilen oli projektin ohjauskokous jossa todettiin projektin edenneen osaltani hyvin hitaasti viimeviikon aikana.
Tavoitteena olisi päästä provisioimaan ja siirtää projektit nykyisestä virtuaaliympäristöstä koulun labraluokkaan oikeille koneille lokakuun loppuun mennessä.

Tänään päänvaivaa aiheuttaa huonon työvireen lisäksi käyttäjätilien hallinta. Päätin laittaa Windowsin odottamaan ja tehdä Xubuntu työasemalle projektissa asetetut määritykset ensin koska ajattelin sen olevan helpompaa ja samalla testata Salt targeting keinoja, jotta selviää miten todellisuudessa ajetaan eri state moduuleja eri koneissa, tavalla jossa kaikki kohteet ja niillä ajettavat moduulit ovat määritettyinä samassa Salt top.sls tiedostossa.

### 6.10.2017
#### Kaivosmiehen päiväkirja

Eilisen yritys ajaa eri moduuleja eri koneilla saman aikaisesti epäonnistui. Tänään testi onnistui kunhan olin ensin korjannut suurimmat ongelmat top.sls tiedostossa ja muuttanut eilen luomani user.sls moduulin oikeaan muotoon. Hauska juttu sinäänsä on se että tätäkin projektia tehdessä harvoin löytyi ohjeita jotka olisivat toimineet itsellä heti suoraan, vaan lähes aina joutuu muokkaamaan ja sovittamaan koodit omaan projektiin.

Heh yritin ajaa tekemääni firewall state moduulia ja ainavain puski virheilmoitusta. Tosin ensimmäisen yrityksen jälkeen virheilmoitus muuttui ja pitkän pähkäilyn päätteeksi päädyin virheilmoituksen perusteella tarkistamaan tempaltena käyttämäni user.rules ja user6.rules tiedostot jotka osoittautuivat tyhjiksi. Ei ihme ettei palomuuri toiminut kun nämä tiedostot olivat korvanneet minioneilla olleet tiedostot tyhjillä tiedostoilla. Jotain oli siis mennyt pieleen alkuperäisiä tiedostoja siirtäessä template kansioon. No olikin jo aika ajaa tämän hetkinen paketti kokonaan uudella virtuaalikoneella.

Kiertotienä kopioin vain sisällön samannimiseen toiseen tiedostoon user.rules tiedostoista ja käytin niitä templatena ja tämähän toimi sudo ufw status näytti saltin ajon jälkeen minionilla ufw active ja kaikki halutut portit löytyivät allowed listalta.

### 7.10.2017
#### Kaivosmiehen päiväkirja

Lauantai aamu ja työmotivaatio sen mukainen. Eilinen testi näytti lupaavalta ja nyt näyttää siltä että projektin linux koneet ovat lähes valmiita seuraavaan vaiheeseen eli provisiointiin ja testaukseen labraverkossa.

Salt master versio oli itselläni käytössä eri kuin ohjeet joita noudatin, ja tästä johtuen törmäsin ongelmiin Windows pkg repositorya siirtäessäni masterilta Windows minionille. Olin luvannut että windows kone tulisi tällä työviikolla valmiiksi, joten turhautumisen estämiseksi ja ajan säästämiseksi pyysin projektityöryhmän jäsentä Joona Leppälahtea auttamaan virheviestin selvittämisessä.  Joona huomasi että käyttämässäni Ubuntun paketinhallinnasta tulevassa salt-master versiossa oli jotakin häikkää joka on korjattu uusimmassa versiossa 2017.7.1 (Nitrogen) ja seuraamani ohjekin oli itse asiassa tehty juuri tälle versiolle.

