define c2c::checkexternalurl::export($ensure=present,$path,$host_name="check-urls",$tag="manaslu.ext") {
  @@c2c::checkexternalurl::import {"check_url for $name $path":
    ensure     => $ensure,
    url        => $name,
    path       => $path,
    host_name  => $host_name,
    tag        => $tag,
  }
}

define c2c::checkexternalurl::import($ensure=present,$path,$host_name="check-urls") {
  monitoring::check {
    "URL: $name":
      host_name => $host_name,
      type      => "passive",
      server    => $nagios_nsca_server,
      codename  => "check_${name}",
      command   => "check_http",
      options   => "-H ${name} -u ${path}",
  }
}
