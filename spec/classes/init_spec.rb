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

describe 'obijiautomata' do
  ['Debian','RedHat','Windows'].each do |x| 
    let(:facts) do 
      on_supported_os[x] 
    end
  end
  it { should contain_class('obijiautomata') }
  it { should contain_class('obijiautomata::orchestrator') }
end
