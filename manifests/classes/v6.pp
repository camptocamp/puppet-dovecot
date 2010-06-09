class java::v6 {

  case $lsbdistcodename {
    'etch' : {
      os::backported_package { 
        "sun-java6-bin":    
          ensure       => present,
          responsefile => "/var/cache/debconf/sun-java6-bin.preseed",
          require      => [Exec["apt-get_update"], File["/var/cache/debconf/sun-java6-bin.preseed"]];
        "sun-java6-jdk":    
          ensure  => present,
          require => Package["sun-java6-bin"];
        "sun-java6-jre":    
          ensure  => present,
          require => Package["sun-java6-bin"];
      }
    }
    'hardy',
    'intrepid',
    'jaunty',
    'lucid',
    'lenny' : {
      package { 
        "sun-java6-bin":
          ensure       => present,
          responsefile => "/var/cache/debconf/sun-java6-bin.preseed",
          require      => [Exec["apt-get_update"], File["/var/cache/debconf/sun-java6-bin.preseed"]];
        "sun-java6-jdk":
          ensure => present,
          require => Package["sun-java6-bin"];
        "sun-java6-jre":
          ensure  => present,
          require => Package["sun-java6-bin"];
      }
    } 
  }

  # Thanks to Java strange licensing
  file {"/var/cache/debconf/sun-java6-bin.preseed":
    ensure  => present,
    content => "sun-java6-bin   shared/accepted-sun-dlj-v1-1    boolean true",
  }

  $jvm = '6'
  file {"/etc/profile.d/java_home":
    ensure => present,
    content => template("java/java-home.erb"),
  }
  
  case $operatingsystem {
    'Debian','RedHat': {
      # Update java alternatives
      # See ticket #11173
      exec {"update-java-alternatives --set java-6-sun":
        unless => 'test $(readlink /etc/alternatives/java) == "/usr/lib/jvm/java-6-sun/jre/bin/java"',
        require => Package["sun-java6-bin"],
      }
    }
  }
}
