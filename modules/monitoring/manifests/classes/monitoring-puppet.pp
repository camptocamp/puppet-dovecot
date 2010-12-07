class monitoring::puppet {

  if versioncmp($puppetversion, '0.25.4') > 0 {
    $statepath = '/var/lib/puppet/state'
  } else {
    $statepath = '/var/puppet/state'
  }

  # Le ficher state.yaml est mis à jour à chaque run puppet. Si puppet n'est
  # plus exécuté (cron absent, fichier de lock), le fichier n'est plus mis à
  # jour. Si puppet a été interrompu (CTRL-C), il sera vide.
  monitoring::check { "Puppet last run":
    codename => "check_puppet_last_run",
    command  => "check_file_age",
    options  => "-W 1 -C 1 -w 86400 -c 432000 -f ${statepath}/state.yaml", # warn after 24h, crit after 5 days
    interval => "60",
    retry    => "30",
    type     => "passive",
    server   => $nagios_nsca_server,
    package  => $operatingsystem ? {
      /RedHat|CentOS/  => "nagios-plugins-file_age",
      default => false,
    },
  }

  # Si le manifest puppet fourni par le puppetmaster génère une erreur ou un
  # warning, le fichier classes.txt ne sera sera pas mis à jour par puppet.
  monitoring::check { "Puppet last manifest refresh":
    codename => "check_puppet_last_successful_run",
    command  => "check_file_age",
    options  => "-w 86400 -c 432000 -f ${statepath}/classes.txt", # warn after 24h, crit after 5 days
    interval => "60",
    retry    => "30",
    type     => "passive",
    server   => $nagios_nsca_server,
    package  => $operatingsystem ? {
      /RedHat|CentOS/  => "nagios-plugins-file_age",
      default => false,
    },
  }
}
