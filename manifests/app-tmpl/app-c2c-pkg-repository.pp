class app-c2c-pkg-repository {

  include reprepro

  file {"/etc/sudoers.d/reprepro":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0440,
    content => "# file managed by puppet\n%reprepro ALL=(reprepro) NOPASSWD: /usr/bin/reprepro, /usr/bin/gpg\n",
  }

  file {"/usr/local/bin/update-repository-list.py":
    ensure => present,
    mode   => 0775,
    source => "puppet:///modules/c2c/usr/local/bin/update-repository-list.py",
  }
  cron {"update-repository-list":
    command => "/usr/local/bin/update-repository-list.py > /var/packages/index.html",
    user    => "reprepro",
    hour    => "*",
    minute  => "*/5",
  }

  c2c::sshuser::sadb {[ 
    "fredj",
    "aabt",
    "pmauduit",
    "sbrunner",
    "mremy",
    "cjeanneret",
    "ckaenzig",
    "mbornoz",
    "marc"]:
    ensure => present,
    groups => "reprepro",
  }

  apache::vhost {"pkg.camptocamp.net":
    ensure  => present,
    group   => "reprepro",
    mode    => "2775",
    require => Group["reprepro"],
  }

  apache::directive {"repository":
    ensure    => present,
    vhost     => "pkg.camptocamp.net",
    directive => '
DocumentRoot /var/packages
<Directory "/var/packages">
  Options Indexes FollowSymLinks MultiViews
  DirectoryIndex index.html
  AllowOverride Options
  Order allow,deny
  allow from all
</Directory>
',
  }

  reprepro::repository {"dev":
    ensure         => present,
    incoming_allow => "lenny squeeze lucid",
  }

  reprepro::repository {["staging","stable","legacy"]:
    ensure => present,
  }

  ############################################################
  ### TEST ENVIRONMENT                                     ###
  ############################################################
  reprepro::distribution {"dev-lenny-backports":
    ensure        => present,
    repository    => "dev",
    codename      => "lenny-backports",
    origin        => "Camptocamp",
    label         => "Camptocamp",
    suite         => "lenny-backports",
    architectures => "i386 amd64 source",
    components    => "main contrib non-free",
    description   => "Camptocamp consolidated lenny-backports dev-repository",
    sign_with     => "packages@camptocamp.com",
    update        => "lenny-backports",
  }

  reprepro::distribution {"dev-lenny":
    ensure        => present,
    repository    => "dev",
    codename      => "lenny",
    origin        => "Camptocamp",
    label         => "Camptocamp",
    suite         => "lenny",
    architectures => "i386 amd64 source",
    components    => "openerp-client sysadmin sig sig-non-free c2corg mapserver-5.6",
    description   => "Camptocamp lenny dev-repository",
    sign_with     => "packages@camptocamp.com",
  }

  reprepro::distribution {"dev-squeeze":
    ensure        => present,
    repository    => "dev",
    codename      => "squeeze",
    origin        => "Camptocamp",
    label         => "Camptocamp",
    suite         => "squeeze",
    architectures => "i386 amd64 source",
    components    => "openerp-client sysadmin sig sig-non-free c2corg mapserver-5.6",
    description   => "Camptocamp squeeze dev-repository",
    sign_with     => "packages@camptocamp.com",
  }

  reprepro::distribution {"dev-lucid":
    ensure        => present,
    repository    => "dev",
    codename      => "lucid",
    origin        => "Camptocamp",
    label         => "Camptocamp",
    suite         => "lucid",
    architectures => "i386 amd64 source",
    components    => "openerp-client sysadmin sig sig-non-free c2corg",
    description   => "Camptocamp lucid dev-repository",
    sign_with     => "packages@camptocamp.com",
  }
 
  reprepro::update {"lenny-backports":
    ensure      => present,
    repository  => "dev",
    url         => 'http://backports.debian.org/debian-backports',
    filter_name => "lenny-backports",
  }

  reprepro::filterlist {"lenny-backports":
    ensure     => present,
    repository => "dev",
    packages   => [
      "collectd install",
      "collectd-core install",
      "collectd-utils install",
      "libcollectdclient0 install",
      "git install",
      "git-email install",
      "gitk install",
      "git-svn install",
      "nagios3 install",
      "nagios3-cgi install",
      "nagios3-common install",
      "nagios3-core install",
      "nagios3-doc install",
      "libproj-dev install",
      "libproj0 install",
      "proj install",
      "proj-bin install",
      "proj-data install",
      "libgeos-3.2.0 install",
      "libgeos-c1 install",
      "libgeos-dev install",
      "augeas-lenses install",
      "augeas-tools install",
      "emacs23-bin-common install",
      "emacs23-common install",
      "emacs23-nox install",
      "libaugeas0 install",
      "libpq-dev install",
      "libpq5 install",
      "postgresql-8.4 install",
      "postgresql-client-8.4 install",
      "postgresql-client-common install",
      "postgresql-common install",
      "postgresql-contrib-8.4 install",
      "postgis install",
      "postgresql-8.4-postgis install",
    ],
  }

 ############################################################
 ### STAGING ENVIRONMENT                                  ###
 ############################################################
  reprepro::distribution {"staging-lenny-backports":
    ensure        => present,
    repository    => "staging",
    codename      => "lenny-backports",
    origin        => "Camptocamp",
    label         => "Camptocamp",
    suite         => "lenny-backports",
    architectures => "i386 amd64 source",
    components    => "main contrib non-free",
    description   => "Camptocamp consolidated lenny-backports staging-repository",
    sign_with     => "packages@camptocamp.com",
    update        => "dev2staging-lenny-backports",
  }

  reprepro::distribution {"staging-lenny":
    ensure        => present,
    repository    => "staging",
    codename      => "lenny",
    origin        => "Camptocamp",
    label         => "Camptocamp",
    suite         => "lenny",
    architectures => "i386 amd64 source",
    components    => "openerp-client sysadmin sig sig-non-free c2corg mapserver-5.6",
    description   => "Camptocamp lenny staging-repository",
    sign_with     => "packages@camptocamp.com",
    update        => "dev2staging-lenny",
  }

  reprepro::distribution {"staging-squeeze":
    ensure        => present,
    repository    => "staging",
    codename      => "squeeze",
    origin        => "Camptocamp",
    label         => "Camptocamp",
    suite         => "squeeze",
    architectures => "i386 amd64 source",
    components    => "openerp-client sysadmin sig sig-non-free c2corg mapserver-5.6",
    description   => "Camptocamp squeeze staging-repository",
    sign_with     => "packages@camptocamp.com",
    update        => "dev2staging-squeeze",
  }

  reprepro::distribution {"staging-lucid":
    ensure        => present,
    repository    => "staging",
    codename      => "lucid",
    origin        => "Camptocamp",
    label         => "Camptocamp",
    suite         => "lucid",
    architectures => "i386 amd64 source",
    components    => "openerp-client sysadmin sig sig-non-free c2corg",
    description   => "Camptocamp lucid staging-repository",
    sign_with     => "packages@camptocamp.com",
    update        => "dev2staging-lucid"
  }

  reprepro::update {
    "dev2staging-lenny-backports": ensure => present, repository  => "staging", url => 'http://pkg.camptocamp.net/dev';
    "dev2staging-lenny":           ensure => present, repository  => "staging", url => 'http://pkg.camptocamp.net/dev';
    "dev2staging-squeeze":         ensure => present, repository  => "staging", url => 'http://pkg.camptocamp.net/dev';
    "dev2staging-lucid":           ensure => present, repository  => "staging", url => 'http://pkg.camptocamp.net/dev';
  }

 ############################################################
 ### STABLE ENVIRONMENT                                   ###
 ############################################################
  reprepro::distribution {"stable-lenny-backports":
    ensure        => present,
    repository    => "stable",
    codename      => "lenny-backports",
    origin        => "Camptocamp",
    label         => "Camptocamp",
    suite         => "lenny-backports",
    architectures => "i386 amd64 source",
    components    => "main contrib non-free",
    description   => "Camptocamp consolidated lenny-backports prod-repository",
    sign_with     => "packages@camptocamp.com",
    update        => "staging2stable-lenny-backports",
  }

  reprepro::distribution {"stable-lenny":
    ensure        => present,
    repository    => "stable",
    codename      => "lenny",
    origin        => "Camptocamp",
    label         => "Camptocamp",
    suite         => "lenny",
    architectures => "i386 amd64 source",
    components    => "openerp-client sysadmin sig sig-non-free c2corg mapserver-5.6",
    description   => "Camptocamp lenny stable-repository",
    sign_with     => "packages@camptocamp.com",
    update        => "staging2stable-lenny",
  }

  reprepro::distribution {"stable-squeeze":
    ensure        => present,
    repository    => "stable",
    codename      => "squeeze",
    origin        => "Camptocamp",
    label         => "Camptocamp",
    suite         => "squeeze",
    architectures => "i386 amd64 source",
    components    => "openerp-client sysadmin sig sig-non-free c2corg mapserver-5.6",
    description   => "Camptocamp squeeze stable-repository",
    sign_with     => "packages@camptocamp.com",
    update        => "staging2stable-squeeze",
  }

  reprepro::distribution {"stable-lucid":
    ensure        => present,
    repository    => "stable",
    codename      => "lucid",
    origin        => "Camptocamp",
    label         => "Camptocamp",
    suite         => "lucid",
    architectures => "i386 amd64 source",
    components    => "openerp-client sysadmin sig sig-non-free c2corg",
    description   => "Camptocamp lucid stable-repository",
    sign_with     => "packages@camptocamp.com",
    update        => "staging2stable-lucid"
  }

  reprepro::update {
    "staging2stable-lenny-backports": ensure => present, repository  => "stable", url => 'http://pkg.camptocamp.net/staging';
    "staging2stable-lenny":           ensure => present, repository  => "stable", url => 'http://pkg.camptocamp.net/staging';
    "staging2stable-squeeze":         ensure => present, repository  => "stable", url => 'http://pkg.camptocamp.net/staging';
    "staging2stable-lucid":           ensure => present, repository  => "stable", url => 'http://pkg.camptocamp.net/staging';
  }

}
