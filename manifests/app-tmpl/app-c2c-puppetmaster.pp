# Class for specifics for srv-c2c-puppetmaster
#
# Requires: 
# Provides: 
# Conflicts: 
#

class app-c2c-puppetmaster {

  include puppet::master::passenger
  include mysql::server
  include git-subtree


  package{["xauth"]:  # required by gitk
    ensure => present;
  }

  os::backported_package {["git", "git-email", "gitk"]:
    ensure => latest,
  }

  os::backported_package {"rake":
    ensure => latest,
  }

  c2c::sshuser::sadb {["ckaenzig", "marc", "mbornoz", "cjeanneret", "vrenaville", "mremy", "jbove"]:
    groups  => "sysadmin",
  }

  c2c::sshuser::sadb {"jbaubort":
    ensure => absent,
  }

  common::concatfilepart {"sudoers.sysadmin":
    ensure => present,
    file => "/etc/sudoers",
    content => "## This part is managed by puppet
%sysadmin ALL=(ALL) ALL
##\n",
  }

  apache::vhost-ssl {"pm.camptocamp.net":
    ensure    => present,
    cert      => "/var/lib/puppetmaster/ssl/certs/pm.camptocamp.net.pem",
    certkey   => "/var/lib/puppetmaster/ssl/private_keys/pm.camptocamp.net.pem",
    cacert    => "/var/lib/puppetmaster/ssl/ca/ca_crt.pem",
    certchain => "/var/lib/puppetmaster/ssl/ca/ca_crt.pem",
  }

  file {"/usr/local/bin/puppetstoredconfigclean.rb":
    ensure => present,
    source => "/srv/puppet-source/ext/puppetstoredconfigclean.rb",
    mode   => 755,
  }

  apache::directive {"dashboard-local":
    ensure    => present,
    vhost     => "pm.camptocamp.net",
    directive => "
DocumentRoot /usr/share/puppet-dashboard/public

PassengerStatThrottleRate 120
RackAutoDetect On
RailsAutoDetect On

<Location />
  order deny,allow
  deny from all
  allow from 10.27.10.
  allow from 127.0.0.1
  allow from 128.179.66.9
</Location>

",
  }

  file {"/usr/local/bin/get-sadb-users.rb":
    ensure => present,
    owner  => root,
    group  => root,
    mode   => 0755,
    source => "puppet:///modules/c2c/usr/local/bin/get-sadb-users.rb"
  }


