define dhcp::subnet(
  $ensure=present,
  $bcast,
  $dns,
  $netmask=false,
  $domain_name=false,
  $inc=false,
  $routeurs=false,
  $netbios_dns=false,
  $subnet_mask=false,
  $other_opt=false,
  $deny=false) {
  include dhcp::variables

  if $inc {
    $to_inc = "${dhcp::variables::config_dir}/hosts.d/${name}.conf"
  }

  file {"${dhcp::variables::config_dir}/subnets/${name}.conf":
    ensure => $ensure,
    owner  => root,
    group  => root,
    content => template("dhcp/subnet.conf.erb"),
    notify  => Service["dhcpd"],
  }
  
  common::concatfilepart {"${name}":
    file => "${dhcp::variables::config_dir}/dhcpd.conf",
    ensure => $ensure,
    content => "include \"${dhcp::variables::config_dir}/subnets/${name}.conf\";\n",
  }

}
