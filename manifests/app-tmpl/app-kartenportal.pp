class app-kartenportal {

  user {"admin":
    ensure     => present,
    shell      => "/bin/bash",
    home       => "/home/admin",
    managehome => true,
  }

  lighttpd::vhost{ $fqdn:
    ensure  => present,
    aliases => ["kartenportal.mapranksearch.com"],
    group   => admin,
    require => User["admin"],
  }

  c2c::sshuser {"klokan":
    ensure  => present,
    comment => "Petr Pridal",
    email   => "petr.pridal@klokantech.com",
    type    => "ssh-rsa",
    key     => "AAAAB3NzaC1yc2EAAAABIwAAAIEAvuiJlmtzTqTTKHDVJGeWx3j6pVVebABd4gVmrk1dTS81xUG70Ml8Wb2r7TFoYsE+RRSIaId2eyv5OMqGxUpZ6ehvS0jWrkQfim0gkz4N/d9QOmQq/Rp4MUAROymhHQ7SUcj8ogPr6IBKtr5cm3l2yMSb3isKFR9TMJYaHAFb/0E=",
    groups  => "admin",
    uid     => 1001,
    require => User["admin"],
  }

  c2c::sshuser {"keo":
    ensure  => present,
    comment => "Vaclav Klusak",
    email   => "vaclav.klusak@klokantech.com",
    type    => "ssh-rsa",
    key     => "AAAAB3NzaC1yc2EAAAABIwAAAQEAwNh7DwFyVDUK1aCNHOnTVgCsBiDYSrokLHhDT5K9yTePGlHnEuH1EIOcuxnrlWTSjZG1epL7Sh6YxW6EfAemF2hDCbj4pgRRycw+RIvw1AzgofK2oVyVL8DJxFWqAofI5IW30EwkgPL9bKWbt47P1fsQDJsvnWjTQncoVGQ3x/ExEaA9HUC8HPKrvak7/OZWkD5gexRjgdLktD8VJcvgFdtb82BCc8Q8kZfQzvikmk9LZM6/XF4CRmg07fVXRqzEbHka9NBfR58G092C9ETHAcPZlnPptm1w1nwD1RDxqMFodjxLpfAVml9ud5UsA6ZUaxOL5vkM2nD8RREif6f/4Q==",
    groups  => "admin",
    uid     => 1002,
    require => User["admin"],
  }
}
