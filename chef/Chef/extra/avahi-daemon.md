Avahi daemon could maybe be used to provide a way to use fqdn addresses for the configuration of Chef domain. The problem in trying this out for me was that vagrant dosen't have avahi by default and each instance of vagrant gets the same name. I'm also somewhat unsure of teh details of how avahi works as I uderstand it each machine needing a .local address needs to run the avahi-daemon.

In my network I have  two machines running avahi now pingviinilaeppa which is my working desktop and chefmagnificence which is the host for my VMs.

between these two machines trying to ping both

```
ping pnviinilaeppa.local
ping chefmagnificence.local
```
both work as you'd expect Neither of the two VMs respond to vagrant.local. Both have the same name so that might be a complication for getting avahi to work. I'll now instal avahi on my Chefserver machine ans see if it gets .local address.

As expected i got.local to work simply by instaling avahi on my chefserver ping worked to all directions next i'll try instaling avahi to my node aswell. Encouragingly it seems that vagrant.local only connects to teh server instead of there being a conflict between the two vagrant VMs. Now I'll try if I can change the connection address for the server into a .local address. 
The connection seems to work immediatly after chancgin the connection address but as usual the authentication breaks immediately once you change anything. Once I reconfigured the server with "sudo chef-server-ctl reconfigure" I kept getting an eror about teh names of teh chefserver and the conncetion method not matching and the certificate not being accepted because of this. The workaround is to chenge the file "/etc/opscode/chef-server.rb" on your chefserver to contain the fqdn name as in 
```
api_fqdn "chef.example.com"
``` 
as detailed in [https://docs.chef.io/config_rb_server.html].

After doing these changes and agian reconfiguring the server "sudo chef-server-ctl reconfigure" and now the the same certificate retrieved with "knife ssl fetch" works as the names match.
