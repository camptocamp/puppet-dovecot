#
# This puppet recipe is generated with the script get-c2c-sadb-users.rb
#
define app::c2c::sadb::users ($ensure=present, $groups=false) {

  c2c::sshuser {"mbornoz": 
    ensure  => $ensure, 
    uid     => url_get("${sadb}/user/mbornoz/uid_number"),
    comment => sprintf("%s %s", url_get("${sadb}/user/mbornoz/firstname"), url_get("${sadb}/user/mbornoz/lastname")),
    email   => url_get("${sadb}/user/mbornoz/email"), 
    type    => url_get("${sadb}/user/mbornoz/ssh_pub_key_type"),
    key     => url_get("${sadb}/user/mbornoz/ssh_pub_key"),
    groups  => $groups, 
  }

  c2c::sshuser {"cjeanneret": 
    ensure  => $ensure, 
    uid     => url_get("${sadb}/user/cjeanneret/uid_number"),
    comment => sprintf("%s %s", url_get("${sadb}/user/mbornoz/firstname"), url_get("${sadb}/user/mbornoz/lastname")),
    email   => url_get("${sadb}/user/cjeanneret/email"), 
    type    => url_get("${sadb}/user/cjeanneret/ssh_pub_key_type"),
    key     => url_get("${sadb}/user/cjeanneret/ssh_pub_key"),
    groups  => $groups, 
  }

  c2c::sshuser {"marc": 
    ensure  => $ensure, 
    uid     => url_get("${sadb}/user/marc/uid_number"),
    comment => sprintf("%s %s", url_get("${sadb}/user/mbornoz/firstname"), url_get("${sadb}/user/mbornoz/lastname")),
    email   => url_get("${sadb}/user/marc/email"), 
    type    => url_get("${sadb}/user/marc/ssh_pub_key_type"),
    key     => url_get("${sadb}/user/marc/ssh_pub_key"),
    groups  => $groups, 
  }

  c2c::sshuser {"alex": 
    ensure  => $ensure, 
    uid     => url_get("${sadb}/user/alex/uid_number"),
    comment => sprintf("%s %s", url_get("${sadb}/user/mbornoz/firstname"), url_get("${sadb}/user/mbornoz/lastname")),
    email   => url_get("${sadb}/user/alex/email"), 
    type    => url_get("${sadb}/user/alex/ssh_pub_key_type"),
    key     => url_get("${sadb}/user/alex/ssh_pub_key"),
    groups  => $groups, 
  }

  c2c::sshuser {"ckaenzig": 
    ensure  => $ensure, 
    uid     => url_get("${sadb}/user/ckaenzig/uid_number"),
    comment => sprintf("%s %s", url_get("${sadb}/user/mbornoz/firstname"), url_get("${sadb}/user/mbornoz/lastname")),
    email   => url_get("${sadb}/user/ckaenzig/email"), 
    type    => url_get("${sadb}/user/ckaenzig/ssh_pub_key_type"),
    key     => url_get("${sadb}/user/ckaenzig/ssh_pub_key"),
    groups  => $groups, 
  }

  c2c::sshuser {"claude": 
    ensure  => $ensure, 
    uid     => url_get("${sadb}/user/claude/uid_number"),
    comment => sprintf("%s %s", url_get("${sadb}/user/mbornoz/firstname"), url_get("${sadb}/user/mbornoz/lastname")),
    email   => url_get("${sadb}/user/claude/email"), 
    type    => url_get("${sadb}/user/claude/ssh_pub_key_type"),
    key     => url_get("${sadb}/user/claude/ssh_pub_key"),
    groups  => $groups, 
  }

  c2c::sshuser {"ebelo": 
    ensure  => $ensure, 
    uid     => url_get("${sadb}/user/ebelo/uid_number"),
    comment => sprintf("%s %s", url_get("${sadb}/user/mbornoz/firstname"), url_get("${sadb}/user/mbornoz/lastname")),
    email   => url_get("${sadb}/user/ebelo/email"), 
    type    => url_get("${sadb}/user/ebelo/ssh_pub_key_type"),
    key     => url_get("${sadb}/user/ebelo/ssh_pub_key"),
    groups  => $groups, 
  }

  c2c::sshuser {"elemoine": 
    ensure  => $ensure, 
    uid     => url_get("${sadb}/user/elemoine/uid_number"),
    comment => sprintf("%s %s", url_get("${sadb}/user/mbornoz/firstname"), url_get("${sadb}/user/mbornoz/lastname")),
    email   => url_get("${sadb}/user/elemoine/email"), 
    type    => url_get("${sadb}/user/elemoine/ssh_pub_key_type"),
    key     => url_get("${sadb}/user/elemoine/ssh_pub_key"),
    groups  => $groups, 
  }

  c2c::sshuser {"fredj": 
    ensure  => $ensure, 
    uid     => url_get("${sadb}/user/fredj/uid_number"),
    comment => sprintf("%s %s", url_get("${sadb}/user/mbornoz/firstname"), url_get("${sadb}/user/mbornoz/lastname")),
    email   => url_get("${sadb}/user/fredj/email"), 
    type    => url_get("${sadb}/user/fredj/ssh_pub_key_type"),
    key     => url_get("${sadb}/user/fredj/ssh_pub_key"),
    groups  => $groups, 
  }

  c2c::sshuser {"fvanderbiest": 
    ensure  => $ensure, 
    uid     => url_get("${sadb}/user/fvanderbiest/uid_number"),
    comment => sprintf("%s %s", url_get("${sadb}/user/mbornoz/firstname"), url_get("${sadb}/user/mbornoz/lastname")),
    email   => url_get("${sadb}/user/fvanderbiest/email"), 
    type    => url_get("${sadb}/user/fvanderbiest/ssh_pub_key_type"),
    key     => url_get("${sadb}/user/fvanderbiest/ssh_pub_key"),
    groups  => $groups, 
  }

  c2c::sshuser {"fxprunayre": 
    ensure  => $ensure, 
    uid     => url_get("${sadb}/user/fxprunayre/uid_number"),
    comment => sprintf("%s %s", url_get("${sadb}/user/mbornoz/firstname"), url_get("${sadb}/user/mbornoz/lastname")),
    email   => url_get("${sadb}/user/fxprunayre/email"), 
    type    => url_get("${sadb}/user/fxprunayre/ssh_pub_key_type"),
    key     => url_get("${sadb}/user/fxprunayre/ssh_pub_key"),
    groups  => $groups, 
  }

  c2c::sshuser {"jbaubort": 
    ensure  => $ensure, 
    uid     => url_get("${sadb}/user/jbaubort/uid_number"),
    comment => sprintf("%s %s", url_get("${sadb}/user/mbornoz/firstname"), url_get("${sadb}/user/mbornoz/lastname")),
    email   => url_get("${sadb}/user/jbaubort/email"), 
    type    => url_get("${sadb}/user/jbaubort/ssh_pub_key_type"),
    key     => url_get("${sadb}/user/jbaubort/ssh_pub_key"),
    groups  => $groups, 
  }

  c2c::sshuser {"jeichar": 
    ensure  => $ensure, 
    uid     => url_get("${sadb}/user/jeichar/uid_number"),
    comment => sprintf("%s %s", url_get("${sadb}/user/mbornoz/firstname"), url_get("${sadb}/user/mbornoz/lastname")),
    email   => url_get("${sadb}/user/jeichar/email"), 
    type    => url_get("${sadb}/user/jeichar/ssh_pub_key_type"),
    key     => url_get("${sadb}/user/jeichar/ssh_pub_key"),
    groups  => $groups, 
  }

  c2c::sshuser {"jgrandguillaume": 
    ensure  => $ensure, 
    uid     => url_get("${sadb}/user/jgrandguillaume/uid_number"),
    comment => sprintf("%s %s", url_get("${sadb}/user/mbornoz/firstname"), url_get("${sadb}/user/mbornoz/lastname")),
    email   => url_get("${sadb}/user/jgrandguillaume/email"), 
    type    => url_get("${sadb}/user/jgrandguillaume/ssh_pub_key_type"),
    key     => url_get("${sadb}/user/jgrandguillaume/ssh_pub_key"),
    groups  => $groups, 
  }

  c2c::sshuser {"lmaurer": 
    ensure  => $ensure, 
    uid     => url_get("${sadb}/user/lmaurer/uid_number"),
    comment => sprintf("%s %s", url_get("${sadb}/user/mbornoz/firstname"), url_get("${sadb}/user/mbornoz/lastname")),
    email   => url_get("${sadb}/user/lmaurer/email"), 
    type    => url_get("${sadb}/user/lmaurer/ssh_pub_key_type"),
    key     => url_get("${sadb}/user/lmaurer/ssh_pub_key"),
    groups  => $groups, 
  }

  c2c::sshuser {"nbessi": 
    ensure  => $ensure, 
    uid     => url_get("${sadb}/user/nbessi/uid_number"),
    comment => sprintf("%s %s", url_get("${sadb}/user/mbornoz/firstname"), url_get("${sadb}/user/mbornoz/lastname")),
    email   => url_get("${sadb}/user/nbessi/email"), 
    type    => url_get("${sadb}/user/nbessi/ssh_pub_key_type"),
    key     => url_get("${sadb}/user/nbessi/ssh_pub_key"),
    groups  => $groups, 
  }

  c2c::sshuser {"ochriste": 
    ensure  => $ensure, 
    uid     => url_get("${sadb}/user/ochriste/uid_number"),
    comment => sprintf("%s %s", url_get("${sadb}/user/mbornoz/firstname"), url_get("${sadb}/user/mbornoz/lastname")),
    email   => url_get("${sadb}/user/ochriste/email"), 
    type    => url_get("${sadb}/user/ochriste/ssh_pub_key_type"),
    key     => url_get("${sadb}/user/ochriste/ssh_pub_key"),
    groups  => $groups, 
  }

  c2c::sshuser {"pierre": 
    ensure  => $ensure, 
    uid     => url_get("${sadb}/user/pierre/uid_number"),
    comment => sprintf("%s %s", url_get("${sadb}/user/mbornoz/firstname"), url_get("${sadb}/user/mbornoz/lastname")),
    email   => url_get("${sadb}/user/pierre/email"), 
    type    => url_get("${sadb}/user/pierre/ssh_pub_key_type"),
    key     => url_get("${sadb}/user/pierre/ssh_pub_key"),
    groups  => $groups, 
  }

  c2c::sshuser {"sdebayle": 
    ensure  => $ensure, 
    uid     => url_get("${sadb}/user/sdebayle/uid_number"),
    comment => sprintf("%s %s", url_get("${sadb}/user/mbornoz/firstname"), url_get("${sadb}/user/mbornoz/lastname")),
    email   => url_get("${sadb}/user/sdebayle/email"), 
    type    => url_get("${sadb}/user/sdebayle/ssh_pub_key_type"),
    key     => url_get("${sadb}/user/sdebayle/ssh_pub_key"),
    groups  => $groups, 
  }

  c2c::sshuser {"vrenaville": 
    ensure  => $ensure, 
    uid     => url_get("${sadb}/user/vrenaville/uid_number"),
    comment => sprintf("%s %s", url_get("${sadb}/user/mbornoz/firstname"), url_get("${sadb}/user/mbornoz/lastname")),
    email   => url_get("${sadb}/user/vrenaville/email"), 
    type    => url_get("${sadb}/user/vrenaville/ssh_pub_key_type"),
    key     => url_get("${sadb}/user/vrenaville/ssh_pub_key"),
    groups  => $groups, 
  }

  c2c::sshuser {"yves": 
    ensure  => $ensure, 
    uid     => url_get("${sadb}/user/yves/uid_number"),
    comment => sprintf("%s %s", url_get("${sadb}/user/mbornoz/firstname"), url_get("${sadb}/user/mbornoz/lastname")),
    email   => url_get("${sadb}/user/yves/email"), 
    type    => url_get("${sadb}/user/yves/ssh_pub_key_type"),
    key     => url_get("${sadb}/user/yves/ssh_pub_key"),
    groups  => $groups, 
  }

  c2c::sshuser {"aabt": 
    ensure  => $ensure, 
    uid     => url_get("${sadb}/user/aabt/uid_number"),
    comment => sprintf("%s %s", url_get("${sadb}/user/mbornoz/firstname"), url_get("${sadb}/user/mbornoz/lastname")),
    email   => url_get("${sadb}/user/aabt/email"), 
    type    => url_get("${sadb}/user/aabt/ssh_pub_key_type"),
    key     => url_get("${sadb}/user/aabt/ssh_pub_key"),
    groups  => $groups, 
  }

  c2c::sshuser {"bbinet": 
    ensure  => $ensure, 
    uid     => url_get("${sadb}/user/bbinet/uid_number"),
    comment => sprintf("%s %s", url_get("${sadb}/user/mbornoz/firstname"), url_get("${sadb}/user/mbornoz/lastname")),
    email   => url_get("${sadb}/user/bbinet/email"), 
    type    => url_get("${sadb}/user/bbinet/ssh_pub_key_type"),
    key     => url_get("${sadb}/user/bbinet/ssh_pub_key"),
    groups  => $groups, 
  }

  c2c::sshuser {"ybuch": 
    ensure  => $ensure, 
    uid     => url_get("${sadb}/user/ybuch/uid_number"),
    comment => sprintf("%s %s", url_get("${sadb}/user/mbornoz/firstname"), url_get("${sadb}/user/mbornoz/lastname")),
    email   => url_get("${sadb}/user/ybuch/email"), 
    type    => url_get("${sadb}/user/ybuch/ssh_pub_key_type"),
    key     => url_get("${sadb}/user/ybuch/ssh_pub_key"),
    groups  => $groups, 
  }

  c2c::sshuser {"stosatto": 
    ensure  => $ensure, 
    uid     => url_get("${sadb}/user/stosatto/uid_number"),
    comment => sprintf("%s %s", url_get("${sadb}/user/mbornoz/firstname"), url_get("${sadb}/user/mbornoz/lastname")),
    email   => url_get("${sadb}/user/stosatto/email"), 
    type    => url_get("${sadb}/user/stosatto/ssh_pub_key_type"),
    key     => url_get("${sadb}/user/stosatto/ssh_pub_key"),
    groups  => $groups, 
  }

  c2c::sshuser {"jbove": 
    ensure  => $ensure, 
    uid     => url_get("${sadb}/user/jbove/uid_number"),
    comment => sprintf("%s %s", url_get("${sadb}/user/mbornoz/firstname"), url_get("${sadb}/user/mbornoz/lastname")),
    email   => url_get("${sadb}/user/jbove/email"), 
    type    => url_get("${sadb}/user/jbove/ssh_pub_key_type"),
    key     => url_get("${sadb}/user/jbove/ssh_pub_key"),
    groups  => $groups, 
  }

  c2c::sshuser {"cgampouris": 
    ensure  => $ensure, 
    uid     => url_get("${sadb}/user/cgampouris/uid_number"),
    comment => sprintf("%s %s", url_get("${sadb}/user/mbornoz/firstname"), url_get("${sadb}/user/mbornoz/lastname")),
    email   => url_get("${sadb}/user/cgampouris/email"), 
    type    => url_get("${sadb}/user/cgampouris/ssh_pub_key_type"),
    key     => url_get("${sadb}/user/cgampouris/ssh_pub_key"),
    groups  => $groups, 
  }

  c2c::sshuser {"pmauduit": 
    ensure  => $ensure, 
    uid     => url_get("${sadb}/user/pmauduit/uid_number"),
    comment => sprintf("%s %s", url_get("${sadb}/user/mbornoz/firstname"), url_get("${sadb}/user/mbornoz/lastname")),
    email   => url_get("${sadb}/user/pmauduit/email"), 
    type    => url_get("${sadb}/user/pmauduit/ssh_pub_key_type"),
    key     => url_get("${sadb}/user/pmauduit/ssh_pub_key"),
    groups  => $groups, 
  }

  c2c::sshuser {"yjacolin": 
    ensure  => $ensure, 
    uid     => url_get("${sadb}/user/yjacolin/uid_number"),
    comment => sprintf("%s %s", url_get("${sadb}/user/mbornoz/firstname"), url_get("${sadb}/user/mbornoz/lastname")),
    email   => url_get("${sadb}/user/yjacolin/email"), 
    type    => url_get("${sadb}/user/yjacolin/ssh_pub_key_type"),
    key     => url_get("${sadb}/user/yjacolin/ssh_pub_key"),
    groups  => $groups, 
  }

  c2c::sshuser {"fjacon": 
    ensure  => $ensure, 
    uid     => url_get("${sadb}/user/fjacon/uid_number"),
    comment => sprintf("%s %s", url_get("${sadb}/user/mbornoz/firstname"), url_get("${sadb}/user/mbornoz/lastname")),
    email   => url_get("${sadb}/user/fjacon/email"), 
    type    => url_get("${sadb}/user/fjacon/ssh_pub_key_type"),
    key     => url_get("${sadb}/user/fjacon/ssh_pub_key"),
    groups  => $groups, 
  }

  c2c::sshuser {"mremy": 
    ensure  => $ensure, 
    uid     => url_get("${sadb}/user/mremy/uid_number"),
    comment => sprintf("%s %s", url_get("${sadb}/user/mbornoz/firstname"), url_get("${sadb}/user/mbornoz/lastname")),
    email   => url_get("${sadb}/user/mremy/email"), 
    type    => url_get("${sadb}/user/mremy/ssh_pub_key_type"),
    key     => url_get("${sadb}/user/mremy/ssh_pub_key"),
    groups  => $groups, 
  }

  c2c::sshuser {"tsauerwein": 
    ensure  => $ensure, 
    uid     => url_get("${sadb}/user/tsauerwein/uid_number"),
    comment => sprintf("%s %s", url_get("${sadb}/user/mbornoz/firstname"), url_get("${sadb}/user/mbornoz/lastname")),
    email   => url_get("${sadb}/user/tsauerwein/email"), 
    type    => url_get("${sadb}/user/tsauerwein/ssh_pub_key_type"),
    key     => url_get("${sadb}/user/tsauerwein/ssh_pub_key"),
    groups  => $groups, 
  }
}
