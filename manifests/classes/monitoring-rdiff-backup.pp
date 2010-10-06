/*

== Class: monitoring::rdiff-backup
Check if backups have run successfully last days

Global variables:
- *$check_rdiff_log_dir*    : where rdiff-backup puts its logs
- *$check_rdiff_config_dir* : where rdiff-backup has its configuration
- *$check_rdiff_thld_hour*  : hour of day after which todays backup should be present

Requires:
Module rdiff-backup git://github.com/camptocamp/puppet-rdiff-backup.git

*/
class monitoring::rdiff-backup {
  include monitoring::params

  file {"${monitoring::params::customplugins}/check_rdiff_backup":
    ensure  => present,
    mode    => 0755,
    owner   => root,
    group   => root,
    content => template("monitoring/check_rdiff_backup.erb"),
  }

  monitoring::check {"System: Backup status":
    ensure => present,
    codename => "check_rdiff_backup",
    command  => "check_rdiff_backup",
    base     => "${monitoring::params::customplugins}",
    type     => "passive",
    server   => $nagios_nsca_server,
  }
}
