define mailman::checkpw($ensure=present, $mailman_bin="/usr/lib/mailman/bin", $name, $url, $password) {

  #Note: URL must look like http://lists.domain.ltd/cgi-bin/mailman/admin/${list_name}

  exec {"Change mailman list password of ${name}":
    command => "${mailman_bin}/change_pw --quiet --listname=${name} --password=${password}",
    unless  => "/usr/bin/curl -s ${url}/${name} -d 'admlogin=Let%20me%20in...&adminpw=${password}' | grep -q logout",
    require => Package["curl"],
  }
}
