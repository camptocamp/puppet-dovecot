class app-c2c-openaddresses {

  include apache::awstats
  include apache::administration
  include postgresql::administration

  apache::aw-stats {$fqdn:
    ensure => present,
  }

  user {"admin":
    ensure     => present,
    managehome => true,
    shell      => "/bin/bash",
 }

  apt::sources_list {"mapserver-5.6":
    ensure => present,
    content => "deb http://dev.camptocamp.com/packages lenny mapserver-5.6\n"
  }

  c2c::ssh_authorized_key {
    "yves on admin":     require => User["admin"], user => "admin", sadb_user => "yves";
    "cmoullet on admin": require => User["admin"], user => "admin", sadb_user => "cmoullet", ensure => absent;
    "fredj on admin":    require => User["admin"], user => "admin", sadb_user => "fredj";
  }

  ssh_authorized_key {"cedric.moullet@swisstopo.ch":
    ensure => present,
    user   => "admin",
    type   => "ssh-rsa",
    key    => "AAAAB3NzaC1yc2EAAAABIwAAAQEAyMr/oIzX/IY6hw/GfZz74R9C5eKsfaVzyxxAqE9Qp/Z3cUpLE5WhvmDVYhYqsVLrb6wXYjhdfTm6bZ/XWhohduEq/Cb+q8KJ8wpI1yQ5SHlF37boc0f7BGvfzFyb7aamgQlNMQlwTRa5Xs/LkGCXMlDXVRpjW0QeGQgUXiKTY4/dYF5HePD3y6hpwScRaJUshTuRv95S50nd1F/WntTOwgGhajZ3vrUKtpV+GlcgvoXTSxnndTno+0n+9P8b31HniYcxvqup1Yr8HFM/MhDGo09mO/ZmFCg9DK2xOUx9nasmz3Fi75b/Snn+Ha5hJyor/4rTsVsWwV5z37a6eN8Mow==",
  }
    

  c2c::ssh_authorized_key {
    "fredj on root":    ensure => absent, require => User["admin"], user => "root", sadb_user => "fredj";
  }

  apache::vhost {"$fqdn":
    ensure => present,
    group  => admin,
    require => User["admin"],
    aliases => [
      "www.openaddresses.org", 
      "www.openaddress.org", 
      "openaddresses.org", 
      "openaddress.org",
      "www.openaddresmap.org",
      "openaddressmap.org"],
  }

  common::concatfilepart {"00-base":
    ensure => absent,
    file => "/etc/sudoers",
    content => "# managed by puppet - 00-base
Defaults    env_keep=SSH_AUTH_SOCK
Defaults    !authenticate
Defaults    env_reset
Defaults    always_set_home
root  ALL=(ALL) ALL
",
  }
  common::concatfilepart {"01-admin":
    ensure => absent,
    file => "/etc/sudoers",
    content => "# managed by puppet - 01-admin
admin ALL=(ALL) /etc/init.d/apache2, /etc/init.d/postgresql*, /usr/sbin/apache2ctl, /bin/su - postgres, /bin/su postgres
",
  }

  monitoring::check {"App: REST":
    ensure   => present,
    codename => "check_oa_rest",
    command  => "check_http",
    options  => '-H www.openaddresses.org -u "/addresses/?limit=1&attrs=street,housenumber,city&query=Gen%E8ve%20Vogt"',
    type     => "remote",
    server   => $nagios_nsca_server,
  }
}