  # Git Subtrees Monitor
  user {"gsm":
    ensure     => present,
    managehome => true,
  }
  file {"/home/gsm/.ssh":
    ensure => directory,
    mode   => 0700,
    owner  => "gsm",
    group  => "gsm",
    require => User["gsm"],
  }
  file {"/home/gsm/.ssh/id_rsa":
    ensure  => present,
    mode    => 0600,
    owner   => "gsm",
    group   => "gsm",
    content => "-----BEGIN RSA PRIVATE KEY-----
MIIEoQIBAAKCAQEAn3L1RWLM4y7L617o61gkMRhiFRigCzkKVvte6UBKCIq+Yy1J
Yw4IW2k/hAaDsWg1Am1lrXprWsbuIyzgbShoaq5iirduh4dU4cBnn5PdllzHxhh8
Us3UsvF/8sVM0YwVVj5ojbL9x4E9i+0LyUEnK1pxe7XOpJk0LTzK1OTJmDlu1vZp
Q831Jst3n6IRe9Dm6w/POotuinRDrgrKrp3AaLosiKpLkFL7GqfPNx6SIl6I9PLs
rZeTM01NmPs9FB2L/rj3+8SRJYFxbT4tJ+cpn5Uj61lU68/i6m6Ymqr3ftMLww2u
zMUtRo5XDovfkeconUz7vYsgxUpN0hQF4U9bzwIBIwKCAQASOQYWjvLYIpr2U/1c
uZ28d9Cx9C+MQQh++CgaqEL5qXTYIm7JffJTlv/x1NvZwsQ6yqyI2spwxkcZ9oAM
eaWIiPVRrpBKANaAMz8K7FPWq4SLqwbk5FLSn0HSmjSqO+UubYhKtV7U+NPVei07
kmrgYhuZHBedyF28BvKb/OPW4c/X8jEbbaAWaj9Y2OUPn6TTSoT+qoWjCXYJkoXz
2f/9KpYukxWJSl2yNjibaD0keyxRIgbgYu17yNYqAbOi/BzNEk5yaqz6Gf0Eb+oW
wfPh9eAhXa6NeGHfCMbDXMCQBWBG12neDL9Ka/aFM6ByJHoMb0Ks27/RdTvQ0gIO
mTqrAoGBAM9SPd0uv/igVreJT09tNZzyKcLS3Iqwypn0m+tQJT6cDk/hlI0y8dhF
E3NPoQa7DaQPQZl7V/Rzi0V/NiWGdaKNfERW+cMWgl0Aa1lJmvI+5/ogAnl4qAIn
U8EJytSpPHLhLRqTlvrLz+C28X7ZKcezUH5l7CZXVRO/ODEjH1BdAoGBAMTjMV5l
DsPCUxXM6O3F5mfAGgCzWtKHFuDlrMtIxQHldzqPjsHsFm7+OeyXrXRoGyEfx5cG
3gDEpLYqNjO7ie1u3IU7pWSCm66F/5OXKyFnhcCnYyQdSohjjgxjdI3pZ452A7Xi
PqivjclKFqTR/jT9LvXvHCwFM26vrkK+c0obAoGAF7Ggq5BQdC+U4caMuJ7ETHNy
fKpiWP5DCkfXThfJvgM01e3lF3OJWouNMb/1JVc0wkri7PgnTyMl3A6J2GcjYwjb
AH73+QnjA1CBTAhpesVcVxmZ4f8pJNFLZoTGuTfpprqmEap3p6JDpKcxitb9deib
fCjnyd4YWgc5nzc2x1sCgYEAv0MaA+0kSSMsI85endYwR4dpt4mor0FmrpX4UHKT
fi9d4R294PP4iRQ4ROsdhwYLuccZqKeV1NxIO+59y9rAgD/O59OKuWjvAU74RjsT
9JBzTW9nn2zpUUrEgRAoFNQbdHKkhM0m7QJPOJEdT6dr+PXzGssFbJdWiMfrHEP6
94cCgYA29zoo6NZWo9bU1swRSBVwdaE9Efh6n3tGmeLYaqK8OvtDLT+XjdFaXyoL
6/yNinXS+FM3fpFWbCkhA/IKohalu0FlKEzkYXlES4rCE5NVHUmaO5KBS70IrlCn
ULbZB/F2TAy82x/tWt7ha7oHE7PgwHbOFgzIn5v3wS1As7LTtQ==
-----END RSA PRIVATE KEY-----
",
  }
  file {"/home/gsm/.ssh/id_rsa.pub":
    ensure  => present,
    mode    => 0644,
    owner   => "gsm",
    group   => "gsm",
    content => "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAn3L1RWLM4y7L617o61gkMRhiFRigCzkKVvte6UBKCIq+Yy1JYw4IW2k/hAaDsWg1Am1lrXprWsbuIyzgbShoaq5iirduh4dU4cBnn5PdllzHxhh8Us3UsvF/8sVM0YwVVj5ojbL9x4E9i+0LyUEnK1pxe7XOpJk0LTzK1OTJmDlu1vZpQ831Jst3n6IRe9Dm6w/POotuinRDrgrKrp3AaLosiKpLkFL7GqfPNx6SIl6I9PLsrZeTM01NmPs9FB2L/rj3+8SRJYFxbT4tJ+cpn5Uj61lU68/i6m6Ymqr3ftMLww2uzMUtRo5XDovfkeconUz7vYsgxUpN0hQF4U9bzw== gsm@c2cpc9
",
  }
  
  file{"/home/gsm/report":
    ensure  => directory,
    owner   => "gsm",
    group   => "gsm",
    require => User["gsm"],
  }
  file{"/var/www/pm.camptocamp.net/htdocs/report":
    ensure => "/home/gsm/report/",
  }

  apache::directive{"alias-git-subtrees-monitor":
    ensure    => present,
    vhost     => "pm.camptocamp.net",
    directive => "Alias /report/ /var/www/pm.camptocamp.net/htdocs/report/"
  }

  cron {"puppet-git-subtrees-monitor":
    ensure  => present,
    command => "/home/gsm/gitsubtreesmonitor.py /srv/puppetmaster/prod /home/gsm/report/report.html",
    hour    => "*/3",
    minute  => "30",
  }
 
}
