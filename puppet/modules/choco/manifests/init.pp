class choco {
    include chocolatey

    Package {
        ensure => "installed",
        provider => "chocolatey",
    }

    package {["winscp.install", "notepadplusplus.install", "putty.install", "libreoffice"
    ]:}
}
