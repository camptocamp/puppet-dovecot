class app-nimag-manaslu {
  nagios::host::nsca {"check-url":
    ensure         => present,
    export_for     => "nagios-${nagios_nsca_server}",
    hostgroups     => "${operatingsystem}${lsbmajdistrelease}, ${virtual}, ${hardwaremodel}, ${server_group}, external",
    contact_groups => $basic_contact_group,
    nagios_alias   => "check-url",
  }


  nagios::template {"checkurl-generic-active":
    ensure => present,
    conf_type => "service",
    content   => "normal_check_interval          20
  use                            generic-service-active
  retry_check_interval           5
"
  }

  c2c::checkexternalurl::import{
    "geoportal.unhcr.org":            path => "/";
    "trac.mapfish.org":               path => "/tracdocs/js/trac.js";
    "www.secureows.org":              path => "/trac/secureows/chrome/common/js/trac.js";
    "www.riv-agridea.ch":             path => "/css/main.css";
    "riv-agridea.ch":                 path => "/css/main.css";
    "acorda-maquette.camptocamp.net": path => "/";
    "c2cpc36.camptocamp.com":         path => "/";
    "www.lausannejardins.ch":         path => "/site/images/stories/2009/lausanne_jardin_entree.gif";
    "lausannejardins.ch":             path => "/site/images/stories/2009/lausanne_jardin_entree.gif";
    "tinyerp.saas-camptocamp.com":    path => "/tracdocs/js/trac.js";
    "ecointesys.saas-camptocamp.com": path => "/";
    "www.reseauajema.ch":             path => "/components/com_rsform/front.css";
    "www.ajema.ch":                   path => "/components/com_rsform/front.css";
    "reseauajema.ch":                 path => "/components/com_rsform/front.css";
    "ajema.ch":                       path => "/components/com_rsform/front.css";
    "vanoise.camptocamp.net":         path => "/media/system/js/caption.js";
    "extranet.camptocamp.net":        path => "/media/system/js/caption.js";
    "observatoire.camptocamp.net":    path => "/media/system/js/caption.js";
    "c2cpc42.camptocamp.com":         path => "/cdc/scripts/mapfish/mfbase/ext/adapter/ext/ext-base.js";
    "swissrivers.ch":                 path => "/mfbase/ext/adapter/ext/ext-base.js";
    "www.swissrivers.ch":             path => "/mfbase/ext/adapter/ext/ext-base.js";
    "project.camptocamp.com":         path => "/img/next.gif";
    "www.geoext.org":                 path => "/_static/geoext.css";
    "geoext.org":                     path => "/_static/geoext.css";
    "c2cpc49.camptocamp.com":         path => "/_static/geoext.css";
    "trac.geoext.org":                path => "/tracdocs/css/trac.css";
    "128.179.66.26":                  path => "/";
    "sa.camptocamp.com":              path => "/";
  }
}
