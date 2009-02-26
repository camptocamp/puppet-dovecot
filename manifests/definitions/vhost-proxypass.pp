define c2c::vhost::proxypass(
  $ensure,
  $url = "",
  $group = "www-data",
  $mode = 750
) {
  apache::vhost{$name:
    ensure => $ensure,
    group  => $group,
    mode   => $mode
  }

  apache::proxypass{"${name}-slash":
    ensure   => $ensure,
    vhost    => $name,
    location => "/",
    url      => $url,
  }
}
