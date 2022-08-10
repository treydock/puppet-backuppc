# == Class: backuppc::client
#
# Configures a host for backup with the backuppc server.
# Uses storedconfigs to provide the backuppc server with
# required information.
#
# === Parameters
#
# For parameters that are not documented here see the server
# manifest.
#
# [*ensure*]
# Present or absent.
#
# [*system_account*]
# Name of the user that will be created to allow backuppc
# access to the system via ssh. This only applies to xfer
# methods that require it. To override this set the system_account
# to an empty string and configure access to the client yourself as
# the default in the global config file (root) or change the
# rsync_client_cmd or tar_client_cmd to suit your setup.
#
# [*system_home_directory*]
# Absolute path to the home directory of the system account.
#
# [*system_additional_commands*]
# Additional sudo commands to whitelist for the system_account. This
# is useful if you need to execute any pre dump *scripts* on client before
# backup. Please prefer system_additional_commands_noexec if you want
# to whitelist a single command/binary since commands specified here
# are going to be allowed without the NOEXEC options. See man sudoers
# for details.
#
# [*system_additional_commands_noexec*]
# Additional sudo commands to whitelist for the system_account. This
# is useful if you need to execute any pre dump commands on client before
# backup.
#
# [*manage_sudo*]
# Boolean. Set to true to configure and install sudo and the
# sudoers.d directory. Defaults to false and is only applied
# if 1) xfer_method requires ssh access and 2) you're using
# the system_account parameter.
#
# [*manage_rsync*]
# Boolean. By default will install the rsync package. If you
# manage this elsewhere set it to false. Defaults to true and
# is only applied if 1) the xfer_method is rsync and 2) you're
# using the system_account parameter.
#
# [*blackout_bad_ping_limit*]
# To allow for periodic rebooting of a PC or other brief periods when a
# PC is not on the network, a number of consecutive bad pings is allowed
# before the good ping count is reset.
#
# [*ping_max_msec*]
# Maximum latency between backuppc server and client to schedule
# a backup. Default to 20ms.
#
# [*backups_disable*]
# Disable all full and incremental backups. These settings are useful for a client that
# is no longer being backed up (eg: a retired machine), but you wish to keep the last backups
# available for browsing or restoring to other machines.
#
# [*xfer_method*]
# What transport method to use to backup each host. Valid values are rsync,
# rsyncd, tar and smb.
#
# [*xfer_loglevel*]
# Level of verbosity in Xfer log files. 0 means be quiet, 1 will give will
# give one line per file, 2 will also show skipped files on incrementals,
# higher values give more output.
#
# [*smb_share_name*]
# Name of the host share that is backed up when using SMB. This can be a string or an
# array of strings if there are multiple shares per host.
#
# [*smb_share_username*]
# Smbclient share user name. This is passed to smbclient's -U argument.
#
# [*smb_share_passwd*]
# Smbclient share password. This is passed to smbclient via its PASSWD environment variable.
#
# [*smb_client_full_cmd*]
# Command to run smbclient for a full dump.
#
# [*smb_client_incr_cmd*]
# Command to run smbclient for an incremental dump.
#
# [*smb_client_restore_cmd*]
# Command to run smbclient for a restore.
#
# [*tar_share_name*]
# Which host directories to backup when using tar transport. This can be a string or an array
# of strings if there are multiple directories to backup per host.
#
# [*tar_client_cmd*]
# Command to run tar on the client. GNU tar is required. The default will run
# the tar command as the user you specify in system_account.
#
# [*tar_full_args*]
# Extra tar arguments for full backups.
#
# [*tar_incr_args*]
# Extra tar arguments for incr backups.
#
# [*tar_client_restore_cmd*]
# Full command to run tar for restore on the client. GNU tar is required.
#
# [*rsync_client_cmd*]
# Full command to run rsync on the client machine. The default will run
# the rsync command as the user you specify in system_account.
#
# [*rsync_client_restore_cmd*]
# Full command to run rsync for restore on the client.
#
# [*rsync_share_name*]
# Share name to backup. For $Conf{XferMethod} = "rsync" this should be a
# file system path, eg '/' or '/home'.
#
# [*rsyncd_client_port*]
# Rsync daemon port on host.
#
# [*rsyncd_user_name*]
# Rsync daemon user name on host.
#
# [*rsyncd_passwd*]
# Rsync daemon password on host.
#
# [*rsyncd_auth_required*]
# Whether authentication is mandatory when connecting to the client's rsyncd. By default
# this is on, ensuring that BackupPC will refuse to connect to an rsyncd on the client that
# is not password protected.
#
# [*rsync_csum_cache_verify_prob*]
# When rsync checksum caching is enabled (by adding the --checksum-seed=32761 option to
# rsync_args), the cached checksums can be occasionally verified to make sure the file
# contents matches the cached checksums.
#
# [*rsync_args*]
# Arguments to rsync for backup.
#
# [*rsync_restore_args*]
# Arguments to rsync for restore.
#
# [*backup_files_only*]
# List of directories or files to backup. If this is defined, only these
# directories or files will be backed up.
#
# [*backup_files_exclude*]
# List of directories or files to exclude from the backup. For xfer_method smb,
# only one of backup_files_exclude and backup_files_only can be specified per share.
# If both are set for a particular share, then backup_files_only takes precedence and
# backup_files_exclude is ignored.
#
# [*dump_pre_user_cmd*]
# Optional command to run before a dump.
#
# [*dump_post_user_cmd*]
# Optional command to run after a dump.
#
# [*dump_pre_share_cmd*]
# Optional command to run before a dump of a share.
#
# [*dump_post_share_cmd*]
# Optional command to run after a dump of a share.
#
# [*restore_pre_user_cmd*]
# Optional command to run before a restore.
#
# [*restore_post_user_cmd*]
# Optional command to run after a restore.
#
# [*user_cmd_check_status*]
# Whether the exit status of each PreUserCmd and PostUserCmd is checked.
#
# [*hosts_file_dhcp*]
# The way hosts are discovered has changed and now in most cases you should
# use the default of 0 for the DHCP flag, even if the host has a dynamically
# assigned IP address.
#
# [*hosts_file_most_users*]
# Additional user names, separate by commas and with no white space, can be
# specified. These users will also have full permission in the CGI interface
# to stop/start/browse/restore backups for this host. These users will not be
# sent email about this host.
#
# === Examples
#
#  See tests folder.
#
# === Authors
#
# Scott Barr <gsbarr@gmail.com>
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
  Optional[Array[Integer]] $full_keep_cnt = undef,
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
  Optional[String] $rsync_ssh_args = undef,
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
        ensure_packages(['rsync'])
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
      $additional_sudo_commands = join($system_additional_commands, ', ')
      $sudo_commands = "${additional_sudo_commands}"
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
        ensure     => $ensure,
        home       => $system_account_home_directory,
        managehome => true,
        shell      => '/bin/bash',
        comment    => 'BackupPC',
        system     => true,
        uid        => $system_account_uid,
        gid        => $system_account,
        forcelocal => true,
        before     => $user_before,
      }

      group { $system_account:
        ensure     => $ensure,
        system     => true,
        gid        => $system_account_gid,
        forcelocal => true,
      }
    }

    file { $system_account_home_directory:
      ensure  => $directory_ensure,
      owner   => $system_account,
      group   => $system_account,
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
    tag     => "backuppc_config_${backuppc_hostname}"
  }
}
