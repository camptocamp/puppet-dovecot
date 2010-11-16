define apt::key($ensure=present, $source="", $content="") {

  case $ensure {

    present: {
      if $content == "" {
        if $source == "" {
          $thekey = "gpg --keyserver pgp.mit.edu --recv-key '$name' && gpg --export --armor '$name' | /usr/bin/apt-key add -"
        }
        else {
          $thekey = "wget -O - '$source'"
        }
      }
      else {
        $thekey = "echo '${content}'"
      }


      exec { "import gpg key $name":
        command => "${thekey} | /usr/bin/apt-key add -",
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
