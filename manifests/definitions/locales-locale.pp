/*

==Definition: locales::locale
Install or remove locale $name

Arguments:
*$ensure*: ensure that local is present or absent
*$charset*: locale charset
*$locale*: namevar - locale name

*/
define locales::locale($ensure=present, $charset) {
  common::concatfilepart {"locale-${name}":
    ensure  => $ensure,
    file    => "/etc/locale.gen",
    notify  => Exec["locale-gen"],
    content => "${name} ${charset}\n",
  }
}
