#!pyobjects

Pkg.installed("mysql-client")

pw="silli" # use pillars in production

Pkg.installed("debconf-utils")
with Debconf.set("mysqlroot", data=
 {
 'mysql-server/root_password':{'type':'password', 'value':pw},
 'mysql-server/root_password_again': {'type':'password', 'value': pw}
 }):
 Pkg.installed("mysql-server")
 Pkg.installed("php-mysql")

