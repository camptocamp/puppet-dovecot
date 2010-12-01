class geste::dhcp {
  $dhcpd_domain_name = "geste"
  $dhcpd_dns_servers = "192.168.12.2, 128.178.15.8, 128.178.15.7"

  if $geste_master {
    $dhcpd_authoritative = true
  }

  include dhcp
  dhcp::subnet {"192.168.12.0":
    ensure      => present,
    subnet_mask => "255.255.255.0",
    broadcast   => "192.168.12.255",
    domain_name => $dhcpd_dns_servers,
    other_opts  => "range 192.168.12.130 192.168.12.180",
  }

  dhcp::host {
    "pc-zib":     subnet => "192.168.12.0", mac => "00:13:20:7f:44:47", fixed_address => "pc-zib.geste";
    "pc-gic":     subnet => "192.168.12.0", mac => "00:15:c5:45:1b:14", fixed_address => "pc-gic.geste";
    "pc-jbd":     subnet => "192.168.12.0", mac => "00:01:6c:ba:ea:dc", fixed_address => "pc-jdb.geste";
    "pc-fev":     subnet => "192.168.12.0", mac => "00:13:72:dd:58:0e", fixed_address => "pc-fev.geste";
    "pc-fap":     subnet => "192.168.12.0", mac => "00:01:4a:f3:89:de", fixed_address => "pc-fap.geste";
    "pc-ges":     subnet => "192.168.12.0", mac => "00:13:72:dc:2b:a2", fixed_address => "pc-ges.geste";
    "pc-rho":     subnet => "192.168.12.0", mac => "00:24:81:b3:47:dd", fixed_address => "pc-rho.geste";
    "pc-vhu":     subnet => "192.168.12.0", mac => "00:0f:ea:4a:35:27", fixed_address => "pc-vhu.geste";
    "pc-pam":     subnet => "192.168.12.0", mac => "00:13:20:81:0c:83", fixed_address => "pc-pam.geste";
    "pc-mim":     subnet => "192.168.12.0", mac => "00:0a:e4:50:18:ea", fixed_address => "pc-mim.geste";
    "mac-mim":    subnet => "192.168.12.0", mac => "00:0a:27:89:8b:c0", fixed_address => "mac-mim.geste";
    "pc-dal":     subnet => "192.168.12.0", mac => "00:21:6a:0e:41:24", fixed_address => "pc-dal.geste";
    "pc-djo":     subnet => "192.168.12.0", mac => "00:1c:25:9f:9c:e9", fixed_address => "pc-djo.geste";
    "pc-cfa":     subnet => "192.168.12.0", mac => "00:25:4b:ce:28:62", fixed_address => "pc-cfa.geste";
    "pc-tka":     subnet => "192.168.12.0", mac => "00:1c:25:9f:9a:de", fixed_address => "pc-tka.geste";
    "pc-rams":    subnet => "192.168.12.0", mac => "00:02:3f:32:f5:1c", fixed_address => "pc-rams.geste";
    "old-server": subnet => "192.168.12.0", mac => "00:03:93:13:9f:88", fixed_address => "old-server.geste";
    "zeus":       subnet => "192.168.12.0", mac => "84:2B:2B:57:F0:4F", fixed_address => "zeus.geste";
    "opteron1":   subnet => "192.168.12.0", mac => "00:30:48:58:95:40", fixed_address => "opteron1.geste";
  }


}
