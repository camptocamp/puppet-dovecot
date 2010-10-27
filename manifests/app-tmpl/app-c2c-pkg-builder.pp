class app-c2c-pkg-builder {

  # Ressources needed to build some packages
  include java


  # Build environment
  
  include buildenv::deb

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
    groups => "admin",
  }

  package {["cowbuilder","git-buildpackage","pbuilder"]:
    ensure => present,
  }

  file {"/etc/git-buildpackage/gbp.conf":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0644,
    require => Package["git-buildpackage"],
    content => "# file managed by puppet
[DEFAULT]
builder = /usr/bin/git-pbuilder
cleaner = fakeroot debian/rules clean
pristine-tar = True

[git-buildpackage]
export-dir = ../build-area/

[git-dch]
git-author = True
",
  }

  file {"/etc/dput.cf":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0644,
    content => "# file managed by puppet
[dev.camptocamp.com]
allow_unsigned_uploads = 0
allow_unsigned_uploads = 0
fqdn = dev.camptocamp.com
incoming = /var/lib/debarchiver/incoming/

[pkg.camptocamp.net-dev]
allow_unsigned_uploads = 0
fqdn = pkg.camptocamp.net
incoming = /var/packages/dev/incoming
post_upload_command = ssh pkg.camptocamp.net 'sudo -u reprepro /usr/bin/reprepro -b /var/packages/dev processincoming incoming'
",
  }

  file {"/etc/pbuilderrc":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0644,
    content => "# file managed by puppet
DEBBUILDOPTS=\"-sa\"
unset DEBOOTSTRAPOPTS
",
  }

  file {"/etc/sudoers.d/package-builder":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0440,
    content => "# file managed by puppet
Defaults      !authenticate
%admin ALL=(root) SETENV: /usr/sbin/cowbuilder
%admin ALL=(root) /usr/bin/git-pbuilder
"}

  file {"/usr/local/bin/git-pbuilder-update.sh":
    ensure => present,
    owner  => root,
    group  => root,
    mode   => 775,
    source => "puppet:///c2c/usr/local/bin/git-pbuilder-update.sh",
  }

}
