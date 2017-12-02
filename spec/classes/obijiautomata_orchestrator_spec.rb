require 'spec_helper'
require 'rspec-puppet-utils'

on_supported_os = { 
  'RedHat' => {
    'automata_ctrldir' => '/var/tmp/obijictrl', 
    'osfamily' => 'RedHat',
    'os' => {'family' => 'RedHat'},
    'operatingsystem' => 'CentOS',
    'app_environment' => 'production',
  }, 
  'Debian' => {
    'automata_ctrldir' => '/var/tmp/obijictrl', 
    'osfamily' => 'Debian',
    'os' => {'family' => 'Debian'},
    'operatingsystem' => 'Ubuntu',
    'app_environment' => 'production',
  },
  'Windows' => {
    'automata_ctrldir' => '/var/tmp/obijictrl', 
    'osfamily' => 'Windows',
    'os' => {'family' => 'Windows'},
    'operatingsystem' => 'WinXP',
    'app_environment' => 'production',
  }
}

service_classes = {
  'RedHat' => 'linux',
  'Debian' => 'linux',
  'Windows' => 'windows',
}

describe 'obijiautomata::orchestrator' do
  #before(:each) do 
  #  MockFunction.new('hiera') { |f|
  #    #f.stubs(:call).raises(Puppet::ParseError.new('Key not found'))
  #    #f.stubs(:call).with(['obijiautomata::service::type']).returns('service')
  #    f.stubbed.with('obijiautomata::service::type').returns('service')
  #  }
  #end

  on_supported_os.each do |os, facts|
    if os == 'Windows'
      context "on #{os}" do
        let(:facts) do 
          facts 
        end
        it { is_expected.to contain_class("obijiautomata::service::#{service_classes[os]}") }
        it { is_expected.to compile.with_all_deps }
      end

    else
      context "on #{os}" do
        let(:title) { 'obijiautomata' } # sets title of the class declaration

        let(:facts) do 
          facts 
        end

        let(:params) { {
	  :servicetype => 'service' 
        } }

        it { should contain_class('obijiautomata::orchestrator') }
        it { is_expected.to contain_class("obijiautomata::service::#{service_classes[os]}") }
        it { is_expected.to contain_service("#{title}-#{facts['app_environment']}").with(:ensure => true, :enable => true) }
        it { is_expected.to contain_file("/etc/automata/bin/#{title}-#{facts['app_environment']}.sh") }
        #it { is_expected.to contain_file("/etc/systemd/system/#{title}-#{facts['app_environment']}.service") }
	#
        it do 
	  is_expected.to contain_file("/etc/systemd/system/#{title}-#{facts['app_environment']}.service").with({
	    'ensure'  => 'present',
	    'content' => %r{ExecStart}
	  })
	end

        context 'with servicetype cron' do
          let(:params) { { 
	    :servicetype => 'cron'
	  } } 

    	  it { is_expected.to contain_cron("puppet-apply-#{title}").with(:ensure => 'present') }
        end

	#it do
	#is_expected.to contain_define('obijiautomata::service::linux::gatekeeper')
	  #should contain_define('obijiautomata::service::linux::preinstall').with(:target => :servicetype)
          #should contain_define('obijiautomata::service::linux::uninstall')
	#end

        it { is_expected.to compile.with_all_deps }
      end
    end
  end
end
