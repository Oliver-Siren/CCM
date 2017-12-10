current_dir = File.dirname(__FILE__)
log_level                 :info
log_location              STDOUT
#you can generally ignore these options
#
node_name                 "pingviinilaeppa"
#this should be the same as your workstations hostname
#
client_key                "#{current_dir}/credits.pem"
#this should point to the key you generated on your server
#
chef_server_url           "https://vagrant.local/organizations/arctic"
#this must start with https:// or you'll get an erro taht the connection is not using SSL you can also enter an IP address despite this
#
cookbook_path             ["#{current_dir}/../cookbooks"]
#this should point to your cookbooks
#
