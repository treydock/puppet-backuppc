# @summary Manage BackPC server
#
# @param package_name
#   Package name
# @param manage_repo
#   Manage repo
#   Only applies to EL systems to manage EPEL
# @param service_name
#   Service name
# @param config_dir
#   Config directory
# @param replace_config
#   Set if replace BackupPC config.pl
# @param manage_topdir
#   Manage BackupPC topdir
# @param topdir
#   Path to topdir
# @param install_dir
#   BackupPC install directory
# @param log_dir
#   Log directory
# @param run_dir
#   Run dir
# @param df_path
#   Path to df
# @param cat_path
#   Path to cat
# @param par_path
#   Path to par2
# @param gzip_path
#   Path to gzip
# @param bzip2_path
#   Path to bzip2
# @param rsync_path
#   Path to rsync
# @param tar_path
#   Path to tar
# @param rsync_bpc_path
#   Path to rsync_bpc
# @param ping_path
#   Path to ping
# @param ping6_path
#   Path to ping6
# @param cgi_dir
#   CGI directory
# @param cgi_image_dir
#   CGI image directory
# @param cgi_image_dir_url
#   CGI image directory URL
# @param apache_group
#   Apache group
# @param server_host
#   config.pl ServerHost
# @param wakeup_schedule
#   config.pl WakeupSchedule
# @param pool_v3_enabled
#   config.pl PoolV3Enabled
# @param max_backups
#   config.pl MaxBackups
# @param max_user_backups
#   config.pl MaxUserBackups
# @param max_pending_cmds
#   config.pl MaxPendingCmds
# @param max_backup_pc_nightly_jobs
#   config.pl MaxBackupPCNightlyJobs
# @param backup_pc_nightly_period
#   config.pl BackupPCNightlyPeriod
# @param pool_size_nightly_update_period
#   config.pl PoolSizeNightlyUpdatePeriod
# @param pool_nightly_digest_check_percent
#   config.pl PoolNightlyDigestCheckPercent
# @param ref_cnt_fsck
#   config.pl RefCntFsck
# @param max_old_log_files
#   config.pl MaxOldLogFiles
# @param df_max_usage_pct
#   config.pl DfMaxUsagePct
# @param df_max_inode_usage_pct
#   config.pl DfMaxInodeUsagePct
# @param dhcp_address_ranges
#   config.pl DHCPAddressRanges
# @param full_period
#   config.pl FullPeriod
# @param incr_period
#   config.pl IncrPeriod
# @param fill_cycle
#   config.pl FillCycle
# @param full_keep_cnt
#   config.pl FullKeepCnt
# @param full_age_max
#   config.pl FullAgeMax
# @param incr_keep_cnt
#   config.pl IncrKeepCnt
# @param incr_age_max
#   config.pl IncrAgeMax
# @param restore_info_keep_cnt
#   config.pl RestoreInfoKeepCnt
# @param archive_info_keep_cnt
#   config.pl ArchiveInfoKeepCnt
# @param blackout_good_cnt
#   config.pl BlackoutGoodCnt
# @param blackout_periods
#   config.pl BlackoutPeriods
# @param blackout_zero_files_is_fatal
#   config.pl BackupZeroFilesIsFatal
# @param rsync_cmd_default_user
#   Default user for rsync backups
# @param rsync_client_path
#   config.pl RsyncClientPath
# @param rsync_args
#   config.pl RsyncArgs
# @param rsync_args_extra
#   config.pl RsyncArgsExtra
# @param rsync_full_args_extra
#   config.pl RsyncFullArgsExtra
# @param rsync_incr_args_extra
#   config.pl RsyncIncrArgsExtra
# @param rsync_restore_args
#   config.pl RsyncRestoreArgs
# @param rsync_restore_args_extra
#   config.pl RsyncRestoreArgsExtra
# @param compress_level
#   config.pl CompressLevel
# @param email_notify_min_days
#   config.pl EMailNotifyMinDays
# @param email_from_user_name
#   config.pl EMailFromUserName
# @param email_admin_user_name
#   config.pl EMailAdminUserName
# @param email_user_dest_domain
#   config.pl EMailUserDestDomain
# @param email_notify_old_backup_days
#   config.pl EMailNotifyOldBackupDays
# @param email_headers
#   config.pl EMailHeaders
# @param cgi_admin_user_group
#   config.pl CgiAdminUserGroup
# @param cgi_admin_users
#   config.pl CgiAdminUsers
# @param cgi_url
#   config.pl CgiURL
# @param manage_user
#   Manage BackupPC user and group
# @param user_uid
#   BackupPC UID
# @param user_shell
#   BackupPC user shell
# @param user_gid
#   BackupPC user and group GID
#
class backuppc::server (
  String $package_name = 'BackupPC',
  Boolean $manage_repo = true,
  String $service_name = 'backuppc',
  Stdlib::Absolutepath $config_dir = '/etc/BackupPC',
  Boolean $replace_config = true,
  Boolean $manage_topdir = true,
  Stdlib::Absolutepath $topdir = '/var/lib/BackupPC',
  Stdlib::Absolutepath $install_dir = '/usr/share/BackupPC',
  Stdlib::Absolutepath $log_dir = '/var/log/BackupPC',
  Stdlib::Absolutepath $run_dir = '/var/run/BackupPC',
  Stdlib::Absolutepath $df_path = '/usr/bin/df',
  Stdlib::Absolutepath $cat_path = '/usr/bin/cat',
  Stdlib::Absolutepath $par_path = '/usr/bin/par2',
  Stdlib::Absolutepath $gzip_path = '/usr/bin/gzip',
  Stdlib::Absolutepath $bzip2_path = '/usr/bin/bzip2',
  Stdlib::Absolutepath $rsync_path = '/usr/bin/rsync',
  Stdlib::Absolutepath $tar_path = '/bin/gtar',
  Stdlib::Absolutepath $rsync_bpc_path = '/usr/bin/rsync_bpc',
  Stdlib::Absolutepath $ping_path = '/usr/bin/ping',
  Stdlib::Absolutepath $ping6_path = '/usr/sbin/ping6',
  Stdlib::Absolutepath $cgi_dir = '/usr/libexec/BackupPC',
  Stdlib::Absolutepath $cgi_image_dir = '/usr/share/BackupPC/html',
  Stdlib::Absolutepath $cgi_image_dir_url  = '/BackupPC/images',
  String $apache_group = 'apache',
  Stdlib::Fqdn $server_host = $facts['networking']['fqdn'],
  Array[Integer] $wakeup_schedule = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23],
  Boolean $pool_v3_enabled = false,
  Integer $max_backups = 4,
  Integer $max_user_backups = 4,
  Integer $max_pending_cmds = 15,
  Integer $max_backup_pc_nightly_jobs = 2,
  Integer $backup_pc_nightly_period = 1,
  Integer $pool_size_nightly_update_period = 16,
  Integer $pool_nightly_digest_check_percent = 1,
  Integer $ref_cnt_fsck = 1,
  Integer $max_old_log_files = 14,
  Integer $df_max_usage_pct = 95,
  Integer $df_max_inode_usage_pct = 95,
  Array[Backuppc::DHCPAddressRange] $dhcp_address_ranges = [],
  Variant[Integer, Float] $full_period = 6.97,
  Variant[Integer, Float] $incr_period = 0.97,
  Integer $fill_cycle = 0,
  Variant[Array[Integer], Integer] $full_keep_cnt = [1],
  Integer $full_age_max = 180,
  Integer $incr_keep_cnt = 6,
  Integer $incr_age_max = 30,
  Integer $restore_info_keep_cnt = 10,
  Integer $archive_info_keep_cnt = 10,
  Integer $blackout_good_cnt = 7,
  Array[Backuppc::BlackoutPeriod] $blackout_periods = [
    { hour_begin =>  7.0,
      hour_end   => 19.5,
      week_days  => [1, 2, 3, 4, 5],
    }
  ],
  Boolean $blackout_zero_files_is_fatal = true,
  String $rsync_cmd_default_user = 'root',
  String $rsync_client_path = '/usr/bin/rsync',
  Array $rsync_args = [],
  Array $rsync_args_extra = [],
  Array $rsync_full_args_extra = ['--checksum'],
  Array $rsync_incr_args_extra = [],
  Array $rsync_restore_args = [],
  Array $rsync_restore_args_extra = [],
  Integer[1,9] $compress_level = 3,
  Variant[Integer, Float] $email_notify_min_days = 2.5,
  String $email_from_user_name = 'backuppc',
  String $email_admin_user_name = 'backuppc',
  Optional[String] $email_user_dest_domain = undef,
  Variant[Integer, Float] $email_notify_old_backup_days = 7.0,
  Hash $email_headers = {
    'MIME-Version' => 1.0,
    'Content-Type' => 'text/plain; charset="utf-8"',
  },
  Variant[Array[String], String] $cgi_admin_user_group = [],
  Variant[Array[String], String] $cgi_admin_users = [],
  Variant[Stdlib::HTTPUrl, Stdlib::HTTPSUrl ] $cgi_url = "http://${facts['networking']['fqdn']}/backuppc",
  Boolean $manage_user = true,
  Optional[Integer] $user_uid = undef,
  Stdlib::Absolutepath $user_shell = '/sbin/nologin',
  Optional[Integer] $user_gid = undef,
) {

  $os_family = $facts['os']['family']
  $os_major = $facts['os']['release']['major']
  $os = "${os_family}-${os_major}"
  $supported = ['RedHat-8', 'Debian-11', 'Debian-22.04']
  if ! ($os in $supported) {
    fail("Unsupported OS family-major ${os}, only support ${supported.join(',')}")
  }
  $config = "${config_dir}/config.pl"

  if $manage_repo {
    if $os_family == 'RedHat' {
      include epel
      Class['epel'] -> Package[$package_name]
    }
  }

  if $manage_user {
    user { 'backuppc':
      ensure     => 'present',
      home       => $topdir,
      managehome => false,
      shell      => $user_shell,
      comment    => 'BackupPC User',
      system     => true,
      uid        => $user_uid,
      gid        => 'backuppc',
      forcelocal => true,
      before     => [
        Package[$package_name],
        Exec['backuppc-ssh-keygen'],
      ],
    }

    group { 'backuppc':
      ensure     => 'present',
      system     => true,
      gid        => $user_gid,
      forcelocal => true,
      before     => Package[$package_name],
    }
  }

  package { $package_name:
    ensure => 'installed',
    before => File[$config],
  }

  file { $config_dir:
    ensure  => 'directory',
    owner   => 'backuppc',
    group   => $apache_group,
    mode    => '0750',
    require => Package[$package_name],
  }

  file { $config:
    ensure  => 'file',
    owner   => 'backuppc',
    group   => $apache_group,
    mode    => '0640',
    content => template('backuppc/config.pl.erb'),
    replace => $replace_config,
    require => Package[$package_name],
    before  => Service[$service_name],
    notify  => Exec['backuppc reload'],
  }

  if ! $replace_config {
    file { "${config}.puppet":
      ensure  => 'file',
      owner   => 'backuppc',
      group   => $apache_group,
      mode    => '0640',
      content => template('backuppc/config.pl.erb'),
    }
  }

  file { "${config_dir}/pc":
    ensure => 'directory',
    owner  => 'backuppc',
    group  => $apache_group,
    mode   => '0750',
  }

  file { "${config_dir}/hosts":
    ensure  => 'file',
    owner   => 'backuppc',
    group   => $apache_group,
    mode    => '0640',
    require => Package[$package_name],
  }

  service { $service_name:
    ensure => 'running',
    enable => true,
  }

  exec { 'backuppc reload':
    command     => "systemctl reload-or-restart ${service_name}",
    path        => '/usr/bin:/bin:/usr/sbin:/sbin',
    refreshonly => true,
  }

  if $manage_topdir {
    file { $topdir:
      ensure => 'directory',
      owner  => 'backuppc',
      group  => 'root',
      mode   => '0750',
    }
  }

  file { "${topdir}/.ssh":
    ensure => 'directory',
    owner  => 'backuppc',
    group  => 'backuppc',
    mode   => '0700',
  }

  # Workaround for client exported resources that are
  # on a different osfamily. Maintain a symlink to alternative
  # config directory targets.
  case $os_family {
    'Debian': {
      file { '/etc/BackupPC':
        ensure => 'link',
        target => $config_dir,
      }
    }
    'RedHat': {
      file { '/etc/backuppc':
        ensure => 'link',
        target => $config_dir,
      }
    }
    default: {
      # Do nothing
    }
  }

  exec { 'backuppc-ssh-keygen':
    command => "ssh-keygen -f ${topdir}/.ssh/id_rsa -C 'BackupPC on ${facts['networking']['fqdn']}' -N ''",
    user    => 'backuppc',
    creates => "${topdir}/.ssh/id_rsa",
    path    => ['/usr/bin','/bin'],
    require => [
        Package[$package_name],
        File["${topdir}/.ssh"],
    ],
  }

  if $facts['backuppc_pubkey_rsa'] {
    @@ssh_authorized_key { "backuppc_${facts['networking']['fqdn']}":
      ensure => 'present',
      key    => $facts['backuppc_pubkey_rsa'],
      name   => "backuppc_${facts['networking']['fqdn']}",
      user   => 'backup',
      type   => 'ssh-rsa',
      tag    => "backuppc_${facts['networking']['fqdn']}",
    }
  }

  File <<| tag == "backuppc_config_${facts['networking']['fqdn']}" |>> {
    group  => $apache_group,
    before => Service[$service_name],
    notify => Exec['backuppc reload'],
  }
  Augeas <<| tag == "backuppc_hosts_${facts['networking']['fqdn']}" |>> {
    before  => Service[$service_name],
    require => File["${config_dir}/hosts"],
    notify  => Exec['backuppc reload'],
  }

  Sshkey <<| tag == "backuppc_sshkeys_${facts['networking']['fqdn']}" |>>
}
