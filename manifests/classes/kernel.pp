class buildenv::kernel inherits buildenv::cpp {

  package { "kernel-dev":
    ensure => present,
    name   => $operatingsystem ? {
      Debian => "linux-headers-${kernelrelease}",
      RedHat => "kernel-devel-${kernelrelease}",
    },
  }
}
