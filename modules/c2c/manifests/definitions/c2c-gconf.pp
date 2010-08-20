define c2c::gconf($user, $keyname, $type, $value, $list_type=false, $list_append=false, $schema='', $ensure='present') {
  if $list_type {
    if $list_append {
      $command = "su -l -c '/usr/bin/gconftool-2 --set $keyname --list-type $list_type --type $type `echo $(gconftool-2  --get ${keyname}) | sed -e \"s/\]/,${value}\]/\"`' ${user}"
      $unless  = "su -l -c '/usr/bin/gconftool-2 --get ${keyname}' ${user} | grep ${value}"
    }
    else {
      $command = "su -l -c \"/usr/bin/gconftool-2 --set $keyname --list-type $list_type --type $type '$value'\" $user"
      $unless  = "test \"$value\" != \"\" && su -l -c 'test \"$(/usr/bin/gconftool-2 --get $keyname)\" == \"$value\"' $user"
    }
  }
  else {
    $command = "su -l -c \"/usr/bin/gconftool-2 --set $keyname --type $type '$value'\" $user"
    $unless  = "test \"$value\" != \"\" && su -l -c 'test \"$(/usr/bin/gconftool-2 --get $keyname)\" == \"$value\"' $user"
  }
  exec {"set param $keyname with value $value for user $user":
    command => $command,
    unless  => $unless,
    require => User[$user],
  }
  if $schema {
    exec {"set default schema entry for $keyname in $user":
      command => "su -l -c 'gconftool-2 --apply-schema $schema $keyname' ${user}",
      unless  => "test \"${schema}\" == \"$(su -l -c '/usr/bin/gconftool-2 --get-schema-name ${keyname}' ${user})\"",
      require => Exec["set param $keyname with value $value for user $user"],
    }
  }
}
