class app-c2c-peitrequin-hosting {
  c2c::ssh_authorized_key {
    "ebelo on admin":    user => "admin", sadb_user => "ebelo";
    "ochriste on admin": user => "admin", sadb_user => "ochriste";
    "fredj on admin":    user => "admin", sadb_user => "fredj";
    "yves on admin":     user => "admin", sadb_user => "yves";
    "alex on admin":     user => "admin", sadb_user => "alex";
    "yjacolin on admin": user => "admin", sadb_user => "yjacolin";
    "aabt on admin":     user => "admin", sadb_user => "aabt";
  }

  apache::vhost {[
    "coppet.geocommunes.ch",
    "arzier.geocommunes.ch",
    "crans.geocommunes.ch",
    "trelex.geocommunes.ch",
    "genolier.geocommunes.ch",
    "common.geocommunes.ch",
    ]:
    ensure => present,
    mode   => 2775,
    group  => "sigdev",
  }

  group {"sigdev":
    ensure => present,
  }

  tomcat::instance {"printing":
    ensure => present,
    group  => sigdev,
  }

  apt::sources_list {"mapserver-5.6":
    ensure => present,
    content => "deb http://pkg.camptocamp.net/legacy lenny mapserver-5.6\n"
  }

  apt::preferences {
    #"libgdal1-1.7.0":   priority => 1100, pin => "release o=ptocamp";
    "gdal-bin":         priority => 1100, pin => "release o=c2c";
    "python-gdal":      priority => 1100, pin => "release o=c2c";
    "mapserver-bin":    priority => 1100, pin => "release o=c2c";
    "cgi-mapserver":    priority => 1100, pin => "release o=c2c";
    "perl-mapscript":   priority => 1100, pin => "release o=c2c";
    "php5-mapscript":   priority => 1100, pin => "release o=c2c";
    "python-mapscript": priority => 1100, pin => "release o=c2c";
  }

  cron {"update carto":
    ensure  => present,
    command => "python /var/www/common.geocommunes.ch/private/trunk/peitrequin_common/script/data_postprocessing.py -s",
    hour    => 4,
    minute  => 0,
    user    => "admin",
    environment => 'MAILTO="peitrequin_update@camptocamp.com"',
  }

  apache::module {["dav", "dav_fs"]: }

  c2c::webdav::user {"peitrequin_data":
    vhost => "common.geocommunes.ch",
    password => "9pMcWOvnetIjM", # Copi5zos0f
  }

  c2c::webdav::share {
    "peitrequin_arzier":   vhost => "common.geocommunes.ch", rw_users => "peitrequin_data", mode => 2775;
    "peitrequin_coppet":   vhost => "common.geocommunes.ch", rw_users => "peitrequin_data", mode => 2775;
    "peitrequin_crans":    vhost => "common.geocommunes.ch", rw_users => "peitrequin_data", mode => 2775;
    "peitrequin_trelex":   vhost => "common.geocommunes.ch", rw_users => "peitrequin_data", mode => 2775;
    "peitrequin_genolier": vhost => "common.geocommunes.ch", rw_users => "peitrequin_data", mode => 2775;
  }

}
