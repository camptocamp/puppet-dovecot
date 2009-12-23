class monitoring::cron {

  monitoring::check { "Process: crond":
    codename => "check_crond_process",
    command  => "check_procs",
    options  => $operatingsystem ? {
      Debian => "-w 1: -c 1: -C cron",
      RedHat => "-w 1: -c 1: -C crond",
    },
  }

  monitoring::check { "legacy cron check":
    codename => "check_cron",
    ensure   => absent,
  }
}
