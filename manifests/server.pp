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
  $ensure                     = 'present',
  $service_enable             = true,
  $replace_config             = true,
  $wakeup_schedule            = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23],
  $max_backups                = 4,
  $max_user_backups           = 4,
  $max_pending_cmds           = 15,
  $max_backup_pc_nightly_jobs = 2,
  $backup_pc_nightly_period   = 1,
  $max_old_log_files          = 14,
  $df_max_usage_pct           = 95,
  $trash_clean_sleep_sec      = 300,
  $dhcp_address_ranges        = [],
  $full_period                = '6.97',
  $full_keep_cnt              = 1,
  $full_age_max               = 90,
  $incr_period                = '0.97',
  $incr_keep_cnt              = 6,
  $incr_age_max               = 30,
  $incr_levels                = [1],
  $incr_fill                  = false,
  $partial_age_max            = 3,
  $restore_info_keep_cnt      = 10,
  $archive_info_keep_cnt      = 10,
  $blackout_good_cnt          = 7,
  $blackout_periods           = [ { hourBegin =>  7.0,
                                    hourEnd   => 19.5,
                                    weekDays  => [1, 2, 3, 4, 5],
                                }, ],
  $blackout_zero_files_is_fatal = true,
  $checksum_seed              = false,
  $rsync_cmd_default_user     = 'root',
  $rsync_cmd_with_sudo        = false,
  $rsync_args                 = [],
  $rsync_args_extra           = [],
  $rsync_restore_args         = [],
  $compress_level             = '3',
  $email_notify_min_days      = 2.5,
  $email_from_user_name       = 'backuppc',
  $email_admin_user_name      = 'backuppc',
  $email_user_dest_domain     = $::domain,
  $email_notify_old_backup_days = 7,
  $email_headers              = { 'MIME-Version' => 1.0,
                                  'Content-Type' => 'text/plain; charset="iso-8859-1"', },
  $apache_configuration       = true,
  $apache_allow_from          = 'all',
  $apache_require_ssl         = false,
  $backuppc_password          = '',
  $backuppc_username          = 'backuppc',
  $manage_topdir              = true,
  $topdir                     = $backuppc::params::topdir,
  $cgi_admin_user_group       = 'backuppc',
  $cgi_admin_users            = ['backuppc'],
  $cgi_url                    = "http://${::fqdn}/backuppc",
  $manage_ssh_known_hosts     = true,
  $manage_user                = false,
  $user_forcelocal            = undef,
  $user_uid                   = undef,
  $user_gid                   = undef,
) inherits backuppc::params {

  if $apache_configuration and empty($backuppc_password) {
    fail('Please provide a password for the backuppc user. This is used to login to the web based administration site.')
  }
  validate_bool($service_enable)
  validate_bool($replace_config)
  validate_bool($checksum_seed)
  validate_bool($rsync_cmd_with_sudo)
  validate_bool($apache_require_ssl)
  validate_bool($manage_topdir)
  validate_bool($manage_ssh_known_hosts)
  validate_bool($manage_user)

  validate_re("$max_backups", '^[1-9]([0-9]*)?$',
  'Max_backups parameter should be a number')

  validate_re("$max_user_backups", '^[1-9]([0-9]*)?$',
  'Max_user_backups parameter should be a number')

  validate_re("$max_pending_cmds", '^[1-9]([0-9]*)?$',
  'Max_pending_cmds parameter should be a number')

  validate_re("$max_backup_pc_nightly_jobs", '^[1-9]([0-9]*)?$',
  'Max_backup_pc_nightly_jobs parameter should be a number')

  validate_re("$df_max_usage_pct", '^[1-9]([0-9]*)?$',
  'Df_max_usage_pct parameter should be a number')

  validate_re("$max_old_log_files", '^[1-9]([0-9]*)?$',
  'Max_old_log_files parameter should be a number')

  validate_re("$backup_pc_nightly_period", '^[1-9]([0-9]*)?$',
  'Backup_pc_nightly_period parameter should be a number')

  validate_re("$trash_clean_sleep_sec",  '^[1-9]([0-9]*)?$',
  'Trash_clean_sleep_sec parameter should be a number')

  validate_re($full_period, '^[0-9]([0-9]*)?(\.[0-9]{1,2})?$',
  'Full_period parameter should be a number')

  validate_re($incr_period, '^[0-9]([0-9]*)?(\.[0-9]{1,2})?$',
  'Incr_period parameter should be a number')

  validate_re("$full_keep_cnt", '^[1-9]([0-9]*)?$',
  'Full_keep_cnt parameter should be a number')

  validate_re("$full_age_max", '^[1-9]([0-9]*)?$',
  'Full_age_max parameter should be a number')

  validate_re("$incr_keep_cnt", '^[1-9]([0-9]*)?$',
  'Incr_keep_cnt parameter should be a number')

  validate_re("$incr_age_max", '^[1-9]([0-9]*)?$',
  'Incr_age_max parameter should be a number')

  validate_re("$partial_age_max", '^[1-9]([0-9]*)?$',
  'Partial_age_max parameter should be a number')

  validate_re("$restore_info_keep_cnt", '^[1-9]([0-9]*)?$',
  'Restore_info_keep_cnt parameter should be a number')

  validate_re("$archive_info_keep_cnt", '^[1-9]([0-9]*)?$',
  'Restore_info_keep_cnt parameter should be a number')

  validate_re("$blackout_good_cnt", '^[0-9]([0-9]*)?$',
  'Blackout_good_cnt parameter should be a number')

  validate_re("$email_notify_min_days", '^[0-9]([0-9]*)?(\.[0-9]{1,2})?$',
  'Email_notify_min_days parameter should be a number')

  validate_re("$email_notify_old_backup_days", '^[1-9]([0-9]*)?$',
  'Blackout_good_cnt parameter should be a number')

  validate_array($wakeup_schedule)
  validate_array($dhcp_address_ranges)
  validate_array($incr_levels)
  validate_array($blackout_periods)
  validate_array($rsync_args)
  validate_array($rsync_args_extra)
  validate_array($rsync_restore_args)
  validate_array($cgi_admin_users)

  validate_hash($email_headers)

  validate_string($apache_allow_from)
  validate_string($cgi_admin_user_group)
  validate_string($cgi_url)

  $real_incr_fill = bool2num($incr_fill)
  $real_bzfif     = bool2num($blackout_zero_files_is_fatal)

  case $ensure {
    'present': {
      $package_ensure   = 'installed'
      $file_ensure      = 'file'
      $link_ensure      = 'link'
      $directory_ensure = 'directory'
    }
    'absent': {
      $package_ensure   = 'absent'
      $file_ensure      = 'absent'
      $link_ensure      = 'absent'
      $directory_ensure = 'absent'
    }
    default: {
      fail("Class backuppc::server: ensure parameter must have a value of: present or absent")
    }
  }

  if $service_enable {
    $service_ensure = 'running'
    $notify_service = Service[$backuppc::params::service]
  } else {
    $service_ensure = 'stopped'
    $notify_service = undef
  }

  # Set up dependencies
  Package[$backuppc::params::package] -> File[$backuppc::params::config] -> Service[$backuppc::params::service]

  # Include preseeding for debian packages
  if $::osfamily == 'Debian' {
    file { '/var/cache/debconf/backuppc.seeds':
      ensure  => $ensure,
      source  => 'puppet:///modules/backuppc/backuppc.preseed',
    }
  }

  if $manage_user {
    $require_user = User['backuppc']
    if $ensure == 'present' {
      $user_before = Package[$backuppc::params::package]
    } else {
      $user_before = [Package[$backuppc::params::package], Group['backuppc']]
    }

    user { 'backuppc':
      ensure     => $ensure,
      home       => $topdir,
      managehome => true,
      shell      => '/sbin/nologin',
      comment    => 'BackupPC User',
      system     => true,
      uid        => $user_uid,
      gid        => 'backuppc',
      forcelocal => $user_forcelocal,
      before     => $user_before,
    }

    group { 'backuppc':
      ensure     => $ensure,
      system     => true,
      gid        => $user_gid,
      forcelocal => $user_forcelocal,
    }
  } else {
    $require_user = undef
  }

  # BackupPC package and service configuration
  package { $backuppc::params::package:
    ensure  => $package_ensure,
  }

  service { $backuppc::params::service:
    ensure    => $service_ensure,
    enable    => $service_enable,
    hasstatus => false,
    pattern   => 'BackupPC'
  }

  file { $backuppc::params::config:
    ensure  => $file_ensure,
    owner   => 'backuppc',
    group   => $backuppc::params::group_apache,
    mode    => '0640',
    content => template('backuppc/config.pl.erb'),
    replace => $replace_config,
    notify  => $notify_service,
  }

  if ! $replace_config {
    file { "${backuppc::params::config}.puppet":
      ensure  => $file_ensure,
      owner   => 'backuppc',
      group   => $backuppc::params::group_apache,
      mode    => '0640',
      content => template('backuppc/config.pl.erb'),
    }
  }

  file { $backuppc::params::config_directory:
    ensure  => $directory_ensure,
    owner   => 'backuppc',
    group   => $backuppc::params::group_apache,
    require => Package[$backuppc::params::package],
  }

  file { "${backuppc::params::config_directory}/pc":
    ensure  => $directory_ensure,
    owner   => 'backuppc',
    group   => $backuppc::params::group_apache,
    require => File[$backuppc::params::config_directory],
  }

  if $manage_topdir {
    file { $topdir:
      ensure  => 'directory',
      owner   => 'backuppc',
      group   => 'root',
      mode    => '0750',
      require => $require_user,
    }
  }

  file { "${topdir}/.ssh":
    ensure  => 'directory',
    owner   => 'backuppc',
    group   => 'backuppc',
    mode    => '0700',
    require => $require_user,
  }

  # Workaround for client exported resources that are
  # on a different osfamily. Maintain a symlink to alternative
  # config directory targets.
  case $::osfamily {
    'Debian': {
      file { '/etc/BackupPC':
        ensure => $link_ensure,
        target => $backuppc::params::config_directory,
      }
    }
    'RedHat': {
      file { '/etc/backuppc':
        ensure => $link_ensure,
        target => $backuppc::params::config_directory,
      }
    }
    default: {
      notify { "If you've added support for ${::operatingsystem} you'll need to extend this case statement to.":
      }
    }
  }

  exec { 'backuppc-ssh-keygen':
    command => "ssh-keygen -f ${topdir}/.ssh/id_rsa -C 'BackupPC on ${::fqdn}' -N ''",
    user    => 'backuppc',
    unless  => "test -f ${topdir}/.ssh/id_rsa",
    path    => ['/usr/bin','/bin'],
    require => [
        Package[$backuppc::params::package],
        File["${topdir}/.ssh"],
    ],
  }

  # BackupPC apache configuration
  if $apache_configuration {
    file { $backuppc::params::config_apache:
      ensure  => $file_ensure,
      content => template("backuppc/apache_${::osfamily}.erb"),
      require => Package[$backuppc::params::package],
    }

    # Create the default admin account
    backuppc::server::user { 'backuppc':
      password => $backuppc_password,
      username => $backuppc_username,
    }
  }

  # Export backuppc's authorized key to all clients
  # TODO don't rely on facter to obtain the ssh key.
  if ! empty($::backuppc_pubkey_rsa) {
    @@ssh_authorized_key { "backuppc_${::fqdn}":
      ensure  => present,
      key     => $::backuppc_pubkey_rsa,
      name    => "backuppc_${::fqdn}",
      user    => 'backup',
      options => [
        'command="~/backuppc.sh"',
        'no-agent-forwarding',
        'no-port-forwarding',
        'no-pty',
        'no-X11-forwarding',
      ],
      type    => 'ssh-rsa',
      tag     => "backuppc_${::fqdn}",
    }
  }

  # Hosts
  File <<| tag == "backuppc_config_${::fqdn}" |>> {
    group   => $backuppc::params::group_apache,
    notify  => $notify_service,
    require => File["${backuppc::params::config_directory}/pc"],
  }
  Augeas <<| tag == "backuppc_hosts_${::fqdn}" |>> {
    notify  => $notify_service,
    require => Package[$backuppc::params::package],
  }
  #File_line <<| tag == "backuppc_hosts_${::fqdn}" |>> {
  #  notify  => $notify_service,
  #  require => Package[$backuppc::params::package],
  #}

  # Ensure readable file permissions on
  # the known hosts file.
  if $manage_ssh_known_hosts {
    file { '/etc/ssh/ssh_known_hosts':
      ensure => file,
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
    }
  }

  Sshkey <<| tag == "backuppc_sshkeys_${::fqdn}" |>>
}
