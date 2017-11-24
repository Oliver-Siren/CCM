node "palvelinorja.zyxel.setup" {
    class { "lampstack":}
    class { "mysql::server":
            root_password => "salasanatähän",
          }
    class { "tausta":}
    class { "luser":}
}
node "userorja.zyxel.setup" {
    class { "ssh2":}
    class { "linuxohjelmat":}
    class { "tausta":}
    class { "luser":}
}
node "provorja2.zyxel.setup" {
    class { "choco":}
    class {"wuserwall":}
}
