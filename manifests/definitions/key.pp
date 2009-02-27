define apt::key($ensure = present, $source) {
  case $ensure {
    present: {
      exec { "/usr/bin/wget -O - '$source' | /usr/bin/apt-key add -":
        unless => "apt-key list | grep -Fqe '${name}'",
        path   => "/bin:/usr/bin",
        before => Exec["apt-get_update"],
        notify => Exec["apt-get_update"],
      }
    }
    
    absent: {
      exec {"/usr/bin/apt-key del ${name}":
        onlyif => "apt-key list | grep -Fqe '${name}'",
      }
    }
  }
}
