class buildenv::cpp inherits buildenv::c {

  package { "g++":
    name => $opertatingsystem ? {
      RedHat => "gcc-c++",
      Debian => "g++",
    },
  }
}
