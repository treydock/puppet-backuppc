require 'spec_helper'

describe 'backuppc::client', :type => :class do

  describe 'On an unknown operating system' do
    let(:facts) {{ :osfamily => 'Unknown' }}
    it { should raise_error(Puppet::Error, /is not supported by this module/) }
  end

  context "On Ubuntu" do
    let(:facts) {{ :osfamily => 'Debian' }}
    let(:params) {{ :backuppc_hostname => 'backuppc.test.com' }}
    it { should include_class("backuppc::params") }
  end

  context "On RedHat" do
    let(:facts) {{ :osfamily => 'RedHat' }}
    let(:params) {{ :backuppc_hostname => 'backuppc.test.com' }}
    it { should include_class("backuppc::params") }
  end
end
