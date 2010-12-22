class geste::pacemaker {
  $pacemaker_authkey = 'Ko1ohQuohS'
  $pacemaker_interface = "eth1"
  $pacemaker_hacf     = "geste/ha.cf.erb"
  $pacemaker_crmcli   = "/etc/ha.d/crm-gestepc1-ip.cli"

  # namespace problem! we want to use the pacemaker class from the MODULE ;)
  include ::pacemaker

 file {"/etc/ha.d/crm-gestepc1-ip.cli":
    ensure => present,
    mode   => 0644,
    owner  => root,
    group  => root,
    require => Package["pacemaker"],
    source => "puppet:///modules/geste/pacemaker/crm-config.cli",
  }

  ::pacemaker::iptables {["128.179.67.132","128.179.67.70"]: }

}
