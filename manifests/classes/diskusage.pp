class monitoring::diskusage {

  if !$monitoring_diskusage_opt {
    $monitoring_diskusage_opt = "--warning=10% --iwarning=10% --critical=5% --icritical=5% --unit=GB --errors-only"
  }

  monitoring::check { "Disk Usage":
    codename => "check_disk_usage",
    command  => "check_disk",
    options  => $monitoring_diskusage_opt,
    interval => 30,
    retry    => 10,
    package  => $operatingsystem ? {
      /RedHat|CentOS/  => "nagios-plugins-disk",
      default => false,
    },
  }
}
