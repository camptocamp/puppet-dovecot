# Additions to os-base for servers 
#
# This template is included in everything but workstations
#
# Uses the $server_group variable and includes syslog and basic nagios checks for prod servers.
# 
# Requires: os-base

class os-server {

  case $operatingsystem {
    /Debian|Ubuntu/: { include os-server-debian }
    /RedHat|CentOS/: {  }
    default: { fail "No instruction for \$operatingsystem $operatingsystem" }
  }

  common::concatfilepart { "000-sudoers.init":
    ensure  => present,
    file    => "/etc/sudoers",
    manage  => true,
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
    $basic_contact_group = "admins"
  
    include os-monitoring

    # server load
    case $fqdn {
      "sajama.int.lsn.camptocamp.com",
      "kawakarpo.int.lsn.camptocamp.com": {
        $monitoring_load_warn = "15,12,10"
        $monitoring_load_crit = "20,15,12"
      }
      default: {
      }
    }
  
    # define check_load_backup
    nagios::command {"check_load_backup":
      ensure => absent,
      command_line => '$USER1$/check_load -w 25,20,15 -c 30,25,20',
    }
  }
    
}

