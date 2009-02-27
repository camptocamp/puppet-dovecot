define apt::conf($ensure, $content = false, $source = false) {
  if $content {
    file {"/etc/apt/apt.conf.d/${name}":
      ensure  => $ensure,
      content => $content,
    }
  }

  if $source {
    file {"/etc/apt/apt.conf.d/${name}":
      ensure => $ensure,
      source => $source,
    }
  }
}
