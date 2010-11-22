class app-nimag-manaslu {
  nagios::host::nsca {"check-url-c2c":
    ensure         => present,
    export_for     => "nagios-${nagios_nsca_server}",
    hostgroups     => "${operatingsystem}${lsbmajdistrelease}, ${virtual}, ${hardwaremodel}, ${server_group}, external",
    contact_groups => $basic_contact_group,
    nagios_alias   => "C2C URL Checks",
  }

  nagios::template {"checkurl-generic-active":
    ensure => present,
    conf_type => "service",
    content   => "normal_check_interval          20
  use                            generic-service-active
  retry_check_interval           5
"
  }

  c2c::checkexternalurl::export {
    "geoportal.unhcr.org":            host_name => "check-url-c2c", path => "/";
    "trac.mapfish.org":               host_name => "check-url-c2c", path => "/tracdocs/js/trac.js";
    "www.secureows.org":              host_name => "check-url-c2c", path => "/trac/secureows/chrome/common/js/trac.js";
    "www.riv-agridea.ch":             host_name => "check-url-c2c", path => "/css/main.css";
    "riv-agridea.ch":                 host_name => "check-url-c2c", path => "/css/main.css";
    "acorda-maquette.camptocamp.net": host_name => "check-url-c2c", path => "/";
    "c2cpc36.camptocamp.com":         host_name => "check-url-c2c", path => "/";
    "www.lausannejardins.ch":         host_name => "check-url-c2c", path => "/site/images/stories/2009/lausanne_jardin_entree.gif";
    "lausannejardins.ch":             host_name => "check-url-c2c", path => "/site/images/stories/2009/lausanne_jardin_entree.gif";
    "tinyerp.saas-camptocamp.com":    host_name => "check-url-c2c", path => "/tracdocs/js/trac.js";
    "ecointesys.saas-camptocamp.com": host_name => "check-url-c2c", path => "/";
    "www.reseauajema.ch":             host_name => "check-url-c2c", path => "/components/com_rsform/front.css";
    "www.ajema.ch":                   host_name => "check-url-c2c", path => "/components/com_rsform/front.css";
    "reseauajema.ch":                 host_name => "check-url-c2c", path => "/components/com_rsform/front.css";
    "ajema.ch":                       host_name => "check-url-c2c", path => "/components/com_rsform/front.css";
    "project.camptocamp.com":         host_name => "check-url-c2c", path => "/img/next.gif";
    "www.geoext.org":                 host_name => "check-url-c2c", path => "/_static/geoext.css";
    "geoext.org":                     host_name => "check-url-c2c", path => "/_static/geoext.css";
    "c2cpc49.camptocamp.com":         host_name => "check-url-c2c", path => "/_static/geoext.css";
    "trac.geoext.org":                host_name => "check-url-c2c", path => "/tracdocs/css/trac.css";
    "128.179.66.26":                  host_name => "check-url-c2c", path => "/";
    "sa.camptocamp.com":              host_name => "check-url-c2c", path => "/";
    # ABSENT - host down or else.
    "c2cpc42.camptocamp.com":         host_name => "check-url-c2c", path => "/cdc/scripts/mapfish/mfbase/ext/adapter/ext/ext-base.js", ensure => absent;
  }

  C2c::Checkexternalurl::Import <<| tag=='manaslu.ext' |>>
}
