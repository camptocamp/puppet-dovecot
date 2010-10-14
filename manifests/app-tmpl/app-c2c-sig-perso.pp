class app-c2c-sig-perso {

  include app-c2c-sig-dev
  common::concatfilepart {"sigdev on root":
    ensure => present,
    file   => "/etc/sudoers",
    content => "%sigdev ALL=(ALL) NOPASSWD: /bin/su, /bin/su -\n",
  }
}
