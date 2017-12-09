# You can ignore these options usually
current_dir = File.dirname(__FILE__)
log_level                 :info
log_location              STDOUT
#
# enter your workstation hostname here
node_name                 ""
#
# this needs to point to the .pem file that contains your credidentials
client_key                "#{current_dir}/credits.pem"
#
#this should point to your server FQDN name is preferred but IP works if you modify /etc/hosts to match. Should start with https:// or else you'll get an error about not using SSL
chef_server_url           "https://"
#
# this should point to where you store your cookbooks
cookbook_path             ["#{current_dir}/../cookbooks"]
