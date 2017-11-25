In trying to run lamp_role i got the following progress listing
```
 knife ssh 192.168.1.62 'sudo chef-client' --ssh-user vagrant --ssh-password vagrant --manual-list
192.168.1.62 sudo: unable to resolve host vagrant
192.168.1.62 Starting Chef Client, version 13.4.24
192.168.1.62 resolving cookbooks for run list: ["chef-client::default", "chef-client::delete_validation", "learn_chef_apache2::default", "lamp_role::default"]
192.168.1.62 Synchronizing Cookbooks:
192.168.1.62   - cron (4.1.3)
192.168.1.62   - logrotate (2.2.0)
192.168.1.62   - chef-client (8.1.8)
192.168.1.62   - ohai (5.2.0)
192.168.1.62   - mysql_role (0.1.0)
192.168.1.62   - windows (3.1.3)
192.168.1.62   - openssl (7.1.0)
192.168.1.62   - compat_resource (12.19.0)
192.168.1.62   - lamp_role (0.2.0)
192.168.1.62   - mysql (3.0.2)
192.168.1.62   - seven_zip (2.0.2)
192.168.1.62   - learn_chef_apache2 (0.3.1)
192.168.1.62   - mingw (2.0.1)
192.168.1.62   - build-essential (8.0.3)
192.168.1.62   - xfs (2.0.1)
192.168.1.62   - database (1.3.12)
192.168.1.62   - postgresql (6.1.1)
192.168.1.62   - aws (7.2.1)
192.168.1.62   - mysql-chef_gem (1.0.0)
192.168.1.62   - apt (6.1.4)
192.168.1.62   - xml (3.1.2)
192.168.1.62   - apache2 (5.0.1)
192.168.1.62   - php (1.5.0)
192.168.1.62   - yum-epel (2.1.2)
192.168.1.62   - iis (6.7.3)
192.168.1.62   - ssl (1.1.1)
192.168.1.62 Installing Cookbook Gems:
192.168.1.62 Compiling Cookbooks...
192.168.1.62 
192.168.1.62 ================================================================================
192.168.1.62 Recipe Compile Error in /var/chef/cache/cookbooks/mysql/attributes/server.rb
192.168.1.62 ================================================================================
192.168.1.62 
192.168.1.62 NoMethodError
192.168.1.62 -------------
192.168.1.62 undefined method `cloud' for #<Chef::Node::Attribute:0x000000000498a978>
192.168.1.62 
192.168.1.62 Cookbook Trace:
192.168.1.62 ---------------
192.168.1.62   /var/chef/cache/cookbooks/mysql/attributes/server.rb:20:in `from_file'
192.168.1.62 
192.168.1.62 Relevant File Content:
192.168.1.62 ----------------------
192.168.1.62 /var/chef/cache/cookbooks/mysql/attributes/server.rb:
192.168.1.62 
192.168.1.62  13:  # Unless required by applicable law or agreed to in writing, software
192.168.1.62  14:  # distributed under the License is distributed on an "AS IS" BASIS,
192.168.1.62  15:  # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
192.168.1.62  16:  # See the License for the specific language governing permissions and
192.168.1.62  17:  # limitations under the License.
192.168.1.62  18:  #
192.168.1.62  19:  
192.168.1.62  20>> default['mysql']['bind_address']               = attribute?('cloud') ? cloud['local_ipv4'] : ipaddress
192.168.1.62  21:  default['mysql']['port']                       = 3306
192.168.1.62  22:  default['mysql']['nice']                       = 0
192.168.1.62  23:  
192.168.1.62  24:  case node["platform_family"]
192.168.1.62  25:  when "debian"
192.168.1.62  26:    default['mysql']['server']['packages']      = %w{mysql-server}
192.168.1.62  27:    default['mysql']['service_name']            = "mysql"
192.168.1.62  28:    default['mysql']['basedir']                 = "/usr"
192.168.1.62  29:    default['mysql']['data_dir']                = "/var/lib/mysql"
192.168.1.62 
192.168.1.62 System Info:
192.168.1.62 ------------
192.168.1.62 chef_version=13.4.24
192.168.1.62 platform=ubuntu
192.168.1.62 platform_version=16.04
192.168.1.62 ruby=ruby 2.4.2p198 (2017-09-14 revision 59899) [x86_64-linux]
192.168.1.62 program_name=chef-client worker: ppid=12880;start=16:14:59;
192.168.1.62 executable=/opt/chef/bin/chef-client
192.168.1.62 
192.168.1.62 
192.168.1.62 Running handlers:
192.168.1.62 [2017-09-29T16:15:11+00:00] ERROR: Running exception handlers
192.168.1.62 Running handlers complete
192.168.1.62 [2017-09-29T16:15:11+00:00] ERROR: Exception handlers complete
192.168.1.62 Chef Client failed. 0 resources updated in 11 seconds
192.168.1.62 [2017-09-29T16:15:11+00:00] FATAL: Stacktrace dumped to /var/chef/cache/chef-stacktrace.out
192.168.1.62 [2017-09-29T16:15:11+00:00] FATAL: Please provide the contents of the stacktrace.out file if you file a bug report
192.168.1.62 [2017-09-29T16:15:11+00:00] ERROR: undefined method `cloud' for #<Chef::Node::Attribute:0x000000000498a978>
192.168.1.62 [2017-09-29T16:15:11+00:00] FATAL: Chef::Exceptions::ChildConvergeError: Chef run process exited unsuccessfully (exit code 1)
```
I dont really know what the problem is but I have a few hunches from reading the result.

1.there is a missing configuration that should be used 
2.the execution fails beacause it's a virtual environment and some critical bit is missing
3.the hackjob for using chef without FQDN names makes it fail

in any case I'm unwilling to troubleshoot this extensively since making a simple LAMP module isnt very challenging so doubt I have a real need for this.
