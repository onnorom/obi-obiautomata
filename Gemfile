source 'https://rubygems.org'
 
group :test do
  gem 'puppetlabs_spec_helper', :require => false
  gem 'simplecov', require: false
  #gem 'coveralls', require: false
end

group :system_tests do
  gem 'beaker',        :require => false
  gem 'beaker-rspec',  :require => false
  gem 'beaker-puppet_install_helper', :require => false
end
 
puppetversion = ENV.key?('PUPPET_VERSION') ? "#{ENV['PUPPET_VERSION']}" : ['~> 4.0']
gem 'puppet', puppetversion
gem 'facter', '>= 1.7.0'
gem 'metadata-json-lint'
gem 'semantic_puppet'
gem 'rspec-puppet-utils', :require => false
gem 'parallel_tests', :require => false
gem 'rubocop'
gem 'pkg-config', '>= 1.1.7'
gem 'hiera-eyaml'
gem 'puppet-blacksmith'
gem 'puppet-strings'
gem 'yaml-lint'
#gem 'facter'
#gem 'puppet'
