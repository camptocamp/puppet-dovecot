class monitoring::pacemaker {

  if ($operatingsystem =~ /RedHat|CentOS/) and !defined(User["nagios"]) {

    # nagios need to have access to the sockets in /var/run/crm to be able to
    # run crm_mon
    user { "nagios":
      groups  => "haclient",
      require => Package["nagios"],
    }
  }

  file { "/opt/nagios-plugins/check_crm":
    mode   => 0755,
    owner  => "root",
    group  => "root",
    source => "puppet:///pacemaker/check_crm.sh",
    before => Monitoring::Check["CRM"],
  }

  # TODO: replace by crm_mon -s once this bug is fixed:
  # http://developerbugs.linux-foundation.org/show_bug.cgi?id=2344
  monitoring::check { "CRM":
    codename => "check_crm_status",
    command  => "check_crm",
    options  => "/etc/ha.d/cluster-status.txt '[a-z0-9]+\.epfl\.ch'",
    base     => '$USER2$/',
    type     => "passive",
    server   => $nagios_nsca_server,
  }

  monitoring::check { "Process: heartbeat":
    codename => "check_hb_process",
    command  => "check_procs",
    options  => "-w 4:10 -c 1: -C heartbeat",
    type     => "passive",
    server   => $nagios_nsca_server,
    package  => $operatingsystem ?{
      /RedHat|CentOS/ => "nagios-plugins-procs",
      default => false
    }
  }
}
