class mw-lamp {
  include mysql::server
  
  package {
    [ 
      "php5-common",
      "php5-cli",
      "php5-gd",
      "libapache2-mod-php5",
      "php5-curl",
      "php5-mysql"
    ]: ensure => present,
  }
  
  file {"/etc/php5/conf.d/msmtp.ini":
    ensure  => present,
    content => "sendmail_path = /usr/bin/msmtp --read-recipients\n",
    notify  => Service["apache2"],
    require => Package["php5-common"],
  }
}
