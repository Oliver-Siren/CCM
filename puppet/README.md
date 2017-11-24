# Eri ympäristöjen site.pp tiedostot

## Linux palvelinmoduulien asennus

Lamp moduulin voi asentaa linuxiin ajamalla seuraavanlaisen site.pp tiedoston

```
class { "lampstack":}
class { "mysql::server":
            root_password => "salasanatähän",
        }
class { "tausta":}
class { "luser":}
```

## Linux työpöytäympäristön asennus

```
class { "ssh2":}
class { "linuxohjelmat":}
class { "tausta":}
class { "luser":}
```

## Windows työpöytäympäristön asennus

`sudo puppet module install puppetlabs/windows`

```
class { "choco":}
class {"wuserwall":}
```
## Tulen lisäämään näihin node kohtaiset tiedot provisiontivaiheessa

