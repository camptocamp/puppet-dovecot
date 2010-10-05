class app-eks-wetterhorn {
  include python::dev
  include rdiff-backup::server
  include monitoring::raid::mdadm
  rdiff-backup::server::install {["0.13.4", "1.1.5", "1.2.1", "1.2.5"]: }

  user {"admin":
    ensure => present,
    shell  => "/bin/bash",
    home   => "/home/admin",
    groups => "adm",
    managehome => true,
  }

  ssh_authorized_key {"laurent.piguet@eks.com":
    ensure  => present,
    user    => admin,
    require => User["admin"],
    type    => "ssh-rsa",
    key     => "AAAAB3NzaC1yc2EAAAABIwAAAQEAqcqTyIvfLoinj2gsDkuFoWfFbjK+JNc2OkPAb27/6WhFxkKh12v0hJx8BlfyHJFpHpLVwOqbKTmZkILEIkLCsMyACi5l+rVXPg3xDbRK8Jo8Wh4fv4KE2WcTOdJtnhESs2uv221yxC3JZsP2PM4TtOMZOLEizgmc5iLcnpy3Ja/PCmV2px/fT+r1CbOG9PHdTJ+dEqiB4vYplY9MmrB1C/fQvL5uDo8LqYeIzZDd+zUmRgzqrqBq+k4ZJ+/VoRrnXrFwVCsqStUWAJr8ozCnAUMfHPV89IbGUUEUWdJ5i1+tVz0Ik+obDD7bSoCzZZ0hM3jG8/QrTiTFIsVf+43OKw==",
  }

  file {"/root/.ssh/rdiff-backup-1.1.5.id_rsa":
    ensure => present,
    mode   => "0600",
    owner  => root,
    group  => root,
    content => "-----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEA7TwJY0sRTMXWpxbmNZVCsjHoB4Ri6ThsdoR/H4BjkH+0Enaw
ccQ3pL0GLUh4dMi7QGAE0D/+gDedz9DVwts5KP23TyrUjxfLi7K6Gruun/q2RcHb
CYKbGRdad5ktXEuD0bTsKjnsF+08QybHUr0n/DoAZYrQTrQcgAokFnJuGnmCnhJH
/PenE8a3f7Xz9JNIvv3CtBLmvvHh9vyBsNbeKFWkTouuoiix2c5+8xRNZRMfXTAM
iH6MHmT9N1nX/8MPpq6h2Kl9V/rauXq2mB5oN3re+wSiEkW/XaflpW5wSziPIXX9
TKHks6UCQm1IiSneRs7YpwQ1OdUUf4N/FtM6OwIBIwKCAQB6AZ5tlFIKOdwbatzL
GZAD3ybfS2YRirtwJuJKtw6iFcpSo3CviXuzzu073CCxFsazZJTC3xUr/1h5gVf9
z9RA94LYQemorSbaIWcGbyabav6niETDD/f+RoZMIuQg1mEMw3IkWE2IpeR6TnUj
PLV6Zvjjw7uWML4zOGpUr+DaaWLIVvriTlO+WlLRXd0isAajn7eBQ6rMsqgRq+f1
y2sL29K4Po1JwiPA+pkFUSjd4Vl/hMJsoHmwNOnEiGNdrn9e6Bwp/dDX9449I3fE
Kpx54tGOdVH3sMD/J/pxSrJ2BfN+ogT5cqiNUq01VRiEd9V3I18eoc+JlGN+BFRL
tT97AoGBAP+drZLhFy/8UNhLOzi6DuELzJ6AVZ5DiEoCDpQAt3/E739DZzUq1BYS
3xneGsJMvBYtluL9wyTwWuH76Oz6uy8LwYAE11Zt43XhAociDR7tRWQOlCDc80NR
I6012aHn6emXGeT9LBCrSqgiCAKINi6W34sERw08yPq35Z5OdvKXAoGBAO2XSc1H
ZJteOAVIC1Ran+kDQbEqK3xfKqZ9PBxuog4+HkQzHJ+gzOR6XXRuMRD3INspbFop
SnqQTeLn9fDrUQViYrIs1mYptgkoszhcMDV5pxxXb/AMlz2qmgpaZx4MCi+iWfIx
iKi8q16qeLLGfHQr1TEgEL8cMq2n6ssYtL39AoGBAPhQB7NBDzXtyuC+HEW8DnQ3
WQ8AUywHFq5LJBq+3iRY6KeDTlDnxrZbeaQZllZZK73F4whkOelehCv8BteUe1JF
7yvnchlyEClePPhM9s2WCOTa9kvPUrZsFAdY4gr+i3UzssEwc/LvilovsAJ1sPoO
58jflXqS0d2csywRtWCvAoGAejCMWvGEMqV75XWCK2HOlReeIJlYMVWDphSFUHNp
SSdCw/0HaAmN8diH1Xp/olM1eAaswKeFY5qrtoXsMsIpqv9l9Tuhdl6YIfesoKRw
kIe1B0LpHF4/JwdH6BE8WJh6RGIfoSDJ8GEHrQc2wldzNG5QYmhDIHTm3PdFjQVk
RHMCgYEAkQzHh0JVBUMyqBor+6uUviYtg6wiKPMnw2fEkKIbrPmjyEyDbpgwDsC8
wj6lff1kIICRMwJBYieey76OQzUVYzuSOAH8Y8cszmBMvP46Ao2No01H5EAsW5Fo
qV6ppDYDmKOOzyQD7PMpwrp/8d5KkNyY0jepoLKITMO3t0FWlrQ=
-----END RSA PRIVATE KEY-----
",
  }

  host {
    "eiger.eks":          ip => "192.168.99.2";
    "eiger":              ip => "192.168.99.2";
    "wetterhorn.eks.com": ip => "192.168.99.4";
    "wetterhorn":         ip => "192.168.99.4";
    "scheidegg":          ip => "10.10.10.2";
    "rp":                 ip => "10.10.10.5";
    "svn":                ip => "10.10.10.121";
    "mail":               ip => "10.10.10.123";
    "pe2500":             ip => "10.10.10.3";
    "app":                ip => "10.10.10.100";
    "appstage":           ip => "10.10.10.101";
    "home":               ip => "10.10.10.102";
    "id":                 ip => "10.10.10.103";
    "jungfrau":           ip => "62.2.237.75";
    "ecm":                ip => "192.168.99.6";
    "prod":               ip => "209.59.209.5";
  }
}
