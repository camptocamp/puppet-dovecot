class monitoring::diskusage {

  if !$monitoring_diskusage_opt {
    $monitoring_diskusage_opt = "--warning=10% --iwarning=10% --critical=5% --icritical=5% --unit=GB --errors-only"
  }

  monitoring::check { "Disk Usage":
    codename => "check_disk_usage",
    command  => "check_disk",
    options  => $monitoring_diskusage_opt,
    package  => $operatingsystem ? {
      RedHat  => "nagios-plugins-disk",
      default => false,
    },
  }

  monitoring::check { "legacy disk usage":
    ensure   => absent,
    codename => "check_local_du",
  }
}
