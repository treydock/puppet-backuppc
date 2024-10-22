# @summary Manage BackupPC client
#
# @param backuppc_hostname
#   The BackupPC hostname
#   This is used to match which BackupPC server is authorized for backups
# @param ensure
#   Whether to add or remove BackupPC client resources
# @param config_name
#   Name of BackupPC client config
# @param manage_system_account
#   Manage the user account used to perform backups
# @param system_account
#   Account used to perform backups
# @param system_account_home_directory
#   The home directory of backup user
# @param system_account_uid
#   Backup user UID
# @param system_account_gid
#   Backup user and group GID
# @param system_additional_commands
#   Authorize commands for backup user via sudo
# @param system_additional_commands_noexec
#   Authorize commands for backup user via sudo with NOEXEC
# @param manage_sudo
#   Include sudo class
# @param manage_rsync
#   Manage rsync package
# @param rsync_path
#   rsync path
# @param tar_path
#   tar path
# @param client_name_alias
#   See config.pl ClientNameAlias
# @param xfer_method
#   See config.pl XferMethod
# @param xfer_loglevel
#   See config.pl XferLogLevel
# @param backups_disable
#   See config.pl BackupsDisable
# @param full_period
#   See config.pl FullPeriod
# @param incr_period
#   See config.pl IncrPeriod
# @param full_keep_cnt
#   See config.pl FullKeepCnt
# @param full_keep_cnt_min
#   See config.pl FullKeepCntMin
# @param full_age_max
#   See config.pl FullAgeMax
# @param incr_keep_cnt
#   See config.pl IncrKeepCnt
# @param incr_keep_cnt_min
#   See config.pl IncrKeepCntMin
# @param incr_age_max
#   See config.pl IncrAgeMax
# @param blackout_bad_ping_limit
#   See config.pl BlackoutBadPingLimit
# @param ping_max_msec
#   See config.pl PingMaxMsec
# @param blackout_good_cnt
#   See config.pl BlackoutGoodCnt
# @param backup_files_only
#   See config.pl BackupFilesOnly
# @param backup_files_exclude
#   See config.pl BackupFilesExclude
# @param smb_share_name
#   See config.pl SmbShareName
# @param smb_share_username
#   See config.pl SmbShareUserName
# @param smb_share_passwd
#   See config.pl SmbSharePasswd
# @param smb_client_full_cmd
#   See config.pl SmbClientFullCmd
# @param smb_client_incr_cmd
#   See config.pl SmbClientIncrCmd
# @param smb_client_restore_cmd
#   See config.pl SmbClientRestoreCmd
# @param tar_share_name
#   See config.pl TarShareName
# @param tar_client_cmd
#   See config.pl TarClientCmd
# @param tar_full_args
#   See config.pl TarFullArgs
# @param tar_incr_args
#   See config.pl TarIncrArgs
# @param tar_client_restore_cmd
#   See config.pl TarClientRestoreCmd
# @param rsync_client_path
#   See config.pl RsyncClientPath
# @param rsync_ssh_args
#   See config.pl RsyncSshArgs
# @param rsync_args
#   See config.pl RsyncArgs
# @param rsync_args_extra
#   See config.pl RsyncArgsExtra
# @param rsync_restore_args
#   See config.pl RsyncRestoreArgs
# @param rsync_restore_args_extra
#   See config.pl RsyncRestoreArgsExtra
# @param rsync_share_name
#   See config.pl RsyncShareName
# @param rsyncd_client_port
#   See config.pl RsyncdClientPort
# @param rsyncd_user_name
#   See config.pl RsyncdUserName
# @param rsyncd_passwd
#   See config.pl RsyncdPasswd
# @param dump_pre_user_cmd
#   See config.pl DumpPreUserCmd
# @param dump_post_user_cmd
#   See config.pl DumpPostUserCmd
# @param dump_pre_share_cmd
#   See config.pl DumpPreShareCmd
# @param dump_post_share_cmd
#   See config.pl DumpPostShareCmd
# @param restore_pre_user_cmd
#   See config.pl RestorePreUserCmd
# @param restore_post_user_cmd
#   See config.pl RestorePostUserCmd
# @param user_cmd_check_status
#   See config.pl UserCmdCheckStatus
# @param email_notify_min_days
#   See config.pl EMailNotifyMinDays
# @param email_from_user_name
#   See config.pl EMailFromUserName
# @param email_admin_user_name
#   See config.pl EMailAdminUserName
# @param email_notify_old_backup_days
#   See config.pl EMailNotifyOldBackupDays
# @param hosts_file_dhcp
#   Whether to use enable DHCP in hosts file
# @param hosts_file_user
#   Hosts file user
# @param hosts_file_more_users
#   Hosts file more users
# @param export_sshkey
#   Set whether to export the SSH key for the backup client to BackupPC server
#
class backuppc::client (
  Stdlib::Host $backuppc_hostname,
  Enum['present','absent'] $ensure = 'present',
  String $config_name = $facts['networking']['fqdn'],
  Boolean $manage_system_account = true,
  String $system_account = 'backup',
  Stdlib::Absolutepath $system_account_home_directory = '/var/backups',
  Optional[Integer] $system_account_uid = undef,
  Optional[Integer] $system_account_gid = undef,
  Array $system_additional_commands = [],
  Array $system_additional_commands_noexec = [],
  Boolean $manage_sudo = false,
  Boolean $manage_rsync = true,
  Stdlib::Absolutepath $rsync_path = '/usr/bin/rsync',
  Stdlib::Absolutepath $tar_path = '/bin/gtar',
  Optional[String] $client_name_alias = undef,
  String $xfer_method = 'rsync',
  Integer $xfer_loglevel = 1,
  Optional[Boolean] $backups_disable = undef,
  Optional[Variant[Integer, Float]] $full_period = undef,
  Optional[Variant[Integer, Float]] $incr_period = undef,
  Optional[Variant[Array[Integer], Integer]] $full_keep_cnt = undef,
  Optional[Integer] $full_keep_cnt_min = undef,
  Optional[Integer] $full_age_max = undef,
  Optional[Integer] $incr_keep_cnt = undef,
  Optional[Integer] $incr_keep_cnt_min = undef,
  Optional[Integer] $incr_age_max = undef,
  Optional[Integer] $blackout_bad_ping_limit = undef,
  Optional[Integer] $ping_max_msec = undef,
  Optional[Integer] $blackout_good_cnt = undef,
  Optional[Variant[Hash,Array,String]] $backup_files_only = undef,
  Optional[Variant[Hash,Array,String]] $backup_files_exclude  = undef,
  Optional[String] $smb_share_name = undef,
  Optional[String] $smb_share_username    = undef,
  Optional[String] $smb_share_passwd      = undef,
  Optional[String] $smb_client_full_cmd   = undef,
  Optional[String] $smb_client_incr_cmd   = undef,
  Optional[String] $smb_client_restore_cmd = undef,
  Optional[Variant[Array, String]] $tar_share_name = undef,
  Optional[String] $tar_client_cmd = undef,
  Optional[String] $tar_full_args = undef,
  Optional[String] $tar_incr_args = undef,
  Optional[String] $tar_client_restore_cmd = undef,
  Optional[String] $rsync_client_path = undef,
  Optional[Array] $rsync_ssh_args = undef,
  Optional[Array] $rsync_args = undef,
  Optional[Array] $rsync_args_extra = undef,
  Optional[Array] $rsync_restore_args = undef,
  Optional[Array] $rsync_restore_args_extra = undef,
  Optional[Variant[Array, String]] $rsync_share_name = undef,
  Optional[Integer] $rsyncd_client_port = undef,
  Optional[String] $rsyncd_user_name = undef,
  Optional[String] $rsyncd_passwd = undef,
  Optional[String] $dump_pre_user_cmd = undef,
  Optional[String] $dump_post_user_cmd = undef,
  Optional[String] $dump_pre_share_cmd = undef,
  Optional[String] $dump_post_share_cmd = undef,
  Optional[String] $restore_pre_user_cmd = undef,
  Optional[String] $restore_post_user_cmd = undef,
  Optional[Boolean] $user_cmd_check_status = undef,
  Optional[Variant[Integer, Float]] $email_notify_min_days = undef,
  Optional[String] $email_from_user_name  = undef,
  Optional[String] $email_admin_user_name = undef,
  Optional[Integer] $email_notify_old_backup_days = undef,
  Boolean $hosts_file_dhcp = false,
  String $hosts_file_user = 'backuppc',
  Array $hosts_file_more_users = [],
  Boolean $export_sshkey = true,
) {
  case $ensure {
    'absent': {
      $file_ensure = 'absent'
      $directory_ensure = 'absent'
    }
    default: {
      $file_ensure = 'file'
      $directory_ensure = 'directory'
    }
  }

  if $xfer_method in ['rsync', 'tar'] {
    if $xfer_method == 'rsync' {
      if $manage_rsync and $ensure == 'present' {
        stdlib::ensure_packages(['rsync'])
      }
      $sudo_command_noexec = $rsync_path
    }
    else {
      $sudo_command_noexec = $tar_path
    }

    if $manage_sudo and $ensure == 'present' {
      include sudo
    }

    if ! empty($system_additional_commands) {
      $sudo_commands = join($system_additional_commands, ', ')
    } else {
      $sudo_commands = ''
    }

    if ! empty($system_additional_commands_noexec) {
      $additional_sudo_commands_noexec = join($system_additional_commands_noexec, ', ')
      $sudo_commands_noexec = "${sudo_command_noexec}, ${additional_sudo_commands_noexec}"
    } else {
      $sudo_commands_noexec = $sudo_command_noexec
    }

    if ! empty($sudo_commands) {
      $sudo_ensure = $ensure
    } else {
      $sudo_ensure = 'absent'
    }

    sudo::conf { 'backuppc':
      ensure  => $sudo_ensure,
      content => [
        "Defaults:${system_account} !requiretty",
        "${system_account} ALL=(ALL:ALL) NOPASSWD: ${sudo_commands}",
      ],
    }

    sudo::conf { 'backuppc_noexec':
      ensure  => $ensure,
      content => [
        "Defaults:${system_account} !requiretty",
        "${system_account} ALL=(ALL:ALL) NOEXEC:NOPASSWD: ${sudo_commands_noexec}",
      ],
    }

    if $manage_system_account {
      if $ensure == 'present' {
        $user_before = undef
      } else {
        $user_before = Group[$system_account]
      }

      user { $system_account:
        ensure         => $ensure,
        home           => $system_account_home_directory,
        managehome     => true,
        shell          => '/bin/bash',
        comment        => 'BackupPC',
        system         => true,
        uid            => $system_account_uid,
        gid            => $system_account,
        forcelocal     => true,
        purge_ssh_keys => true,
        before         => $user_before,
      }

      group { $system_account:
        ensure     => $ensure,
        system     => true,
        gid        => $system_account_gid,
        forcelocal => true,
      }
    }

    file { $system_account_home_directory:
      ensure => $directory_ensure,
      owner  => $system_account,
      group  => $system_account,
    }

    file { "${system_account_home_directory}/.ssh":
      ensure  => $directory_ensure,
      mode    => '0700',
      owner   => $system_account,
      group   => $system_account,
      seltype => 'ssh_home_t',
    }

    file { "${system_account_home_directory}/.ssh/authorized_keys":
      ensure  => $file_ensure,
      mode    => '0600',
      owner   => $system_account,
      group   => $system_account,
      seltype => 'ssh_home_t',
    }

    file { "${system_account_home_directory}/backuppc.sh":
      ensure  => $file_ensure,
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      content => template('backuppc/client/backuppc.sh.erb'),
    }

    Ssh_authorized_key <<| tag == "backuppc_${backuppc_hostname}" |>> {
      ensure  => $ensure,
      user    => $system_account,
      options => [
        "command=\"${system_account_home_directory}/backuppc.sh\"",
        'no-agent-forwarding',
        'no-port-forwarding',
        'no-pty',
        'no-X11-forwarding',
      ],
      require => File["${system_account_home_directory}/.ssh"]
    }
  }

  if $export_sshkey and $facts['networking']['fqdn'] != $backuppc_hostname {
    @@sshkey { $facts['networking']['fqdn']:
      ensure => $ensure,
      type   => 'ssh-rsa',
      key    => $facts['ssh']['rsa']['key'],
      tag    => "backuppc_sshkeys_${backuppc_hostname}",
    }
  }

  if $ensure == 'present' {
    @@augeas { "backuppc_host_${config_name}-create":
      context => '/files/etc/BackupPC/hosts',
      changes => template("${module_name}/host-augeas-create.erb"),
      lens    => 'BackupPCHosts.lns',
      incl    => '/etc/BackupPC/hosts',
      onlyif  => "match *[host = '${config_name}'] size == 0",
      before  => Augeas["backuppc_host_${config_name}-update"],
      tag     => "backuppc_hosts_${backuppc_hostname}",
    }
    @@augeas { "backuppc_host_${config_name}-update":
      context => '/files/etc/BackupPC/hosts',
      changes => template("${module_name}/host-augeas-update.erb"),
      lens    => 'BackupPCHosts.lns',
      incl    => '/etc/BackupPC/hosts',
      onlyif  => "match *[host = '${config_name}'] size > 0",
      tag     => "backuppc_hosts_${backuppc_hostname}",
    }
  }

  @@file { "/etc/BackupPC/pc/${config_name}.pl":
    ensure  => $file_ensure,
    content => template("${module_name}/host.pl.erb"),
    owner   => 'backuppc',
    mode    => '0640',
    tag     => "backuppc_config_${backuppc_hostname}",
  }
}
