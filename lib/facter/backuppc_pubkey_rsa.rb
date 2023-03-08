# frozen_string_literal: true

Facter.add('backuppc_pubkey_rsa') do
  confine osfamily: ['RedHat', 'Debian']

  setcode do
    case Facter.value(:osfamily)
    when 'RedHat'
      sshkey_path = '/var/lib/BackupPC/.ssh/id_rsa.pub'
    when 'Debian'
      sshkey_path = '/var/lib/backuppc/.ssh/id_rsa.pub'
    end

    if File.exist?(sshkey_path)
      File.read(sshkey_path).split(' ')[1]
    else
      nil
    end
  end
end
