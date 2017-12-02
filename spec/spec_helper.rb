require 'puppetlabs_spec_helper/module_spec_helper'
require 'simplecov'
#require 'rspec-puppet/spec_helper'
#require 'hiera'
#require 'coveralls'

SimpleCov.formatters = [
  SimpleCov::Formatter::HTMLFormatter,
  #Coveralls::SimpleCov::Formatter
]

SimpleCov.start do
  add_filter '/spec/'
  # Exclude bundled Gems in `/vendor/`
  add_filter '/vendor/'
end
 
fixture_path = File.expand_path(File.join(__FILE__, '..', '..', 'spec/fixtures'))

RSpec.configure do |c|
  c.color  = true
  c.formatter = :documentation
  c.default_facts = {
    :osfamily => 'RedHat',
    :operatingsystemmajrelease => '7',
  }
  #c.module_path = File.join(fixture_path, 'modules') + ':' + File.join(fixture_path, 'modules/stdlib')
  c.module_path = File.join(fixture_path, 'modules')
end

if ENV['DEBUG']
  Puppet::Util::Log.level = :debug
  Puppet::Util::Log.newdestination(:console)
end
