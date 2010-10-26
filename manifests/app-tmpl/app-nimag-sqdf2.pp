class app-nimag-sqdf2 {

  include mysql::server

  user {"osubilia":
    ensure => present,
    shell  => "/bin/bash",
    home   => "/home/osubilia",
    groups => "www-data",
    managehome => true,
  }

  ssh_authorized_key {"olivier.subilia@avocats-ch.ch":
    ensure => present,
    user   => "osubilia",
    type   => "ssh-rsa",
    key    => "AAAAB3NzaC1yc2EAAAABIwAAAQEA0ceIdQBMkyvmrqYHY9OA4hOcsQekIr6aMh3jxpaGGHatZgcPN7Pe3vXC5ivLidlKVuDcfY3eDEywEMQpo+H+gdjsMvrs/k+vOziXQegtQ1OCo5mhmP1nByeG9joRQErHYGrEZfxdh9wz52j44OubEWsD/6Sw01GSDnU2G34/Q0Zdx/4knll/qpoEKqHFP1CfgZqsWmquZALP02s97cNPg8Yzya+unk7X149Pr0aiP4LNIWvwej8wFi+P/i6DwGNAtx/jOsBFkdBHhn6M77+I3NSY95V2c1gyocsXR3T1scBu34IYRGT3q7Whv1uMJwpquPgTitTVV01moFI4rviX7Q==",
  }
}
