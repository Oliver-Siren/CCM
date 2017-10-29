I startted forming  the linux_server_v1 cookbook simply by entering the command chef create cookbook to create the cookboock then added some variables to ry and prodeeded to create a node to ry the cookbook on. Tehn i ran into problems as i could not bootstrap the node as i usually do i did not want to go too far into trying to fix the but so i decided to try and reinstall chef server since it often has broblems running on vagrant. I did so but the problem presisted. I redid the bootstrap with the modifier -V -V to get more information on what is happening in the bootstrap process the erro that seems to fai lteh bootstrap is the folowing 
´´´
dpkg: error: requested operation requires superuser privilege
´´´

Which seems strange since the vagrant user is in sudoers which should be enough also i'm fairly sure i've done this bootstrap before without problems

after a brief search i found that i can run the command with the argument -- sud othat fixes the problems but the it get stuck at 

´´´
ERROR: Connection refused connecting to https://vagrant.vm/organizations/arctic/nodes/node1
´´´
I belive this is simply a problem of the network configuration. so i fixed it by adding the relevatn address to teh nodes etc/hosts file and the run completed without issue.
Next problme was trying to sun the cookbook with 

´´´
knife ssh 'name:node1-ubuntu' 'sudo chef-client' --ssh-user USER --identity-file IDENTITY_FILE --attribute ipaddress


´´´

since the vagrant instance get the wrong ipaddress with attribute

