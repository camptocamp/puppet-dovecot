/*

== Class: pacemaker

Installs the pacemaker package and heartbeat high availability service. This
class sets up heartbeat on the nodes of the cluster, then optionally loads the
cluster configuration.

The default communication between nodes is via network broadcast. So mind your
network and firewall settings !

Once you have included this class, you should be able to see in the system logs
that the cluster nodes are talking to each other. "crm status" should display all
your cluster nodes as "online".

It is then your job to define the cluster resources and relationships using the
"crm" command. For more details, see http://clusterlabs.org/wiki/Documentation


Class variables:
- *$pacemaker_authkey*: the secret key shared between cluster nodes. It is
  required to set this attribute.
- *$pacemaker_crmcli*: the configuration file we want to activate as a
  configuration file. If this attribute is not set, puppet will not manage the
  cluster's configuration.
- *$pacemaker_hacf*: An alternate file to use instead of the default
  /etc/ha.d/ha.cf defined in this class. This attribute should point to an ERB
  template somewhere in your modulepath.
- *$pacemaker_port*: UDP port used in default configuration. Defaults to 691.
- *$pacemaker_interface*: Interface used in default configuration. Defaults to eth0.
- *$pacemaker_keepalive*: keepalive parameter used in default configuration. Defaults to 1.
- *$pacemaker_warntime*: warntime parameter used in default configuration. Defaults to 6.
- *$pacemaker_deadtime*: deadtime parameter used in default configuration. Defaults to 10.
- *$pacemaker_initdead*: initdead parameter used in default configuration. Defaults to 15.


Example usage:

  # use ha.cf template from $moduledir/mymodule/templates/myproject.ha.cf.erb
  $pacemaker_hacf      = "mymodule/myproject.ha.cf.erb"
  $pacemaker_crmcli    = "puppet:///myproject/crm_config.cli"
  $pacemaker_interface = "eth1"
  $pacemaker_authkey   = "gugus"

  include pacemaker

*/
class pacemaker {

  if ( ! $pacemaker_authkey )   { fail("Mandatory variable \$pacemaker_authkey not set") }

  if ( ! $pacemaker_port )      { $pacemaker_port = "691" }
  if ( ! $pacemaker_interface ) { $pacemaker_interface = "eth0" }
  if ( ! $pacemaker_keepalive ) { $pacemaker_keepalive = "1" }
  if ( ! $pacemaker_warntime )  { $pacemaker_warntime = "6" }
  if ( ! $pacemaker_deadtime )  { $pacemaker_deadtime = "10" }
  if ( ! $pacemaker_initdead )  { $pacemaker_initdead = "15" }

  case $operatingsystem {
    RedHat: {

      # opensuse build service has pacemaker packages available for RHEL.
      yumrepo { "server_ha-clustering":
        descr => "High Availability/Clustering server technologies (RHEL_${lsbmajdistrelease})",
        baseurl => "http://download.opensuse.org/repositories/server:/ha-clustering/RHEL_${lsbmajdistrelease}/",
        enabled => 1,
        gpgkey => "http://download.opensuse.org/repositories/server:/ha-clustering/RHEL_${lsbmajdistrelease}/repodata/repomd.xml.key",
        gpgcheck => 1,
      }

      package { "pacemaker.${architecture}":
        ensure  => present,
        alias   => "pacemaker",
        require => Package["heartbeat"],
      }

      package { "heartbeat.${architecture}":
        ensure => present,
        alias  => "heartbeat",
      }

    }

    Debian: {
      package { ["pacemaker", "heartbeat"]:
        ensure => present
      }
    }
  }



  file { "/etc/ha.d/authkeys":
    content => "auth 1\n1 sha1 ${pacemaker_authkey}\n",
    owner   => "root",
    mode    => 0600,
    notify  => Service["heartbeat"],
    require => Package["heartbeat"],
  }

  # heartbeat configuration file, which can be either an ERB template located
  # at $pacemaker_hacf, or the default file shipped with this module.
  file { "/etc/ha.d/ha.cf":
    content => $pacemaker_hacf ? {
      default => template($pacemaker_hacf),
      ""      => template("pacemaker/ha.cf.erb"),
    },
    notify  => Service["heartbeat"],
    require => Package["heartbeat"],
  }

  service { "heartbeat":
    ensure    => running,
    hasstatus => true,
    enable    => true,
    require   => Package["heartbeat"],
  }

  if ( $pacemaker_crmcli ) {

    # actually load the configuration into heartbeat
    exec { "reload crm config":
      command     => "crm configure load replace /etc/ha.d/crm-config.cli",
      refreshonly => true,
      require     => Service["heartbeat"],
    }

    # this file contains the configuration to be loaded into the cluster.
    file { "/etc/ha.d/crm-config.cli":
      notify  => Exec["reload crm config"],
      source  => $pacemaker_crmcli,
      require => Package["heartbeat"],
    }
  }
}
