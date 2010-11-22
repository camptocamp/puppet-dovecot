class app-mapfish-trac {
  include subversion
  include apache::awstats

  include trac
  include trac::accountmanager

  file {"/srv/svn/repos":
    ensure => directory,
    owner => root,
    group => root,
    mode  => 0755,
  }

  trac::vhost-ssl-modpython {"trac.mapfish.org":
    ensure  => present,
    project => 'mapfish'
  }

  trac::default {"mapfish":
    vhost => "trac.mapfish.org"
  }

  c2c::trac-project {"mapfish":
    ensure      => present,
    description => "MapFish",
    url         => "https://trac.mapfish.org/trac/mapfish",
    cc          => "cedric.moullet@camptocamp.com",
    vhostname   => "trac.mapfish.org",
  }

  exec {"upgrade setuptools":
    command => "easy_install -U setuptools",
    unless  => "grep -q setuptools /usr/lib/python2.5/site-packages/easy-install.pth",
  }
  exec {"install trac tocmacro":
    command => "easy_install http://trac-hacks.org/svn/tocmacro/0.11",
    unless  => "grep -q TracTocMacro /usr/lib/python2.5/site-packages/easy-install.pth",
    require => Exec["upgrade setuptools"],
  }


  file {"/srv/svn/repos/mapfish/hooks/post-commit":
    ensure  => present,
    source  => "puppet:///c2c/srv/svn/repos/mapfish/hooks/post-commit",
    owner   => www-data,
    group   => www-data,
    mode    => 0755,
    require => [User["www-data"],Group["www-data"],Package["subversion"]],
  }

  file {"/srv/svn/repos/mapfish/hooks/trac-post-commit-hook":
    ensure  => present,
    source  => "puppet:///c2c/srv/svn/repos/mapfish/hooks/trac-post-commit-hook",
    owner   => www-data,
    group   => www-data,
    mode    => 0755,
    require => [User["www-data"],Group["www-data"],Package["subversion"]],
  }

  apache::vhost {"svn.mapfish.org":
    ensure => present,
    group  => www-data,
    mode   => 2770,
  }

  file {"/var/www/svn.mapfish.org/conf/svn.conf":
    ensure => absent,
  }

  apache::directive {"svn":
    ensure => present,
    vhost  => "svn.mapfish.org",
    require => File["/var/www/svn.mapfish.org/conf/svn.conf"],
    directive => "<Location /svn/mapfish>
  DAV svn
  SVNPath /srv/svn/repos/mapfish
  
  AuthzSVNAccessFile /srv/svn/repos/mapfish/conf/svnaccess.conf
  
  AuthType Basic
  AuthName \"Subversion\"
  AuthUserFile /srv/trac/projects/mapfish/conf/htpasswd
  
  <LimitExcept GET PROPFIND OPTIONS REPORT>
    #SSLRequireSSL Not working
    Require valid-user
  </LimitExcept>
</Location>
",
  }
    

  user {"admin":                                                                                                                                                                                                                                                     
    ensure      => present,
    managehome  => true,
    groups      => "www-data",
    shell       => "/bin/bash",
  }

  apache::vhost {"lists.mapfish.org":
    ensure  => present,
    group   => "admin",
    mode    => "2775",
    require => User["admin"],
  }

  apache::redirectmatch{"mailman-home":
    ensure => present,
    vhost  => "lists.mapfish.org",
    regex  => "^/$",
    url    => "/mailman/listinfo",
  }

  apache::aw-stats{"lists.mapfish.org":
    ensure => present,
  }

  ## SSH Access

  c2c::ssh_authorized_key { "frederic.junod@camptocamp.com on admin":
    sadb_user => "fredj",
    user      => "admin",
  }

  c2c::ssh_authorized_key { "frederic.junod@camptocamp.com on root":
    sadb_user => "fredj",
    user      => "root",
  }

  c2c::ssh_authorized_key { "eric.lemoine@camptocamp.com on admin":
    sadb_user => "elemoine",
    user      => "admin",
  }

  c2c::ssh_authorized_key { "cedric.moullet@camptocamp.com on admin":
    sadb_user => "cmoullet",
    user      => "admin",
    ensure    => absent,
  }

  c2c::ssh_authorized_key { "oliver.christen@camptocamp.com on admin":
    sadb_user => "ochriste",
    user      => "admin",
  }

  c2c::ssh_authorized_key { "yves.bolognini@camptocamp.com on admin":
    sadb_user => "yves",
    user      => "admin",
  }

  c2c::ssh_authorized_key { "thomas.bonfort@camptocamp.com on admin":
    sadb_user => "tbonfort",
    user      => "admin",
  }

  c2c::ssh_authorized_key { "bruno.binet@camptocamp.com on admin":
    sadb_user => "bbinet",
    user      => "admin",
  }

  c2c::ssh_authorized_key { "jesse.eichar@camptocamp.com on admin":
    sadb_user => "jeichar",
    user      => "admin",
  }

  include mailman
  include postfix::mailman

  mailman::instance {"mapfish.org":
    vhost => "lists.mapfish.org",
    urlpath => "/mailman/",
  }

  maillist {"users":
    ensure => present,
    admin => "eric.lemoine@camptocamp.com",
    password => 'ree2tahG',
    description => 'MapFish users list',
    provider => mailman,
  }

  maillist {"dev":
    ensure => present,
    admin => "eric.lemoine@camptocamp.com",
    password => 'ree2tahG',
    description => 'MapFish developper list',
    provider => mailman,
  }

  maillist {"commits":
    ensure => present,
    admin => "eric.lemoine@camptocamp.com",
    password => 'ree2tahG',
    description => 'MapFish commits lists',
    provider => mailman,
  }

  mailman::config {
    "set member_moderation_action on users"  : ensure => present, variable => "member_moderation_action", value => "2", mlist => "users";
    "set generic_nonmember_action on users"  : ensure => present, variable => "generic_nonmember_action", value => "3", mlist => "users";
    "set member_moderation_action on dev"    : ensure => present, variable => "member_moderation_action", value => "2", mlist => "dev";
    "set generic_nonmember_action on dev"    : ensure => present, variable => "generic_nonmember_action", value => "3", mlist => "dev";
    "set member_moderation_action on commits": ensure => present, variable => "member_moderation_action", value => "2", mlist => "commits";
    "set generic_nonmember_action on commits": ensure => present, variable => "generic_nonmember_action", value => "3", mlist => "commits";
  }
}
