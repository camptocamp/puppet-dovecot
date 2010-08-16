class monitoring::cron {

  monitoring::check { "Process: crond":
    codename => "check_crond_process",
    command  => "check_procs",
    options  => $operatingsystem ? {
      Debian => "-w 1: -c 1: -C cron",
      /RedHat|CentOS/ => "-w 1: -c 1: -C crond",
    },
    package  => $operatingsystem ?{
      /RedHat|CentOS/ => "nagios-plugins-procs",
      default => false
    }
  }
}
