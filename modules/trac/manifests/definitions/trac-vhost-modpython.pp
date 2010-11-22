define trac::vhost-ssl-modpython($ensure, $group="www-data", $mode=2770, $aliases = [], $project,$slash=false) {

  apache::vhost-ssl {$name:
    ensure  => $ensure,
    aliases => $aliases,
    group   => $group,
    mode    => $mode,
  }

  if !defined(Apache::Module["mod_python"]) {
    case $lsbdistcodename {
      'etch': {
        apache::module {"mod_python":
          ensure => present,
          require => Package["libapache2-mod-python"],
        }
      }
      default: {}
    }
  }

  if !defined(Apache::Module['python']) {
    case $lsbdistcodename {
      'lenny': {
        apache::module {"python":
          ensure => present,
          require => Package["libapache2-mod-python"],
        }
      }
      default: {}
    }
  }


  if !defined(Package["libapache2-mod-python"]) {
    package {"libapache2-mod-python":
      ensure => present,
    }
  }

  file {"/var/www/$name/conf/trac.conf":
    ensure  => present,
    content => template("trac/trac-vhost-modpython.erb"),
    notify  => Service["apache2"],
    require => $lsbdistcodename ? { etch => Apache::Module["mod_python"], lenny => Apache::Module["python"]},
  }

}
