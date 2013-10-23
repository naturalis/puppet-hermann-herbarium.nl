#
# == Class: hermannherbarium
#
# === Authors
#
# Author Name : Hugo van Duijn <hugo,vanduijn@naturalis.nl>
#
#
class hermannherbarium (
  $backup = false,
  $restore = false,
  $backuphour = 1,
  $backupminute = 1,
  $version = 'latest',
  $backupdir = '/tmp/backups',
  $restore_directory = '/tmp/restore',
  $bucket = 'hermannherbarium',
  $bucketfolder = 'backups',
  $dest_id = undef,
  $dest_key = undef,
  $cloud = 's3',
  $pubkey_id = undef,
  $full_if_older_than = undef,
  $remove_older_than = undef,
  $coderoot = '/var/www/hermannherbarium',
  $webdirs = ['/var/www/hermannherbarium'],
  $ftpserver = false,
  $ftpbanner = 'lianas of guyana FTP server',
  $ftpusers = undef,
) {

  include concat::setup

  # Include apache modules with php
  class { 'apache':
    default_mods => true,
    mpm_module => 'prefork',
  }
  include apache::mod::php

  # Create all virtual hosts from hiera
  class { 'hermannherbarium::instances': }

  # Add hostname to /etc/hosts, svn checkout requires a resolvable hostname
  host { 'localhost':
    ip => '127.0.0.1',
    host_aliases => [ $hostname ],
  }

  file { 'backupdir':
    ensure => 'directory',
    path   => $backupdir,
    mode   => '0700',
    owner  => 'root',
    group  => 'root',
  }

  group { 'webusers':
    ensure	=> present,
  }

  file { $webdirs:
    ensure      => 'directory',
    mode        => '0775',
    group       => 'webusers',
    owner       => 'root',
    require     => Group['webusers'],
  }

  if $ftpserver == true {
    class { 'hermannherbarium::ftpserver':
      ftpd_banner        => $ftpd_banner,
      ftpuserrootdirs    => ['/var','/var/www','/var/www/hermannherbarium'],
      ftpusers		 => $ftpusers,
    }
  }

  if $backup == true {
    class { 'hermannherbarium::backup':
      backuphour         => $backuphour,
      backupminute       => $backupminute,
      backupdir          => $backupdir,
      folder             => $bucketfolder,
      bucket             => $bucket,
      dest_id            => $dest_id,
      dest_key           => $dest_key,
      cloud              => $cloud,
      pubkey_id          => $pubkey_id,
      full_if_older_than => $full_if_older_than,
      remove_older_than  => $remove_older_than,
    }
  }

  if $restore == true {
    class { 'hermannherbarium::restore':
      version     => $restoreversion,
      bucket      => $bucket,
      folder      => $bucketfolder,
      dest_id     => $dest_id,
      dest_key    => $dest_key,
      cloud       => $cloud,
      pubkey_id   => $pubkey_id,
    }
  }
}
