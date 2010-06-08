# Additions to os-base for servers 
#
# This template is included in everything but workstations
#
# Uses the $server_group variable and includes syslog and basic nagios checks for prod servers.
# 
# Requires: os-base

class os-server {

  common::concatfilepart { "000-sudoers.init":
    ensure => present,
    file => "/etc/sudoers",
    content => "
## This part is managed by puppet
Defaults    env_keep=SSH_AUTH_SOCK
Defaults    !authenticate
Defaults    env_reset
Defaults    mailto=c2c.sysadmin@camptocamp.com
Defaults    always_set_home
root  ALL=(ALL) ALL
##

",
  }

  if $server_group == "prod" {

    # Syslog-ng installation that also sends logs to logserver.camptocamp.com
    #include c2c::syslog::client

    # Nagios installation and basic checks present on all production servers
    $basic_contact_group = "sysadmins"
  
    include nagios::base
    include nagios::nsca::client

    # create host
    nagios::host::distributed {$fqdn:
      ensure => present,
      nagios_alias => "$hostname ($hostgroup)",
      contact_groups => $basic_contact_group,
      hostgroups => $hostgroup,
    }
  
    # ssh status
    nagios::service::distributed {"check_ssh!22":
      ensure              => present,
      host_name           => $fqdn,
      contact_groups      => $basic_contact_group,
      service_description => "OpenSSH service",
    }
  
    # disk usage
    nagios::service::distributed {"check_local_du":
      ensure              => present,
      host_name           => $fqdn,
      contact_groups      => $basic_contact_group,
      service_description => "disk usage",
    }
  
    # puppet last run
    nagios::service::distributed {"check_puppet_state_yaml":
      ensure              => present,
      host_name           => $fqdn,
      contact_groups      => $basic_contact_group,
      service_description => "Puppet last run",
    }
  
    # puppet last manifest refresh
    nagios::service::distributed {"check_puppet_localconfig_yaml":
      ensure              => present,
      host_name           => $fqdn,
      contact_groups      => $basic_contact_group,
      service_description => "Puppet last manifest refresh",
    }
  
    # server load
    case $fqdn {
      "sajama.int.lsn.camptocamp.com",
      "kawakarpo.int.lsn.camptocamp.com",
      "backuppc.dmz.cby.camptocamp.com",
      "rakaposhi.dmz.tls.camptocamp.com": {
        nagios::service::distributed {"check_load_backup":
          ensure => present,
          host_name => $fqdn,
          contact_groups => "hardware-host",
          service_description => "load average Backup",
        }
      }
      default: {
        nagios::service::distributed {"check_load":
          ensure => present,
          host_name => $fqdn,
          contact_groups => "hardware-host",
          service_description => "load average",
        }
      }
    }
  
    # define check_load_backup
    nagios::command {"check_load_backup":
      ensure => present,
      command_line => '$USER1$/check_load -w 25,20,15 -c 30,25,20',
    }
  
    # defin check_puppet_state_yaml
    nagios::command {"check_puppet_state_yaml":
      ensure => present,
      command_line => '$USER1$/check_file_age -W 1 -C 1 -w 86400 -c 86400 -f /var/puppet/state/state.yaml',
    }
  
    # define check_puppet_localconfig_yaml
    nagios::command {"check_puppet_localconfig_yaml":
      ensure => present,
      command_line => '$USER1$/check_file_age -w 259200 -c 259200 -f /var/puppet/state/localconfig.yaml',
    }
  }
    
}

