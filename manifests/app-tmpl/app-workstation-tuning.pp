class app-workstation-tuning {
  line {"bell style":
    line   => "set bell-style visible",
    ensure => present,
    file   => "/etc/inputrc",
  }  
}
