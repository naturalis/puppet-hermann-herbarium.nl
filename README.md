puppet-hermann-herbarium.nl
===================

Puppet modules for deployment of www.hermann-herbarium.nl. 

Parameters
-------------
All parameters are read from hiera

Classes
-------------
- vsftpd
- apache
- duplicity

Dependencies
-------------
- thias/puppet-vsftpd Release 0.2.0
- apache2 module from puppetlabs
- Jimdo/puppet-duplicity

Examples
-------------
Hiera yaml
dest_id and dest_key are API keys for amazon s3 account
```
hermannherbarium:
  www.hermann-herbarium.nl:
    serveraliases: 'lianas-org-guyana.org'
    docroot: /var/www/hermannherbarium
    port: 80
    ssl: no
    priority: 10
    serveradmin: aut@naturalis.nl
hermannherbarium::backup: true
hermannherbarium::backuphour: 3
hermannherbarium::backupminute: 3
hermannherbarium::backupdir: '/tmp/backups'
hermannherbarium::dest_id: 'provider_id'
hermannherbarium::dest_key: 'provider_key'
hermannherbarium::bucket: 'hermannherbarium'
hermannherbarium::ftpserver: true
hermannherbarium::ftpusers:
  wwwlianas-of-guyana:
    comment: "FTP User"
    home: "/var/www/hermannherbarium"
    password: "$1$A6ZSNQVG$hnRIP/LfJQNRyuEAwmssK/"

```
Puppet code
```
class { hermannherbarium: }
```
Result
-------------
Working webserver, restored from latest backup version. with daily backup and FTP server access.

Limitations
-------------
This module has been built on and tested against Puppet 3 and higher.

The module has been tested on:
- Ubuntu 12.04LTS
- 

Authors
-------------
Author Name <hugo.vanduijn@naturalis.nl>

