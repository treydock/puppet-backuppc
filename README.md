# backuppc

[![Puppet Forge](http://img.shields.io/puppetforge/v/treydock/backuppc.svg)](https://forge.puppetlabs.com/treydock/backuppc)
[![CI Status](https://github.com/treydock/puppet-backuppc/workflows/CI/badge.svg?branch=main)](https://github.com/treydock/puppet-backuppc/actions?query=workflow%3ACI)

#### Table of Contents

1. [Overview](#overview)
2. [Usage - Configuration options and additional functionality](#usage)
    * [BackupPC Server](#backuppc-server)
    * [BackupPC Client](#backuppc-client)
3. [Limitations - OS compatibility, etc.](#limitations)

## Overview

Manage BackupPC 4 server and clients.

This module uses PuppetDB exported resources to allow a BackupPC client to define its own client configuration that is then collected by the BackupPC server.

This module does not support BackupPC 3.x for the server class

## Usage

### BackupPC Server

It's sufficient to just include the `backuppc::server` class.

```puppet
include backuppc::server
```

Below are some examples for Hiera to setup BackupPC to be served directly via a FQDN or alias:

```yaml
backuppc::server::server_host: "%{facts.networking.fqdn}"
backuppc::server::cgi_url: "https://%{lookup('backuppc::server::server_host')}"
```

Example of creating an Apache VirtualHost for BackupPC

```puppet
include backuppc::server

apache::vhost { $backuppc::server::server_host:
  servername     => $backuppc::server::server_host,
  port           => '443',
  ssl            => true,
  manage_docroot => false,
  ssl_cert       => "/etc/letsencrypt/live/${backuppc::server::server_host}/cert.pem",
  ssl_key        => "/etc/letsencrypt/live/${backuppc::server::server_host}/privkey.pem",
  ssl_chain      => "/etc/letsencrypt/live/${backuppc::server::server_host}/chain.pem",
  aliases        => [
    {
      'alias'       => $backuppc::server::cgi_image_dir_url,
      'path'        => $backuppc::server::cgi_image_dir,
    },
    {
      'scriptalias' => '/',
      'path'        => "${backuppc::server::cgi_dir}/BackupPC_Admin",
    },
  ],
  directories    => [
    {
      'provider'      => 'location',
      'path'          => '/',
      'auth_type      => 'ldap',
      'auth_ldap_url' => 'CHANGEME',
      ...more auth items...
      'require'       => 'valid-user',
    }
  ]
}
```

### BackupPC Client

For backup clients you must have PuppetDB to handle exported resources.  Include the `backuppc::client` class:

```puppet
include backuppc::client
```

Below is an example of setting baseline backups that could be added to `common.yaml` in Hiera

```yaml
lookup_options:
  backuppc::client::rsync_share_name:
    merge: unique

backuppc::client::ensure: present
backuppc::client::config_name: "%{facts.networking.hostname}"
backuppc::client::client_name_alias: "%{facts.networking.fqdn}"
backuppc::client::backuppc_hostname: backuppc.example.com
backuppc::client::rsync_share_name:
  - /etc
  - /root
```

## Reference

[http://treydock.github.io/puppet-backuppc/](http://treydock.github.io/puppet-backuppc/)

## Limitations

The server class is only supported on EL8 (via EPEL), Debian 11 or Ubuntu 22.04
