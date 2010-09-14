/*

==Definition: locales::locale
Install or remove locale $name

Arguments:
*$ensure*: ensure that local is present or absent
*$locale*: namevar - locale name

*/
define locales::locale($ensure=present) {
  common::concatfilepart {"locale-${name}":
    ensure  => $ensure,
    file    => "/etc/locale.gen",
    notify  => Exec["locale-gen"],
    content => "${name}\n",
  }
}
