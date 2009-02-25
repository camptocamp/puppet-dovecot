define os::backported_package( $ensure, $responsefile="") {

  if defined(Package[$name]) {
    debug "Package $name already exists"
  } else {
    case $responsefile {
      "" : {
        package {$name:
          ensure => $ensure,
        }
      }
      default : {
        package {$name:
          ensure       => $ensure,
          responsefile => $responsefile
        }
      }
    }
  }

  common::concatfilepart {$name:
    ensure  => present,
    content => "Package: ${name}\nPin: release a=${lsbdistcodename}-backports\nPin-Priority: 999\n\n",
    file    => "/etc/apt/preferences",
    before  => Package[$name],
  }

}
