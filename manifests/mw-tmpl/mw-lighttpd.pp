class mw-lighttpd {
  include lighttpd::administration

  if $server_group == "prod" {
    # if we install nagios before lighty on a debian, it also installs
    # apache2 - so lighty cannot start. UGLY from debian packagers -.-
    service {"apache2":
      ensure => stopped,
      enable => false,
      before => Package["lighttpd"],
    }

    class my-lighty inherits lighttpd::base {
      case $operatingsystem {
        /Debian|Ubuntu/: {
          Package["lighttpd"] {
            before => Class["nagios::debian::packages"],
          }
        }
        /RedHat|CentOS/: {
          Package["lighttpd"] {
            before => Class["nagios::redhat::packages"],
          }
        }
      }
    }

    include my-lighty
#    include monitoring::webserver

  } else {
    include lighttpd
  }

}
