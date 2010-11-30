class app-c2c-mapfish-www {
  ## Additional packages
  package{["python-sphinx","mercurial"]:
    ensure => latest,
  }

  group {"admin":
    ensure => present,
  }
  
  user {"admin":
    ensure      => present,
    managehome  => true,
    groups      => "www-data",
    shell       => "/bin/bash",
  }

  c2c::ssh_authorized_key { 
    "frederic.junod@camptocamp.com on admin":  sadb_user => "fredj",    user => "admin";
    "frederic.junod@camptocamp.com on root":   sadb_user => "fredj",    user => "root";
    "eric.lemoine@camptocamp.com on admin":    sadb_user => "elemoine", user => "admin";
    "cedric.moullet@camptocamp.com on admin":  sadb_user => "cmoullet", user => "admin", ensure => absent;
    "oliver.christen@camptocamp.com on admin": sadb_user => "ochriste", user => "admin";
    "yves.bolognini@camptocamp.com on admin":  sadb_user => "yves",     user => "admin";
    "thomas.bonfort@camptocamp.com on admin":  sadb_user => "tbonfort", user => "admin", ensure => absent;
    "bruno.binet@camptocamp.com on admin":     sadb_user => "bbinet",   user => "admin";
    "jesse.eichar@camptocamp.com on admin":    sadb_user => "jeichar",  user => "admin";
   "pierre.mauduit@camptocamp.com on admin":   sadb_user => "pmauduit", user => "admin";
  }


  include apache::awstats

  apache::vhost {"www.mapfish.org":
    ensure  => present,
    group   => "admin",
    mode    => "2775",
    aliases => ["mapfish.org"],
    require => User["admin"],
  }

  apache::aw-stats{"www.mapfish.org":
    ensure => present,
  }

  apache::vhost {"demo.mapfish.org":
    ensure => present,
    group  => "admin",
    mode   => "2775",
    require => User["admin"],
  }

  apache::vhost {"dev.mapfish.org":
    ensure => present,
    group  => "admin",
    mode   => "2775",
    require => User["admin"],
  }
  apache::aw-stats{"dev.mapfish.org":
    ensure => present,
  }

  apache::vhost {"localhost":
    ensure => present,
    group  => "admin",
    mode   => "2775",
    aliases => "127.0.0.1",
    require => User["admin"],
  }

  apache::vhost {"www.geoalchemy.org":
    ensure => present,
    group => "admin",
    mode    => "2775",
    aliases => ["geoalchemy.org"],
    require => User["admin"],
  }

  ## Subversion ProxyPass

  file {"/var/www/www.mapfish.org/conf/proxypass-subversion.conf":
    ensure => absent,
  }

  apache::directive {"subversion-proxypass":
    ensure => present,
    require => File["/var/www/www.mapfish.org/conf/proxypass-subversion.conf"],
    vhost => "www.mapfish.org",
    directive => "<Proxy *>
        Order deny,allow
        Allow from all
</Proxy>

ProxyPass /svn http://svn.mapfish.org/svn/
ProxyPassReverse /svn http://svn.mapfish.org/svn/

<Location /svn >
  <Limit OPTIONS PROPFIND GET REPORT MKACTIVITY PROPPATCH PUT CHECKOUT MKCOL MOVE COPY DELETE LOCK UNLOCK MERGE>
    Order Deny,Allow
    Allow from all
    Satisfy Any
  </Limit>
</Location>
",
  }

  cron {"mapfish-deploy":
    ensure  => present,
    command => "cd /var/www/demo.mapfish.org/private/trunk && sh ./deploy-mapfishsample.sh -u >> /var/www/demo.mapfish.org/private/trunk/log.txt 2>&1",
    minute  => 0,
    user => admin,
  }
  cron {"mapfish-nightly":
    ensure  => "present",
    command => "/var/www/www.mapfish.org/private/scripts/nightly.sh >> /var/www/www.mapfish.org/private/nightly_logs/nightly.daily.log.txt 2>&1",
    hour    => 0,
    minute  => 0,
    user    => admin,
  }
  cron {"mapfish-daily":
    ensure  => present,
    command => "/var/www/www.mapfish.org/private/scripts/make_apidoc.sh /var/www/www.mapfish.org/htdocs/apidoc/ trunk >> /var/www/www.mapfish.org/private/make_apidoc_logs/apidoc.daily.log.txt 2>&1",
    hour    => 6,
    minute  => 0,
    user    => admin,
  }
  
  cron {"update svn":
    ensure  => present,
    command => "/home/admin/bin/svn-up.sh",
    minute  => "*/30",
    user    => admin,
    require => File["/home/admin/bin/svn-up.sh"],
    environment => "MAILTO=eric.lemoine@camptocamp.com",
  }
  
  file {"/home/admin/bin":
    ensure  => directory,
    owner   => admin,
    group   => admin,
    mode    => 0755,
    require => User["admin"],
  }
  
  file {"/home/admin/bin/svn-up.sh":                                                                                                                                                                                                                                 
    ensure => present,
    owner  => admin,
    group  => admin,
    mode   => 0755,
    require => File["/home/admin/bin"],
    replace => false,
    content => '#!/bin/bash
export PATH="/usr/bin:/bin:/sbin:/usr/sbin"
repository="/var/www/dev.mapfish.org/htdocs/sandbox"
svn cleanup $repository
svn up -q $repository
exit $?
',
  }

  exec {"make postgresql listen on all interfaces":
    command => "echo \"listen_addresses = '*'\" >> /etc/postgresql/8.3/main/postgresql.conf",
    unless => "grep -q \"listen_addresses = '\\*'\" /etc/postgresql/8.3/main/postgresql.conf",
  }

  # ceci est requis pour les developpeurs qui doivent 
  # pouvoir se connecter a la base studio depuis leur environement de dev.
  # pour effectuer des tests unitaires avant de commiter 
  postgresql::user{ "studio":
    ensure      => present,
    password    => "SufahN5C",
  }                                                                                                                                                                                                                                                                  

  # user readonly
  postgresql::user{ "quickstart":
    ensure      => present,
    password    => "quickstart",
  }

  line {"pg access for user quickstart from anywhere":
    line   => "host    quickstart  quickstart  0.0.0.0/0             md5",
    ensure => present,
    file   => "/etc/postgresql/8.3/main/pg_hba.conf",
    require => Package["postgresql-8.3"],
  }

  line {"pg access for user studio from wrk.lsn":
    line   => "host    studio      studio      10.27.10.0/24         md5",
    ensure => present,
    file   => "/etc/postgresql/8.3/main/pg_hba.conf",
    require => Package["postgresql-8.3"],
  }

  line {"pg access for user studio from wrk.cby":
    line   => "host    studio      studio      10.26.10.0/24         md5",
    ensure => present,
    file   => "/etc/postgresql/8.3/main/pg_hba.conf",
    require => Package["postgresql-8.3"],
  }

  line {"pg access for user studio from int.lsn":
    line   => "host    studio      studio      10.26.20.0/24         md5",
    ensure => present,
    file   => "/etc/postgresql/8.3/main/pg_hba.conf",
    require => Package["postgresql-8.3"],
  }

  line {"pg access for user studio direct from dev.mapfish.org":
    line    => "host    studio      studio      128.179.66.33/32      md5",
    ensure => present,
    file   => "/etc/postgresql/8.3/main/pg_hba.conf",
    require => Package["postgresql-8.3"],
  }

  tomcat::instance {"mapfishprint":
    ensure => present,
    group  => admin,
  }

}
