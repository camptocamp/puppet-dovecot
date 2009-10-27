define c2c::checkexternalurl::export($ensure=present,$path,$host_name="check-urls",$contact_groups="sysadmins",$tag="manaslu.ext") {
  @@c2c::checkexternalurl::import {"check_url for $name $path":
    ensure         => $ensure,
    url            => $name,
    path           => $path,
    host_name      => $host_name,
    contact_groups => $contact_groups,
    tag            => $tag,
  }
}

define c2c::checkexternalurl::import($ensure=present,$url,$path,$host_name="check-urls",$contact_groups) {
  nagios::service::distributed {"check_url!$url!$path":
    ensure              => $ensure,
    host_name           => $host_name,
    service_description => "check url for $url",
    contact_groups      => $contact_groups,
    use_active          => "checkurl-generic-active",
    use_passive         => "checkurl-generic-passive",
  }
}
