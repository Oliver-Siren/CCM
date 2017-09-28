I had trouble connectic to my server as instructed in the tutorial at [https://learn.chef.io/modules/manage-a-node-chef-server/ubuntu/bring-your-own-system/set-up-your-chef-server#/]. Here is arecor of the things i did to resolve the issue.

System setup

I had a small net that had three computers in it 

PC -LAN- router -Wlan- work laptom
	-LAN-
  PC for virtualmachines

I all the three computers are in a NATted network with a single external IP. the problem i got when trying to follow the tutorial was that after moving the private ke to my laptop i got the following erro when trying to connect to my vagrant instance ERROR: The SSL cert is signed by a trusted authority but is not valid for the given hostname
ERROR: You are attempting to connect to:   '192.168.1.62'
ERROR: The server's certificate belongs to 'vagrant.vm'

now the obvious solution would be to connect with the hostname but that gives me another error

ERROR: Network Error: getaddrinfo: Name or service not known
Check your knife configuration and network settings

This is quite obviously because name resolution isnt happening in the network. I can ping th einstance from all other computers but cant ping with the hostname.

the solution is given in the error text for the first case

TO FIX THIS ERROR:

The solution for this issue depends on your networking configuration. If you
are able to connect to this server using the hostname vagrant.vm
instead of 192.168.1.62, then you can resolve this issue by updating chef_server_url
in your configuration file.

If you are not able to connect to the server using the hostname vagrant.vm
you will have to update the certificate on the server to use the correct hostname.

by googling for

chef If you are not able to connect to the server using the hostname you will have to update the certificate on the server to use the correct hostname.

i found [https://stackoverflow.com/questions/27721000/using-chef-12-chef-client-unable-to-connect-to-chef-server] where its suggested to use guide on [http://jtimberman.housepub.org/blog/2014/12/11/chef-12-fix-untrusted-self-sign-certs/] but this basically amounts to using the "knife ssl fetch" which is uded in the tutorial already and [https://docs.chef.io/knife_ssl_check.html] which gives me the command i tried already plus

 " knife ssl check -server-url
/opt/chefdk/embedded/lib/ruby/gems/2.4.0/gems/chef-config-13.2.20/lib/chef-config/config.rb:128:in `block in <class:Config>': erver-url is an invalid chef_server_url. (ChefConfig::ConfigurationError)
	from /opt/chefdk/embedded/lib/ruby/gems/2.4.0/gems/mixlib-config-2.2.4/lib/mixlib/config/configurable.rb:61:in `set'
	from /opt/chefdk/embedded/lib/ruby/gems/2.4.0/gems/mixlib-config-2.2.4/lib/mixlib/config.rb:418:in `internal_set'
	from /opt/chefdk/embedded/lib/ruby/gems/2.4.0/gems/mixlib-config-2.2.4/lib/mixlib/config.rb:89:in `[]='
	from /opt/chefdk/embedded/lib/ruby/gems/2.4.0/gems/chef-13.2.20/lib/chef/knife.rb:380:in `apply_computed_config'
	from /opt/chefdk/embedded/lib/ruby/gems/2.4.0/gems/chef-13.2.20/lib/chef/knife.rb:415:in `configure_chef'
	from /opt/chefdk/embedded/lib/ruby/gems/2.4.0/gems/chef-13.2.20/lib/chef/knife.rb:218:in `run'
	from /opt/chefdk/embedded/lib/ruby/gems/2.4.0/gems/chef-13.2.20/lib/chef/application/knife.rb:156:in `run'
	from /opt/chefdk/embedded/lib/ruby/gems/2.4.0/gems/chef-13.2.20/bin/knife:25:in `<top (required)>'
	from /usr/bin/knife:263:in `load'
	from /usr/bin/knife:263:in `<main>'
"
with knife ssl check -server-url which is not very helpful

another suggestion is to

On Chef Server:

    I have changed my hostname from chefserver.dsh.com to https://IPAddress
    $sudo chef-server-ctl reconfigure

On Chef WorkStation:

    Edit the knife.rb on workstation @chef_server_url to https://IPAddress:443/organizations/name
    $sudo knife ssl fetch


but this fails since i cant seem to change the hostname of my vagrant instance simply with "sudo hostname https://192.168.1.62 && sudo service avahi-daemon restart" as i would usually do since the vagrant box I'm using dosent seem to even have avahi-daemon(bento/ubuntu-16.04) editing etc/hosts by hand is doable but dosent seem to affect anything either. 

sudo hostname https://192.168.1.62 && service avahi-daemon restart
hostname: the specified hostname is invalid
vagrant@vagrant:/etc$ sudo service avahi-daemon restart
Failed to restart avahi-daemon.service: Unit avahi-daemon.service not found.

so i decide to abandon vagrant for now and try a full install of xubuntu as i usually do

now to run the same set of commands on the xubuntu virtualbox 

sudo hostname https://192.168.1.37 && service avahi-daemon restart
hostname: the specified hostname is invalid

not really surprinsing then i edited the IP into /etc/hosts and restarted avahi

slave@slave:/etc$ service avahi-daemon restart
==== AUTHENTICATING FOR org.freedesktop.systemd1.manage-units ===
Authentication is required to restart 'avahi-daemon.service'.
Authenticating as: slave,,, (slave)
Password: 
==== AUTHENTICATION COMPLETE ===

now to redo the certs i tried 

sudo chef-server-ctl reconfigure 

and then again 

knife ssl check

i got 

Connecting to host 192.168.1.37:443
ERROR: The SSL certificate of 192.168.1.37 could not be verified
Certificate issuer data: /C=US/O=YouCorp/OU=Operations/CN=192.168.1.37

Configuration Info:

OpenSSL Configuration:
* Version: OpenSSL 1.0.2l  25 May 2017
* Certificate file: /opt/chefdk/embedded/ssl/cert.pem
* Certificate directory: /opt/chefdk/embedded/ssl/certs
Chef SSL Configuration:
* ssl_ca_path: nil
* ssl_ca_file: nil
* trusted_certs_dir: "/home/jarkko/Chef/CCM/chef/Chef/chef-repo/.chef/trusted_certs"

TO FIX THIS ERROR:

If the server you are connecting to uses a self-signed certificate, you must
configure chef to trust that server's certificate.

By default, the certificate is stored in the following location on the host
where your chef-server runs:

  /var/opt/opscode/nginx/ca/SERVER_HOSTNAME.crt

Copy that file to your trusted_certs_dir (currently: /home/jarkko/Chef/CCM/chef/Chef/chef-repo/.chef/trusted_certs)
using SSH/SCP or some other secure method, then re-run this command to confirm
that the server's certificate is now trusted.

and after doin knife ssl fetch and then knife ssl check i got 

Connecting to host 192.168.1.37:443
Successfully verified certificates from `192.168.1.37'

success?!
