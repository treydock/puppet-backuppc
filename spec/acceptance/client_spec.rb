# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'backuppc::client class' do
  context 'with default parameters' do
    it 'runs successfully' do
      pp = <<-PP
      class { 'backuppc::client':
        backuppc_hostname => 'localhost',
      }
      PP

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
  end
end
