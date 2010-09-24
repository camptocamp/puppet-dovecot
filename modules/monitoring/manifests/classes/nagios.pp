class monitoring::nagios {

  include monitoring::params
  include nagios::params

  $nagios = $nagios::params::basename

  file { "check_nagios_cfg":
    path    => "${monitoring::params::customplugins}/check_nagios_cfg",
    ensure  => present,
    mode    => 0755,
    owner   => "root",
    content => "#!/bin/sh
# file managed by puppet

CFG='/etc/${nagios}/nagios.cfg'

finish() {
  echo \$2; exit \$1
}

which '${nagios}' > /dev/null 2>&1 || finish 3 '${nagios} binary not found in path'
test -f \"\$CFG\" || finish 3 \"\$CFG not found\"

${nagios} -v \$CFG > /dev/null 2>&1 || finish 2 'error(s) found in config'

finish 0 'no error in config'
",
  }

  monitoring::check { "Nagios configuration":
    codename => "nagios_configuration",
    command  => "check_nagios_cfg",
    base     => "${monitoring::params::customplugins}",
    type     => "passive",
    server   => $nagios_nsca_server,
    require  => File["check_nagios_cfg"],
  }

  monitoring::check { "Process: nrpe":
    codename => "check_nrpe_process",
    command  => "check_procs",
    options  => "-p 1 -w 1:1 -c 1:1 -C nrpe",
    type     => "passive",
    server   => $nagios_nsca_server,
    package  => $operatingsystem ? {
      /RedHat|CentOS/ => "nagios-plugins-procs",
      default => false
    }
  }

  monitoring::check { "Nagios status":
    codename => "nagios_status",
    command  => "check_nagios",
    options  => "-e 5 -F /var/cache/${nagios}/status.dat -C /usr/sbin/${nagios}",
    type     => "active",
    server   => $nagios_nrpe_server,
    package  => $operatingsystem ? {
      /RedHat|CentOS/ => "nagios-plugins-nagios",
      default => false,
    }
  }

}
