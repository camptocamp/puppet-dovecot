define apt::key($ensure = present, $source, $keyid) {
  case $ensure {
    present: {
      exec { "/usr/bin/wget -O - '$source' | /usr/bin/apt-key add -":
        unless => "apt-key list | grep -Fqe '$keyid'",
        path   => "/bin:/usr/bin",
        before => Exec["apt-get_update"],
        notify => Exec["apt-get_update"],
      }
    }
    
    absent: {
      notice "Sorry, not yet implemented"
    }
  }
}
