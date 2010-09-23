class monitoring::params {

  $mainplugins = $operatingsystem ? {
    /RedHat|CentOS/ => $architecture ? {
      x86_64 => "/usr/lib64/nagios/plugins/",
      i386   => "/usr/lib/nagios/plugins/",
    },
    Debian => "/usr/lib/nagios/plugins/",
  }

  $customplugins = "/opt/nagios-plugins/"
}
