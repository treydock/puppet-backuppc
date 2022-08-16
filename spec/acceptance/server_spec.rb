require 'spec_helper_acceptance'

describe 'backuppc::server class', if: server_supported do
  before(:each) do
    skip("Does not support server") unless server_supported
  end

  context 'default parameters' do
    it 'runs successfully' do
      pp = <<-EOS
      include backuppc::server
      EOS

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe package('BackupPC'), if: fact('os.family') == 'RedHat' do
      it { is_expected.to be_installed }
    end

    describe package('backuppc'), if: fact('os.family') == 'Debian' do
      it { is_expected.to be_installed }
    end

    describe service('backuppc') do
      it { is_expected.to be_running }
    end

    # Dump config diff as sanity check
    it 'dumps config difference' do
      on hosts, "diff -wu <( grep -Ev '^#' /etc/BackupPC/config.pl.sample | grep -Ev '^$' ) /etc/BackupPC/config.pl",
        acceptable_exit_codes: [0,1]
    end
  end
end
