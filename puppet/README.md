# LAMP moduulin asennus linuxiin

Lamp moduulin voi asentaa linuxiin ajamalla seuraavanlaisen site.pp tiedoston

```
class { "lampstack":}
class { "mysql::server":
            root_password => "salasanatähän",
        }
class { "tausta":}
```
