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

since the vagrant instance get the wrong ipaddress with attribute i tried to find if some of the attributes got the correct ipaddress. I trid reading the out pust of the attrivute with 
´´´
knife search node "name:node1" -F json -V -V |grep 
´´´
and giving grep diferent arguments since my console wouldnt disply the whole list of items. I did not find the appropriate attribute to use despite finding the ipaddress i wanted to target so i also added the ip to etc/hosts of both my desktop and server but it did not fix the problem. 
Rereading the knife ssh documentation i realized tah the modifier -G for gateway takes a IP address so i dont needto run the ip address to teh command with ohai but can instead simply use gateway so
´´´
knife ssh 'name:node1' 'sudo chef-client' --ssh-user vagrant --ssh-password vagrant -G 192.168.1.64 -V

´´´
works to run the cookbook i wanted to run

i ran in to further problems in using the mysql cookbook since it seems the example on setting the mysql password only configures the initial password and i was at fisrt unable to log in usgin it. Therefore to change it i needed to reinstall mysql on my vagrant instance which i figured would be easiest to do by destroying it and bootstrapping it again. This still resulted in an erro with unpermitted access on inspecting what i did previously to solve the problem i decided to reinstall chef server aswell, but having done that i still had the same problem wtih the mysql instal it seems that the mysql cookbook does not configure correctly and that it instead attains a random password which sems to be a feature if you do a hands off install of mysql otherwise.
