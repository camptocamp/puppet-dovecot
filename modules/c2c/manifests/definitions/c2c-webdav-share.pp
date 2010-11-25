define c2c::webdav::share(
  $ensure=present,
  $rw_users,
  $vhost,
  $directory=false,
  $ro_users=false,
  $allow_anonymous=false) {

  apache::webdav::instance {$name:
    ensure => $ensure,
    vhost => $vhost,
    directory => $directory,
  }

  apache::auth::basic::file::webdav::user {$name:
    ensure => $ensure,
    vhost  => $vhost,
    rw_users => $rw_users,
    ro_users => $ro_users,
    allow_anonymous => $allow_anonymous,
  }
}
