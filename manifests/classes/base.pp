class java {

  $java_version = $lsbdistcodename ? {
    "etch"  => "5",
    "gutsy" => "6",
  }

  package {
    "sun-java${java_version}-bin":    ensure       => present,
                        responsefile => "/var/cache/debconf/sun-java${java_version}-bin.preseed",
                        require      => [Exec["apt-get_update"], File["/var/cache/debconf/sun-java${java_version}-bin.preseed"]];
    "sun-java${java_version}-jdk":    ensure  => present,
                        require => Package["sun-java${java_version}-bin"];
    "sun-java${java_version}-jre":    ensure  => present,
                        require => Package["sun-java${java_version}-bin"];
  }

  case $architecture {
    "i38${java_version}": {
      package {
        "sun-java${java_version}-plugin": ensure => present,
                            require => Package["sun-java${java_version}-bin"];
      }
    }
  }

  # Thanks to Java strange licensing
  file {"/var/cache/debconf/sun-java${java_version}-bin.preseed":
    ensure  => present,
    content => "sun-java${java_version}-bin   shared/accepted-sun-dlj-v1-1    boolean true",
  }

  case $java_version {
    '5' : {
      $jvm = '1.5.0'
      file {"/etc/profile.d/java_home":
        ensure => present,
        content => template("java/java-home.erb"),
        require => File["/etc/profile.d"],
      }
    }
  }
}
