class dovecot::params {
  if !$dovecot_version {
    case $operatingsystem {
      Debian: {
        case $lsbdistcodename {
          default: { $version = 1}
        }
      }
      CentOS: {
        $version = 1
      }
      default: { $version = 1 }
    }
  } else {
    $version = $dovecot_version
  }
}
