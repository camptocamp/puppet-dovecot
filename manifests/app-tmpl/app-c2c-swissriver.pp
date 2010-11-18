class app-c2c-swissriver {
  apache::vhost-ssl { $fqdn:
    ensure => present,
    group => "sigdev",
    mode => "2775",
    aliases => ["swissrivers.ch", "www.swissrivers.ch"],
  }

  include apache::awstats

  apache::aw-stats {$fqdn:
    ensure => present,
  }

  c2c::checkexternalurl::export {["swissrivers.ch", "www.swissrivers.ch"]:
    path => "/mfbase/ext/adapter/ext/ext-base.js",
    host_name => "check-url-c2c",
  }

  file {"/var/www/download/":
    ensure => directory,
    group  => www-data,
    owner  => www-data,
    mode   => 2775,
  }

  c2c::webdav::user {
    "edric":       vhost => $fqdn, password => 'NvgcvCqEHTUjk';
    "edric_1":     vhost => $fqdn, password => 'gGNixxfqkJCgU';
    "GroupeE":     vhost => $fqdn, password => 'jYc2we6GS2szE';
    "ALPIQ":       vhost => $fqdn, password => 'PehplshAgQItM';
    "SIG":         vhost => $fqdn, password => 'P7wbJJWAwtWIc';
    "NOK":         vhost => $fqdn, password => 'HHyZipYlQTNYk';
    "COLMAR":      vhost => $fqdn, password => 'c0NvLNuNa6aIo';
    "SWISSRIVERS": vhost => $fqdn, password => 'S9iDXfq2erL5E';
    "LAUSANNE":    vhost => $fqdn, password => 'MsDAreuLmxM7Y'; # quai9ohR
    "KWO":         vhost => $fqdn, password => 'wN5t0iVqys6Ak'; # cahHi1da
    "EES":         vhost => $fqdn, password => 'cve9C8N72HLxU'; # suoGu4sh
    "GIH":         vhost => $fqdn, password => 'YiOCx9eKUaZZQ'; # kae4Uwoh
    "GREENACCESS": vhost => $fqdn, password => 'v/hhRYMhTfFWk'; # ohfah4Ei
    "ENERGYPOOL":  vhost => $fqdn, password => '.wVa7bf2ZUkE2'; # quai9ohR
    "EDRIC_2":     vhost => $fqdn, password => 'mJokDaYZbSbg.'; # AF4aepoo
    "ofima":       vhost => $fqdn, password => 'C4pEYcHUX.fUI'; # kie7rohM
  }

  c2c::webdav::share {
#    "tooltips":    ensure => present, vhost => $fqdn, rw_users => "edric",       directory => "/var/www/$fqdn/private/trunk/edric_hydro/edric_hydro/edric_hydro/public";
    "edric_1":     ensure => present, vhost => $fqdn, rw_users => "edric_1",     directory => "/var/www/download/";
    "GroupeE":     ensure => present, vhost => $fqdn, rw_users => "GroupeE",     directory => "/var/www/${fqdn}/private";
    "ALPIQ":       ensure => present, vhost => $fqdn, rw_users => "ALPIQ",       directory => "/var/www/${fqdn}/private";                                                                                                                                            
    "SIG":         ensure => present, vhost => $fqdn, rw_users => "SIG",         directory => "/var/www/${fqdn}/private";                                                                                                                                            
    "NOK":         ensure => present, vhost => $fqdn, rw_users => "NOK",         directory => "/var/www/${fqdn}/private";
    "COLMAR":      ensure => present, vhost => $fqdn, rw_users => "COLMAR",      directory => "/var/www/${fqdn}/private";
    "SWISSRIVERS": ensure => present, vhost => $fqdn, rw_users => "SWISSRIVERS", directory => "/var/www/${fqdn}/private";
    "LAUSANNE":    ensure => present, vhost => $fqdn, rw_users => "LAUSANNE",    directory => "/var/www/${fqdn}/private";
    "KWO":         ensure => present, vhost => $fqdn, rw_users => "KWO",         directory => "/var/www/${fqdn}/private";
    "EES":         ensure => present, vhost => $fqdn, rw_users => "EES",         directory => "/var/www/${fqdn}/private";
    "GIH":         ensure => present, vhost => $fqdn, rw_users => "GIH",         directory => "/var/www/${fqdn}/private";
    "GREENACCESS": ensure => present, vhost => $fqdn, rw_users => "GREENACCESS", directory => "/var/www/${fqdn}/private";
    "ENERGYPOOL":  ensure => present, vhost => $fqdn, rw_users => "ENERGYPOOL",  directory => "/var/www/${fqdn}/private";
    "EDRIC":       ensure => present, vhost => $fqdn, rw_users => "EDRIC",       directory => "/var/www/${fqdn}/private";
    "ofima":       ensure => present, vhost => $fqdn, rw_users => "ofima",       directory => "/var/www/${fqdn}/private";
  }
}
