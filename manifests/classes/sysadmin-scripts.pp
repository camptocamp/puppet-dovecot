class c2c::sysadmin-scripts {
  file { "/usr/local/bin/":
    source => "puppet:///c2c/usr/local/bin/",
    recurse => true
  } 

  file { "/usr/local/sbin/":
    source => "puppet:///c2c/usr/local/sbin/",
    recurse => true
  } 
}
