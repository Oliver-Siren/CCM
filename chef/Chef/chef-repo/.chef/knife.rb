current_dir = File.dirname(__FILE__)
log_level                 :info
log_location              STDOUT
node_name                 "pingviinilaeppa"
client_key                "#{current_dir}/credits.pem"
chef_server_url           "https://vagrant.vm/organizations/arctic"
cookbook_path             ["#{current_dir}/../cookbooks"]
