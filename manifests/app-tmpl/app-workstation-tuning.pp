class app-workstation-tuning {
  line {"bell style":
    line   => "set bell-style visible",
    ensure => present,
    file   => "/etc/inputrc",
  }  

  apt::sources_list {"utils.avocats-ch":
    ensure  => present,
    content => "deb http://utils.avocats-ch.ch/ lucid main\n",
  }

}
