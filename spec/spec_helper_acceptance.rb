require 'beaker-rspec'
require 'beaker/puppet_install_helper'

# Not needed for this example as our docker files have puppet installed already
#hosts.each do |host|
  #Install Puppet #  install_puppet
  run_puppet_install_helper
#end

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module and dependencies (if module is available in puppet repo)
    # Use 'copy_module_to' instead otherwise. There is an example below
    # puppet_module_install(:source => proj_root, :module_name => 'obijiautomata')
	  
    hosts.each do |host|
      scp_to(host, '/home/ubuntu/cert.pem', '/opt/puppetlabs/puppet/ssl/cert.pem')

      create_remote_file(host, '/etc/yum.conf', "[main]\ncachedir=/var/cache/yum/\$basearch/\$releasever\nkeepcache=0\ndebuglevel=2\nlogfile=/var/log/yum.log\nexactarch=1\nobsoletes=1\ngpgcheck=1\nplugins=1\ninstallonly_limit=3")
      create_remote_file(host, '/etc/yum.repos.d/puppetlab-pc1.repo', "[puppetlabs-pc1]\nname=Puppet Labs PC1 Repository el 7 -\$basearch\nbaseurl=#{ENV['BEAKER_YUM_BASEURL']}\nenabled=1\ngpgcheck=0\nproxy=_none_")
      create_remote_file(host, "/etc/puppetlabs/puppet/puppet.conf", "[main]\nmodule_repository=#{ENV['BEAKER_FORGE_HOST']}")
      create_remote_file(host, '/etc/.host.control.dir', "/var/tmp/obijictrl\n")
      #create_remote_file(host, '/opt/puppetlabs/facter/facts.d/app.yaml', "---\nautomata_ctrldir: '/tmp/obijictrl'\n")

      # Install the module itself
      copy_module_to(host, :source => proj_root, :module_name => 'obijiautomata')
      scp_to(host, 'spec/acceptance/hiera.yaml', '/etc/puppetlabs/puppet/hiera.yaml')

      #on host, puppet('module', 'install', 'puppetlabs-stdlib'), { :acceptable_exit_codes => [0,1] }
      #on host, puppet('module', 'install', '--ignore-dependencies', 'puppetlabs-stdlib', '--version=4.13.1'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'puppetlabs-stdlib', '--version=4.13.1')
      on host, puppet('module', 'install', '--ignore-dependencies', 'puppet/archive', '--version=1.1.2')
      on host, puppet('module', 'install', '--ignore-dependencies', 'puppetlabs/apt', '--version=2.1.0')
      on host, puppet('module', 'install', '--ignore-dependencies', 'puppetlabs/concat', '--version=3.0.0')
    end
  end
end
