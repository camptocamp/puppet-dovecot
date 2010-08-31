/*

== Class: openvz::server::rhel

Is included when we include `openvz::server`.

It will disable SELinux (ovz kernel doesn't support it), activate ovz repositories
and install kernel and tools.

*/
class openvz::server::rhel {

  augeas {"disable selinux":
    context => "/files/etc/sysconfig/selinux",
    changes => "set SELINUX disabled",
  }

  yumrepo {"openvz-kernel-rhel5":
    descr => "OpenVZ RHEL5-based kernel",
    mirrorlist => "http://download.openvz.org/kernel/mirrors-rhel5-2.6.18",
    enabled => 1,
    gpgkey => "http://download.openvz.org/RPM-GPG-Key-OpenVZ",
    gpgcheck => 1,
  }

  yumrepo {"openvz-utils":
    descr => "OpenVZ utilities",
    mirrorlist => "http://download.openvz.org/mirrors-current",
    enabled => 1,
    gpgkey => "http://download.openvz.org/RPM-GPG-Key-OpenVZ",
    gpgcheck => 1,
  }

  package {["vconfig.x86_64", "bridge-utils.x86_64"]:
    ensure => present,
  }

  package{[
    "ovzkernel.x86_64",
    "vzctl.x86_64",
    "vzctl-lib.x86_64",
    "vzquota.x86_64"
    ]:
    ensure  => latest,
    require => [Yumrepo["openvz-kernel-rhel5"], Yumrepo["openvz-utils"]],
  }
}
