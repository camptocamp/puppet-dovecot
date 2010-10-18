/*

==Definition: locales::alias
Create locale alias

Arguments:
*$ensure*: ensures alias is present or absent
*$locale*: locale name
*$alias*: namevar - alias name

*/
define locales::alias($ensure=present, $locale) {
  common::concatfilepart{"alias ${name} for ${locale}":
    ensure  => $ensure,
    file    => "/etc/locale.alias",
    content => "${name} ${locale}\n",
    notify  => Exec["locale-gen"],
    require => Locales::Locale[$locale],
  }
}
