class ssh2 {
        package { "ssh":
                ensure => "installed",
                allowcdrom => "true",
        }
        exec { "sudo ufw enable":
                path => "/bin/:/usr/bin/:/sbin/:/usr/sbin/",
                unless => 'sudo ufw status verbose|grep "Status: active"',
        }
        exec { "sudo ufw allow 22/tcp":
                path => "/bin/:/usr/bin/:/sbin/:/usr/sbin/",
                unless => "ufw status verbose|grep 22/tcp",
        }
        exec { "sudo ufw allow 8140/tcp":
                path => "/bin/:/usr/bin/:/sbin/:/usr/sbin/",
                unless => "ufw status verbose|grep 8140/tcp",
        }
        service { "ssh":
                ensure => "running",
                enable => "true",
                provider => "systemd",
        }
}
