# frozen_string_literal: true

require 'spec_helper'

describe 'backuppc::server' do
  on_supported_os({
                    supported_os: [
                      {
                        'operatingsystem' => 'RedHat',
                        'operatingsystemrelease' => ['8']
                      },
                      {
                        'operatingsystem' => 'Debian',
                        'operatingsystemrelease' => ['11']
                      },
                      {
                        'operatingsystem' => 'Ubuntu',
                        'operatingsystemrelease' => ['22.04']
                      }
                    ]
                  }).each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      it { is_expected.to compile.with_all_deps }
    end
  end

  on_supported_os({
                    supported_os: [
                      {
                        'operatingsystem' => 'RedHat',
                        'operatingsystemrelease' => ['7']
                      }
                    ]
                  }).each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      it { is_expected.not_to compile }
    end
  end
end
