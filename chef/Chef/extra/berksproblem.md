in trying to install mysql module i ran into a problem with dependencies management with berksfile as i understand teh instructions at [https://docs.chef.io/berkshelf.html] the dependencies are simply declared in the berksfile at teh root of your cookbook and that should be enough to sun the berksfile on your repository root despite doing so i get the following error 

´´´
Required artifacts do not exist at the desired version
Missing artifacts: linux_server
Unable to find a solution for demands: linux_server (>= 0.0.0)

´´´
so far simple google search did not get the answer for me i tried canging the depens attribute on the files but kept getting the same message o
so i then chenged the source attibute for my repo berksfile to 

´´´
source chef_repo: "/cookbooks/"
´´´

but that did not seem to do the trick either althoug h i did get a different erro message

´´´
/opt/chefdk/embedded/lib/ruby/gems/2.4.0/gems/berkshelf-6.3.1/lib/berkshelf/chef_repo_universe.rb:16:in `open': No such file or directory @ dir_initialize - /cookbooks (Errno::ENOENT)
	from /opt/chefdk/embedded/lib/ruby/gems/2.4.0/gems/berkshelf-6.3.1/lib/berkshelf/chef_repo_universe.rb:16:in `entries'
	from /opt/chefdk/embedded/lib/ruby/gems/2.4.0/gems/berkshelf-6.3.1/lib/berkshelf/chef_repo_universe.rb:16:in `universe'
	from /opt/chefdk/embedded/lib/ruby/gems/2.4.0/gems/berkshelf-6.3.1/lib/berkshelf/source.rb:85:in `build_universe'
	from /opt/chefdk/embedded/lib/ruby/gems/2.4.0/gems/berkshelf-6.3.1/lib/berkshelf/installer.rb:24:in `block (2 levels) in build_universe'

´´´
on googling the error i get no hit at all so i did a search for more generic berks dependecies and got an amazon guide [https://aws.amazon.com/blogs/devops/how-to-package-cookbook-dependencies-locally-with-berkshelf/] as i read the guide i figured i should first try manipulating berks in the cookbook root and only then try for the berks in my repository on giving the command berks install with the following berksfile

´´´
# frozen_string_literal: true
source 'https://supermarket.chef.io'
metadata

cookbook 'mysql'

´´´
and the following metadata

´´´
name 'linux_server'
maintainer 'The Authors'
maintainer_email 'you@example.com'
license 'MIT'
description 'Installs/Configures linux_server'
long_description 'Installs/Configures linux_server'
version '0.1.0'
chef_version '>= 12.1' if respond_to?(:chef_version)

depends 'mysql','~> 8.0'

´´´
berks recognized the mysql with the message

´´´
Resolving cookbook dependencies...
Fetching 'linux_server' from source at .
Using linux_server (0.1.0) from source at .
Using mysql (8.5.1)

´´´
despite this the instal commad still fails at the repository root. with the same error as previously. When i remove teh repo source the fisrt error message returns.

no trying to figure out if i made any erroes in making the file i again looked at [https://docs.chef.io/berkshelf.html] and modified my Berksfile to

´´´
source 'https://supermarket.chef.io'
source chef_repo: "../chef-repo/cookbooks"

cookbook 'linux_server'
cookbook 'mysql'

´´´
 which then seems to resolve as intenden with 'berks install' reurning 

´´´
Resolving cookbook dependencies...
Fetching cookbook index from https://supermarket.chef.io...
Fetching cookbook index from /home/jarkko/chef/CCM/chef/Chef/chef-repo/cookbooks...
Installing linux_server (0.1.0) from /home/jarkko/chef/CCM/chef/Chef/chef-repo/cookbooks/linux_server
Using mysql (8.5.1)

´´´
 
