class buildenv::cpp inherits buildenv::c {

  package { "g++":
    name => $operatingsystem ? {
      RedHat => "gcc-c++",
      Debian => "g++",
    },
  }
}
