current_dir = File.dirname(__FILE__)
log_level                 :info
log_location              STDOUT
node_name                 "chefadmin"
client_key                "/etc/chef/chefadmin.pem"
chef_server_url           "https://192.168.1.37/organizations/4thcoffee"
cookbook_path             ["#{current_dir}/../cookbooks"]
