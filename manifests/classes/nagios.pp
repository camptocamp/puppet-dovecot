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

}
