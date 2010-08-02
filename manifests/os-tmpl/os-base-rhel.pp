class os-base-rhel {
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
  
  package {["bash-completion", "augeas"]:
    ensure => present,
    require => Yumrepo["epel-fedora"],
  }

  package {"sendmail":
    ensure => absent,
  }
}
