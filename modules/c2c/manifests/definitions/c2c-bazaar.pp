define c2c::bazaar($ensure=present,$ro_pwd=false,$group="c2cdev"){
  
  include apache::params

  file {"/srv/bzr/${name}":
    owner  => www-data,
    group  => $group,
    mode   => 2770,
  }
  case $ensure {
    present: {
      File["/srv/bzr/${name}"] {
        ensure => directory,
      }
    }
    absent: {
      File["/srv/bzr/${name}"] {
        ensure => absent,
        recurse => true,
        force   => true,
        purge   => true,
      }
    }
  }

  if $ro_pwd {
    apache::auth::htpasswd {"${name}":
      ensure => $ensure,
      vhost  => "bazaar",
      username => $name,
      clearPassword => $ro_pwd,
    }
  } 

  apache::directive {"deny-${name}":
    ensure => $ensure,
    vhost  => "bazaar",
    directive => "<Location /bzr/${name}>
  AuthName '${name}'
  AuthType Basic
  AuthBasicProvider file
  AuthUserFile ${apache::params::root}/bazaar/private/htpasswd
  Require ${name}

  Order deny,allow
  Deny from all
  Allow from .camptocamp.com
        
  Satisfy Any
</Location>
",
  }

}
