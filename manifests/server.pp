# == Class: backuppc::server
#
# This module manages backuppc
#
# === Parameters
#
# [*ensure*]
# Present or absent
#
# [*service_enable*]
# Boolean. Will enable service at boot
# and ensure a running service.
#
# [*wakup_schedule*]
# Times at which we wake up, check all the PCs,
# and schedule necessary backups. Times are measured
# in hours since midnight. Can be fractional if
# necessary (eg: 4.25 means 4:15am).
#
# [*max_backups*]
# Maximum number of simultaneous backups to run. If
# there are no user backup requests then this is the
# maximum number of simultaneous backups.
#
# [*max_user_backups*]
# Additional number of simultaneous backups that users
# can run. As many as $Conf{MaxBackups} + $Conf{MaxUserBackups}
# requests can run at the same time.
#
# [*max_pending_cmds*]
# Maximum number of pending link commands. New backups will only
# be started if there are no more than $Conf{MaxPendingCmds} plus
# $Conf{MaxBackups} number of pending link commands, plus running
# jobs. This limit is to make sure BackupPC doesn't fall too far
# behind in running BackupPC_link commands.
#
# [*max_backup_pc_nightly_jobs*]
# How many BackupPC_nightly processes to run in parallel. Each night,
# at the first wakeup listed in $Conf{WakeupSchedule}, BackupPC_nightly
# is run. Its job is to remove unneeded files in the pool, ie: files that
# only have one link. To avoid race conditions, BackupPC_nightly and BackupPC_link
# cannot run at the same time. Starting in v3.0.0, BackupPC_nightly can run
# concurrently with backups (BackupPC_dump).
#
# [*backup_pc_nightly_period*]
# How many days (runs) it takes BackupPC_nightly to traverse the entire pool.
# Normally this is 1, which means every night it runs, it does traverse the entire
# pool removing unused pool files.
#
# [*max_old_log_files*]
# Maximum number of log files we keep around in log directory. These files are aged
# nightly. A setting of 14 means the log directory will contain about 2 weeks of old
# log files, in particular at most the files LOG, LOG.0, LOG.1, ... LOG.13 (except today's
# LOG, these files will have a .z extension if compression is on).
#
# [*df_max_usage_pct*]
# Maximum threshold for disk utilization on the __TOPDIR__ filesystem. If the output
# from $Conf{DfPath} reports a percentage larger than this number then no new regularly
# scheduled backups will be run. However, user requested backups (which are usually
# incremental and tend to be small) are still performed, independent of disk usage. Also,
# currently running backups will not be terminated when the disk usage exceeds this number.
#
# [*trash_clean_sleep_sec*]
# How long BackupPC_trashClean sleeps in seconds between each check of the trash directory.
#
# [*dhcp_address_ranges*]
# List of DHCP address ranges we search looking for PCs to backup. This is an array of
# hashes for each class C address range. This is only needed if hosts in the conf/hosts
# file have the dhcp flag set.
#
# [*full_period*]
# Minimum period in days between full backups. A full dump will only be done if at least
# this much time has elapsed since the last full dump, and at least $Conf{IncrPeriod}
# days has elapsed since the last successful dump.
#
# [*full_keep_cnt*]
# Number of full backups to keep.
#
# [*full_age_max*]
# Very old full backups are removed after $Conf{FullAgeMax} days. However, we keep
# at least $Conf{FullKeepCntMin} full backups no matter how old they are.
#
# [*incr_period*]
# Minimum period in days between incremental backups (a user requested incremental
# backup will be done anytime on demand).
#
# [*incr_keep_cnt*]
# Number of incremental backups to keep.
#
# [*incr_age_max*]
# Very old incremental backups are removed after $Conf{IncrAgeMax} days. However,
# we keep at least $Conf{IncrKeepCntMin} incremental backups no matter how old
# they are.
#
# [*incr_levels*]
# A full backup has level 0. A new incremental of level N will backup all files
# that have changed since the most recent backup of a lower level.
#
# [*partial_age_max*]
# A failed full backup is saved as a partial backup. The rsync XferMethod can
# take advantage of the partial full when the next backup is run. This parameter
# sets the age of the partial full in days: if the partial backup is older than
# this number of days, then rsync will ignore (not use) the partial full when the
# next backup is run. If you set this to a negative value then no partials will be
# saved. If you set this to 0, partials will be saved, but will not be used by the
# next backup.
#
# [*incr_fill*]
# Boolean. Whether incremental backups are filled. "Filling" means that the most recent fulli
# (or filled) dump is merged into the new incremental dump using hardlinks. This
# makes an incremental dump look like a full dump.
#
# [*restore_info_keep_cnt*]
# Number of restore logs to keep. BackupPC remembers information about each restore
# request. This number per client will be kept around before the oldest ones are pruned.
#
# [*archive_info_keep_cnt*]
# Number of archive logs to keep. BackupPC remembers information about each archive request.
# This number per archive client will be kept around before the oldest ones are pruned.
#
# [*blackout_good_cnt*]
# PCs that are always or often on the network can be backed up after hours, to reduce PC,
# network and server load during working hours. For each PC a count of consecutive good
# pings is maintained. Once a PC has at least $Conf{BlackoutGoodCnt} consecutive good pings
# it is subject to "blackout" and not backed up during hours and days specified by $Conf{BlackoutPeriods}.
#
# [*blackout_zero_files_is_fatal*]
# Boolean. A backup of a share that has zero files is considered fatal. This is used to catch miscellaneous Xfer
# errors that result in no files being backed up. If you have shares that might be
# empty (and therefore an empty backup is valid) you should set this to false.
#
# [*email_notify_min_days*]
# Minimum period between consecutive emails to a single user. This tries to keep annoying email to users to
# a reasonable level.
#
# [*email_from_user_name*]
# Name to use as the "from" name for email.
#
# [*email_admin_user_name*]
# Destination address to an administrative user who will receive a nightly email with warnings and errors.
#
# [*email_notify_old_backup_days*]
# How old the most recent backup has to be before notifying user. When there have been no backups in this
# number of days the user is sent an email.
#
# [*email_headers*]
# Additional email headers.
#
# [*apache_configuration*]
# Boolean. Whether to install the apache configuration file that creates an alias for the /backuppc url.
# Disable this if you intend to install backuppc as a virtual host yourself.
#
# [*apache_allow_from*]
# A space seperated list of hostnames, ip addresses and networks that are permitted to
# access the backuppc interface.
#
# [*apache_require_ssl*]
# This directive forbids access unless HTTP over SSL (i.e. HTTPS) is used. Relies on mod_ssl.
#
# [*backuppc_password*]
# Password for the backuppc user used to access the web interface.
#
# [*topdir*]
# Overwrite package default location for backuppc.
#
# === Examples
#
#  See tests folder.
#
# === Authors
#
# Scott Barr <gsbarr@gmail.com>
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
  Array[Integer]$wakeup_schedule = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23],
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
  Array[Integer] $full_keep_cnt = [1],
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
  Boolean $rsync_cmd_with_sudo = false,
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
  Array $cgi_admin_user_group = [],
  Array $cgi_admin_users = [],
  Variant[Stdlib::HTTPUrl, Stdlib::HTTPSUrl ] $cgi_url = "http://${facts['networking']['fqdn']}/backuppc",
  Boolean $manage_user = true,
  Optional[Integer] $user_uid = undef,
  Stdlib::Absolutepath $user_shell = '/sbin/nologin',
  Optional[Integer] $user_gid = undef,
) {

  $os_family = $facts['os']['family']
  $os_major = $facts['os']['release']['major']
  $os = "${os_family}-${os_major}"
  $supported = ["RedHat-8", "Debian-11", "Debian-22.04"]
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
    ensure  => 'installed',
    before  => File[$config],
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
    notify  => Service[$service_name],
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
    ensure  => 'directory',
    owner   => 'backuppc',
    group   => $apache_group,
    mode    => '0750',
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
      ensure  => 'present',
      key     => $facts['backuppc_pubkey_rsa'],
      name    => "backuppc_${facts['networking']['fqdn']}",
      user    => 'backup',
      type    => 'ssh-rsa',
      tag     => "backuppc_${facts['networking']['fqdn']}",
    }
  }

  File <<| tag == "backuppc_config_${facts['networking']['fqdn']}" |>> {
    group  => $apache_group,
    notify => Service[$service_name],
  }
  Augeas <<| tag == "backuppc_hosts_${facts['networking']['fqdn']}" |>> {
    notify  => Service[$service_name],
    require => File["${config_dir}/hosts"],
  }

  Sshkey <<| tag == "backuppc_sshkeys_${facts['networking']['fqdn']}" |>>
}
