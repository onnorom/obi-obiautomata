require 'spec_helper_acceptance'

describe 'obijiautomata class' do

  context 'Default Deployment' do

    it 'should work with no errors based on the example' do
      pp = <<-EOS
        file { '/var/tmp/obijictrl':
          ensure  => 'directory',
        } ->
	file { '/var/tmp/obijictrl/update.sh':
          ensure  => 'file',
	  content => "#!/bin/env bash \necho 'hello'\n",
	  mode    => '0755',
	  require => File['/var/tmp/obijictrl'],
        } ->
        class { 'obijiautomata': }
      EOS

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end
  end
end

