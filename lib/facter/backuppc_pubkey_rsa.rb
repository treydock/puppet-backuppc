Facter.add('backuppc_pubkey_rsa') do
  confine :osfamily => ['RedHat', 'Debian']

  setcode do
    case Facter.value(:osfamily)
    when 'RedHat'
      sshkey_path = '/var/lib/BackupPC/.ssh/id_rsa.pub'
    when 'Debian'
      sshkey_path = '/var/lib/backuppc/.ssh/id_rsa.pub'
    end
    
    if File.exists?(sshkey_path)
      File.open(sshkey_path).read.split(' ')[1]
    end
  end
end
