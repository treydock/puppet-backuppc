# frozen_string_literal: true

require 'spec_helper'

describe 'backuppc::client' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end
      let(:params) { { backuppc_hostname: 'backuppc.example.com' } }

      it { is_expected.to compile.with_all_deps }
    end
  end
end
