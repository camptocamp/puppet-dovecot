class c2c::sudo::workaround {

  file {["/etc/init.d/postgresql-", "/etc/init.d/tomcat-"]:
    ensure => absent,
    owner => root,
    group => root,
    mode => 600,
    content => "Workaround to bypass sudo bug ! See https://bugzilla.redhat.com/show_bug.cgi?id=521778\n",
  }
  
  file {["/etc/init.d/postgresql-fake", "/etc/init.d/tomcat-fake"]:
    ensure => present,
    owner => root,
    group => root,
    mode => 644,
    content => "Workaround to bypass sudo bug ! See https://bugzilla.redhat.com/show_bug.cgi?id=521778\n",
  }

}

