class geste::baseconfig {
  augeas {"disable password for ssh":
    context => "/files/etc/ssh/sshd_config",
    changes => [
      "set ChallengeResponseAuthentication no",
      "set PasswordAuthentication no"],
    notify => Service["ssh"],
  }

  augeas {"enable password only for molteni and mossi":
    context => "/files/etc/ssh/sshd_config",
    changes => [
      "set Match/Condition/User mossi,molteni",
      "set Match/Settings/PasswordAuthentication yes",
      "set Match/Settings/KbdInteractiveAuthentication yes",
      ],
    notify  => Service["ssh"],
  }

  file {"/root/.ssh/id_rsa-ldapsync":
    ensure => present,
    owner  => root,
    group  => root,
    mode   => 0600,
    source => "puppet:///modules/geste/ldap/id_rsa-ldapsync",
  }

  file {"/root/.ssh/id_rsa-ldapsync.pub":
    ensure => present,
    owner  => root,
    group  => root,
    mode   => 0644,
    source => "puppet:///modules/geste/ldap/id_rsa-ldapsync.pub",
  }

  ssh_authorized_key {"ldapsync":
    ensure => present,
    user   => root,
    type   => "ssh-rsa",
    key    => "AAAAB3NzaC1yc2EAAAABIwAAAQEAu85Wq5+LKR6yLMyvb617ckAUg/wSlab8zCKL0dKG0PdsX6fKVvnrxtPHJT0Jw3zjgL7eXNMF6u3HBpiovtxawXtN0iTso+k20GsYmh63i6xU/KgN27PHsZnBKu5FexypOvlLsl0H78g52IPjgNuhBsLXeG3NVsg1lXkjqt4C/vz7jLiINB5AIxDou2wZYdX7cnJoNESg9LpFEPyRmGjNid2dZeYulfRBKhBmWxu1+apfPMa/lyt7mFpRNUNapFd74bqj04K/ITQUsimjSuc5PwMIwwanvcV6uekSNoGCvo7NXxUj18sj7KIbaCmj0F41mijXGPyVmTzprfwfuQdcbQ==",
  }

  include dell::openmanage
}
