class monitoring::collectd {

  monitoring::check { "Process: collectd":
    codename => "check_collectd_process",
    command  => "check_procs",
    options  => "-p 1 -w 1:1 -c 1:1 -C collectd",
    type     => "passive",
    server   => $nagios_nsca_server,
    package  => $operatingsystem ?{
      /RedHat|CentOS/ => "nagios-plugins-procs",
      default => false
    }
  }

  # plugin required to be able to use collectd-nagios
  collectd::plugin { "unixsock":
    lines => [
      'SocketFile "/var/run/collectd.sock"',
      'SocketGroup "nagios"',
      'SocketPerms "0770"',
    ],
    require => Package["nagios"],
  }

  if $operatingsystem == "Debian" {
    package { "collectd-utils": ensure => present }
  }

}
