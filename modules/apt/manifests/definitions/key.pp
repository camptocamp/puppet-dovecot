define apt::key($ensure=present, $source="") {

  case $ensure {

    present: {
      exec { "import gpg key $name":
        command => $source ? {
          ""      => "gpg --keyserver pgp.mit.edu --recv-key '$name' && gpg --export --armor '$name' | /usr/bin/apt-key add -",
          default => "wget -O - '$source' | /usr/bin/apt-key add -",
        },
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
