class app-c2c-pkg-repository {

  include reprepro

  file {"/etc/sudoers.d/reprepro":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0440,
    content => "# file managed by puppet\n%reprepro ALL=(reprepro) NOPASSWD: /usr/bin/reprepro, /usr/bin/gpg\n",
  }

  c2c::sshuser::sadb {[ 
    "fredj",
    "aabt",
    "pmauduit",
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

  reprepro::repository {"dev":
    ensure         => present,
    incoming_allow => "lenny squeeze lucid",
  }

  reprepro::repository {["staging","prod","legacy"]:
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
    components    => "openerp-client puppet puppet-0.25 sysadmin sig sig-non-free c2corg",
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
    components    => "openerp-client puppet puppet-0.25 sysadmin sig sig-non-free c2corg",
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
    components    => "openerp-client puppet puppet-0.25 sysadmin sig sig-non-free c2corg",
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
      "git install",
      "git-email install",
      "gitk install",
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
    components    => "openerp-client puppet puppet-0.25 sysadmin sig sig-non-free c2corg",
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
    components    => "openerp-client puppet puppet-0.25 sysadmin sig sig-non-free c2corg",
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
    components    => "openerp-client puppet puppet-0.25 sysadmin sig sig-non-free c2corg",
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
 ### PRODUCTION ENVIRONMENT                               ###
 ############################################################
  reprepro::distribution {"prod-lenny-backports":
    ensure        => present,
    repository    => "prod",
    codename      => "lenny-backports",
    origin        => "Camptocamp",
    label         => "Camptocamp",
    suite         => "lenny-backports",
    architectures => "i386 amd64 source",
    components    => "main contrib non-free",
    description   => "Camptocamp consolidated lenny-backports prod-repository",
    sign_with     => "packages@camptocamp.com",
    update        => "staging2prod-lenny-backports",
  }

  reprepro::distribution {"prod-lenny":
    ensure        => present,
    repository    => "prod",
    codename      => "lenny",
    origin        => "Camptocamp",
    label         => "Camptocamp",
    suite         => "lenny",
    architectures => "i386 amd64 source",
    components    => "openerp-client puppet puppet-0.25 sysadmin sig sig-non-free c2corg",
    description   => "Camptocamp lenny prod-repository",
    sign_with     => "packages@camptocamp.com",
    update        => "staging2prod-lenny",
  }

  reprepro::distribution {"prod-squeeze":
    ensure        => present,
    repository    => "prod",
    codename      => "squeeze",
    origin        => "Camptocamp",
    label         => "Camptocamp",
    suite         => "squeeze",
    architectures => "i386 amd64 source",
    components    => "openerp-client puppet puppet-0.25 sysadmin sig sig-non-free c2corg",
    description   => "Camptocamp squeeze prod-repository",
    sign_with     => "packages@camptocamp.com",
    update        => "staging2prod-squeeze",
  }

  reprepro::distribution {"prod-lucid":
    ensure        => present,
    repository    => "prod",
    codename      => "lucid",
    origin        => "Camptocamp",
    label         => "Camptocamp",
    suite         => "lucid",
    architectures => "i386 amd64 source",
    components    => "openerp-client puppet puppet-0.25 sysadmin sig sig-non-free c2corg",
    description   => "Camptocamp lucid prod-repository",
    sign_with     => "packages@camptocamp.com",
    update        => "staging2prod-lucid"
  }

  reprepro::update {
    "staging2prod-lenny-backports": ensure => present, repository  => "prod", url => 'http://pkg.camptocamp.net/staging';
    "staging2prod-lenny":           ensure => present, repository  => "prod", url => 'http://pkg.camptocamp.net/staging';
    "staging2prod-squeeze":         ensure => present, repository  => "prod", url => 'http://pkg.camptocamp.net/staging';
    "staging2prod-lucid":           ensure => present, repository  => "prod", url => 'http://pkg.camptocamp.net/staging';
  }

}
