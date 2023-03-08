# frozen_string_literal: true

def server_supported
  if fact('os.family') == 'RedHat' && fact('os.release.major').to_s == '8'
    true
  elsif fact('os.name') == 'Debian' && fact('os.release.major').to_s == '11'
    true
  elsif fact('os.name') == 'Ubuntu' && fact('os.release.major').to_s == '22.04'
    true
  else
    false
  end
end
