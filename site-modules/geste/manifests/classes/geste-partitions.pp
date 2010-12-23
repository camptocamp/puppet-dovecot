class geste::partitions {
  physical_volume {"/dev/sdb":
    ensure => present,
  }

  volume_group {"vg1":
    ensure => present,
    physical_volumes => "/dev/sdb",
  }

  logical_volume {"home":
    ensure  => present,
    size    => "500G",
    require => Volume_group["vg1"],
    volume_group => "vg1",
  }

  filesystem {"/dev/vg1/home":
    ensure => present,
    fs_type => "ext4",
    require => Logical_volume["home"],
  }

  logical_volume {"computations":
    ensure  => present,
    size    => "6T",
    require => Volume_group["vg1"],
    volume_group => "vg1",
  }

  filesystem {"/dev/vg1/computations":
    ensure  => present,
    fs_type => "ext4",
    require => Logical_volume["computations"],
  }

  logical_volume {"misc":
    ensure  => present,
    size    => "1T",
    require => Volume_group["vg1"],
    volume_group => "vg1",
  }

  filesystem {"/dev/vg1/misc":
    ensure  => present,
    fs_type => "ext4",
    require => Logical_volume["misc"],
  }

  logical_volume {"xapian":
    ensure  => present,
    size    => "15G",
    require => Volume_group["vg1"],
    volume_group => "vg1",
  }

  filesystem {"/dev/vg1/xapian":
    ensure  => present,
    fs_type => "ext4",
    require => Logical_volume["xapian"],
  }

  logical_volume {"opt":
    ensure  => present,
    size    => "5G",
    require => Volume_group["vg1"],
    volume_group => "vg1",
  }

  filesystem {"/dev/vg1/opt":
    ensure  => present,
    fs_type => "ext4",
    require => Logical_volume["xapian"],
  }

  file {
    "/srv/misc":         ensure => directory, owner => root, group => root,   mode => 0755;
    "/srv/computations": ensure => directory, owner => root, group => "aero", mode => 0775;
    "/srv/xapian":       ensure => directory, owner => root, group => root,   mode => 0755;
  }

  mount {
    "/opt":              ensure => mounted, device => "/dev/vg1/opt",    require => Filesystem["/dev/vg1/opt"],    fstype => "ext4", options => "auto,defaults";
    "/home":             ensure => mounted, device => "/dev/vg1/home",   require => Filesystem["/dev/vg1/home"],   fstype => "ext4", options => "auto,defaults";
    "/srv/misc":         ensure => mounted, device => "/dev/vg1/misc",   require => Filesystem["/dev/vg1/misc"],   fstype => "ext4", options => "auto,defaults";
    "/srv/xapian":       ensure => mounted, device => "/dev/vg1/xapian", require => Filesystem["/dev/vg1/xapian"], fstype => "ext4", options => "auto,defaults";
    "/srv/computations": ensure => mounted, device => "/dev/vg1/computations", require => Filesystem["/dev/vg1/computations"], fstype => "ext4", options => "auto,defaults";
  }

}
