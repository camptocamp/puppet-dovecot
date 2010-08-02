class os-server-debian {
  # check an fix locales generation
  exec {"check locales":
    command => "/usr/sbin/locale-gen",
    unless => "test \$(locale -a |egrep -c '^(de|fr|en|it)\$') == 4",
    require => [File["/usr/share/locale/locale.alias"], Package["locales"], File["/etc/locale.gen"]],
  }

}
