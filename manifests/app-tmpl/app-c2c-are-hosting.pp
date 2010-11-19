class app-c2c-are-hosting {
  user {["ikiener", "rgiezendanner", "mlanini"]:
    ensure => present,
    groups => ["sigdev","www-data", "admin"],
    shell  => "/bin/bash",
    managehome => true,
  }

  ssh_authorized_key {"isabelle.kiener@are.admin.ch":
    ensure  => present,
    key     => "AAAAB3NzaC1yc2EAAAABJQAAAIEA2EvU0DNAyqcvgPR/sLsMUSd2d7zzHBAaSJ9IUUzLCydaL4shCy5qOjsqBTlreL3x+jsboKu/UjN9pgF6ISbK0d3vhhrD2YtW19gMuupGe9dOeZR2rhLJrBT69MBctSy5Hd8K/xvnZ6LBxtAG58bFFI4tiRXw7QeCFbTfAfnMDz8=",
    type    => "ssh-rsa",
    user    => "ikiener",
    require => User["ikiener"],
  }

  ssh_authorized_key {"rolf.giezendanner@are.admin.ch":
    ensure  => present,
    key     => "AAAAB3NzaC1yc2EAAAABJQAAAIBLl4qZV0RRHSF0SDshUfN3NQSFW+XjP8L3sDN92lYqYLOCjC+zNmXsXYyYqplcCQ3CBDJsIKMRh0sdYpz9+4WISAL5ft0RTqv5U4gIHRmvvhkuSX4857UJxmLYWOmjHa6OpzIUIrBSp0EOFFLwJA18Wclzv41InU75/k3R444RuQ==",
    type    => "ssh-rsa",
    user    => "rgiezendanner",
    require => User["rgiezendanner"],
  }

  ssh_authorized_key {"michael.lanini@are.admin.ch":
    ensure  => present,
    key     => "AAAAB3NzaC1yc2EAAAABJQAAAIEAvXAY/MVJM52/wwexnISzRgs2lQTQRBoMZc0p2r6G2kUoPziuacTJl79ZBDPVmIV7Vg0eyja5AruTlD6cVp4iIcjj77nD1AtpYlfgq2reOtXlfIAnvZsIUgbK3XTQ3K8BSZkRea48EPnjA356I+ckdZIXH06nzUz5cJ43G5fjot8=",
    type    => "ssh-rsa",
    user    => "mlanini",
    require => User["mlanini"],
  }

  package {["phppgadmin","phpmyadmin"]:
    ensure => present,
  }

  apache::vhost {$fqdn:
    ensure => present,
    group  => "sigdev",
    mode   => 2775,
  }

  
  file {"/var/www/$fqdn/conf/phpmyadmin.conf":
    ensure  => absent,
  }
  apache::directive {"phpmyadmin":
    vhost => $fqdn,
    directive => "
Alias /phpmyadmin-wee9Ai /usr/share/phpmyadmin/
<Directory /usr/share/phpmyadmin/>
  Order deny,allow
  Allow from all
</Directory>
",
  }
  file {"/var/www/$fqdn/conf/phppgadmin.conf":
    ensure  => absent,
  }

  apache::directive {"phppgadmin":
    vhost => $fqdn,
    directive => "
Alias /phppgadmin-Sohg5o /usr/share/phppgadmin/
<Directory /usr/share/phppgadmin/>
  Order deny,allow
  Allow from all
  <IfModule mod_php5.c>
    php_flag magic_quotes_gpc Off
    php_flag track_vars On
    php_value include_path .
  </IfModule>
</Directory>
",                                                                                                                                                                                                                                                                   
  }

  file {["/etc/apache2/conf.d/phppgadmin","/etc/apache2/conf.d/phpmyadmin"]:
    ensure => absent,
    notify => Exec["apache-graceful"],
  }


}
