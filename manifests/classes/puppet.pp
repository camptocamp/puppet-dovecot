class monitoring::puppet {

  # Le ficher state.yaml est mis à jour à chaque run puppet. Si puppet n'est
  # plus exécuté (cron absent, fichier de lock), le fichier n'est plus mis à
  # jour. Si puppet a été interrompu (CTRL-C), il sera vide.
  monitoring::check { "Puppet last run":
    codename => "check_puppet_state_yaml",
    command  => "check_file_age",
    options  => "-W 1 -C 1 -w 86400 -c 86400 -f /var/puppet/state/state.yaml", # once per day
    interval => "360", # 6h
    retry    => "180", # 3h
    package  => "nagios-plugins-file_age",
  }

  # Si le manifest puppet fourni par le puppetmaster génère une erreur ou un
  # warning, puppet appliquera la config stockée dans localconfig.yaml à la
  # place. Ce fichier ne sera donc pas mis à jour.
  monitoring::check { "Puppet last manifest refresh":
    codename => "check_puppet_localconfig_yaml",
    command  => "check_file_age",
    options  => "-w 259200 -c 259200 -f /var/puppet/state/localconfig.yaml", # once every 3 days
    interval => "360", # 6h
    retry    => "180", # 3h
    package  => "nagios-plugins-file_age",
  }


  monitoring::check { "legacy puppet check":
    ensure   => absent,
    codename => "check_puppet",
  }

  file {
    ["/usr/lib/nagios/plugins/contrib/check_puppet.pl",
     "/usr/lib64/nagios/plugins/contrib/check_puppet.pl"]: ensure => absent }
}
