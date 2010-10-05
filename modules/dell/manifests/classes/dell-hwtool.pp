class dell::hwtools {

  $ver = "6.3"

  # Dans ces paquets, on trouve de quoi flasher et extraires des infos des
  # bios & firmwares.

  case $operatingsystem {
    Debian: {
      #TODO
      package {"libsmbios-bin":
        ensure => latest,
      }
    }
    /RedHat|CentOS/: {
      package{["libsmbios", "smbios-utils", "firmware-tools"]:
        ensure => latest,
      }

      file {"/etc/pki/rpm-gpg/RPM-GPG-KEY-dell":
        ensure => present,
        source => "puppet:///dell/etc/pki/rpm-gpg/RPM-GPG-KEY-dell",
        mode => 644,
      }

      file {"/etc/pki/rpm-gpg/RPM-GPG-KEY-libsmbios":
        ensure => present,
        source => "puppet:///dell/etc/pki/rpm-gpg/RPM-GPG-KEY-libsmbios",
        mode => 644,
      }

      # http://linux.dell.com/wiki/index.php/Repository/software
      yumrepo {"dell-omsa-indep":
        descr => "Dell OMSA repository - Hardware independent",
        mirrorlist => "http://linux.dell.com/repo/hardware/OMSA_${ver}/mirrors.cgi?osname=el\$releasever&basearch=\$basearch&dellsysidpluginver=\$dellsysidpluginver",
        enabled => 1,
        gpgcheck => 1,
        gpgkey => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-dell\n\tfile:///etc/pki/rpm-gpg/RPM-GPG-KEY-libsmbios",
        require => [File["/etc/pki/rpm-gpg/RPM-GPG-KEY-dell"], File["/etc/pki/rpm-gpg/RPM-GPG-KEY-libsmbios"]]
      }

      # ensure file is managed in case we want to purge /etc/yum.repos.d/
      # http://projects.puppetlabs.com/issues/3152
      file { "/etc/yum.repos.d/dell-omsa-indep.repo":
        ensure  => present,
        mode    => 0644,
        owner   => "root",
        require => Yumrepo["dell-omsa-indep"],
      }

      file { "/etc/yum.repos.d/dell-software-repo.repo":
        ensure => absent,
      }
    }
  }

}