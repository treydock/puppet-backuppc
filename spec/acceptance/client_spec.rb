require 'spec_helper_acceptance'

describe 'backuppc::client class' do
  context 'default parameters' do
    it 'runs successfully' do
      pp = <<-EOS
      class { 'backuppc::client':
        backuppc_hostname => 'localhost',
      }
      EOS

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
  end
end
