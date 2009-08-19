class python {

  package { "python":
    ensure => present,
  }
}

class python::dev {

  include python

  package { "python-dev":
    ensure => present,
    name   => $operatingsystem ? {
      Debian => "python-dev",
      RedHat => "python-devel",
    },
  }
}

