class os-base-centos {
  exec { "update yum cache":
    command => "yum clean all; yum makecache",
    refreshonly => true,
    timeout => "-1",
  }

  yumrepo {"epel-fedora":
    descr => "Extra Packages for Enterprise Linux ${lsbmajdistrelease} - \$basearch",
    baseurl => "http://mirror.switch.ch/ftp/mirror/epel/${lsbmajdistrelease}/\$basearch",
    enabled => 1,
    gpgkey => "http://mirror.switch.ch/ftp/mirror/epel/RPM-GPG-KEY-EPEL",
    gpgcheck => 1,
    tag => "install-puppet",
  }

  # KIS-C2C self-made packages
  yumrepo { "kis-local-pkgs":
    descr => "KIS Home-Made packages",
    baseurl => "http://www19.epfl.ch/kis-repo/utils/${lsbmajdistrelease}/${architecture}",
    enabled => 1,
    gpgcheck => 0,
  }
  
  package {["bash-completion"]:
    ensure => present,
    require => Yumrepo["epel-fedora"],
  }

  package {"sendmail":
    ensure => absent,
  }

  if $manufacturer =~ /Dell/ {
    include dell::openmanage
    if $server_group == "prod" {
      include monitoring::dell::warranty
      include monitoring::dell::omsa

      # ugly - omreport 6.3 doesn't work with this script // broken script in fact
      common::concatfilepart {"sudo for nagios":
        ensure => absent,
        file => "/etc/sudoers",
        content => "nagios ALL=(ALL) NOPASSWD: /usr/sbin/dmidecode\n",
      }

      common::concatfilepart {"nagios.dmidecode":
        file => "/etc/sudoers",
        content => "nagios ALL=(ALL) NOPASSWD: /usr/sbin/dmidecode\n",
      }
      
      monitoring::check { "Dell OMSA-snmp bridge":
        ensure   => absent,
        codename => "check_dell_snmp",
        command  => "check_snmp",
        options  => "-H localhost -R 'dell' -o SNMPv2-SMI::enterprises.674.10892.1.300.10.1.8.1",
        interval => "120", # every 2h
        retry    => "60",  # every 1h
        type     => "passive",
        server   => $nagios_nsca_server,
        package  => $operatingsystem ? {
          /RedHat|CentOS/  => "nagios-plugins-snmp",
          default => "libnet-snmp-perl",
        },
      }
    }
  }

  if $server_group == "prod" {
    package {"nagios-plugins-ping": }
  }
}
