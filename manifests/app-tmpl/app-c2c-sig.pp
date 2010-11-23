class app-c2c-sig {

  group {"sigdev":
    ensure => present,
  }

  file {"/var/sig":
    ensure  => directory,
    owner   => root,
    group   => sigdev,
    mode    => 2775,
    require => Group["sigdev"]
  }

  package {"deploy":
    ensure => present,
  }

  user {"deploy":
    ensure      => present,
    groups      => ["www-data", "sigdev"],
    managehome  => true,
    require     => Package["deploy"],
  }

  file {"/home/deploy/.ssh/id_rsa":
    ensure => present,
    owner  => deploy,
    group  => deploy,
    mode   => 0600,
    content => "-----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEAsCTCjNSeQ4KK9xy3lfGMwziv9ij62AE4oB9ThQfpUtFguUP7
ggbdwb0V+6874heaXeUdTjssPSHc11Uklq7RpK1lsl4et7eKbjHPHgzpxUl89EzF
24GJUsoZiPu236YL6X/0X1YqkbAosSOV5P2g5E29/lSDrfBY1Ie3JZZ4GMqpcm/o
gIZoBL0vvbo9PMmfWgrfbpn12Wcjp11syeFxqkhwaGWJ+LEbr/2WvOJYPFMfgABm
1uL4ObUh/Qag7v6vpz5s8/0A/oyPeCg0Sx5xWUrzKvWXPMW63LNiWYv1yxgJtpHq
gjh68L6Dr9M2SGCAkdPsfowtnGZtwzz3LDnLPQIBIwKCAQAFCF1Uexp29RnpzZ7Y
Zfy1HuB0v1efxYVGZ0uHdUEuQH8bPHTmdTmJMUnFXMcyWHIf8Jpv8w/kfU9z3dx5
VXO0P3fvJ0K0yrrP8stnQjKQm7Mc7EAq19C5OPlqUFWunlgcnUF/ERcou+PnzdEV
K9Flm9I6d3F5/42CakcPs9eLrfiq4YO80eZWD2vnzCrxJY8seKWTK0kH4bz156x5
CGKJZoX11inWRvIcMXxNkA+Bjlfuo+y0EV3NhfzebfmYcy+vENudIuNYzFDYjfKm
qzSqLFGGUe3tCVUdwQl41f6CnETOG25U7aqq0g6IGo8NXerBSSx+yJTrNmN+SMCQ
j2wLAoGBAOYx6iGrFycafu2yNwRzyElh3ehd69QfhsiKy/56PPoA/UA+pHj+Oi19
+InjFkkL5h9mMxWIJ32ycEsJVZvAHO45x4AX1imfdpwgRwVcqWZOGqgG1xX+T1Pk
uFCvKqYJxTqs/0LE+f3RKnEs/h+0Bvgn1iI4ExxjiYvaOF56/fuhAoGBAMPjsMQE
vMMmIoFamVnQ3sLjrlPxwyWmA4V95NnDfv7gRt+NeViuw9RXQQ4/GfB59vp5Y/Sw
W6dt80SKp+VXIjx+KOZgYcI7JuW8eQIlDNfHISXG6vnWL8PmlsYlH4Pl9Wbb0pIg
wCfE3BXnM4fAgm/8/LTxDLUQbUelEkTtoAodAoGATuyKybcAn7FQFvtGECeyYk1w
p3CooH/WcKSdtlXLw24Nr6By56ee6waeWylJeCFWNqaybchIDdbHai8WCYOyJcqq
zNT4+FPuJuZ+wAKDOQTV8Hdfr8Tn/4GeR4yDpqRDnxa96wG0zA0zH30j7ZzPMIKv
0TfMCbu6IVIh9IHwrgsCgYEAsxlRKD7Yd+haD93OCPl7Ndd60GgC4JfItJBcNM//
FOpPbU4lzWyVyXRYvJF2zTxPhetUEupibTFTcd3bVVb6uvcA0qFDb8ENntg0HzfR
Ok+pRxxEjKaSEjHo76zpnSoE8FPzuM18fCGzRznItqFhUHJGIcZyBKFN+FxoeYjM
1gsCgYEAshMM73f3U4an3hrWC6BrSWifVXXGt7XKFzfVJ6azJysN51+rkBmzbDfc
vvn/Bq74iy7DRGzVwEZS0xQ50PcsLggZl2zpAi9PP9ZTJVhQOhBQniDyDb5xj1yG
1tePtj2/3BrXAdaqNKTIWsNoiaOtk2rgNhuBehjP5QVxOtCIwZg=
-----END RSA PRIVATE KEY-----
",
  }

  ssh_authorized_key {"deploy on deploy":
    ensure => present,
    user   => deploy,
    type   => "ssh-rsa",
    key    => "AAAAB3NzaC1yc2EAAAABIwAAAQEAsCTCjNSeQ4KK9xy3lfGMwziv9ij62AE4oB9ThQfpUtFguUP7ggbdwb0V+6874heaXeUdTjssPSHc11Uklq7RpK1lsl4et7eKbjHPHgzpxUl89EzF24GJUsoZiPu236YL6X/0X1YqkbAosSOV5P2g5E29/lSDrfBY1Ie3JZZ4GMqpcm/ogIZoBL0vvbo9PMmfWgrfbpn12Wcjp11syeFxqkhwaGWJ+LEbr/2WvOJYPFMfgABm1uL4ObUh/Qag7v6vpz5s8/0A/oyPeCg0Sx5xWUrzKvWXPMW63LNiWYv1yxgJtpHqgjh68L6Dr9M2SGCAkdPsfowtnGZtwzz3LDnLPQ==",
  }
  
  postgresql::user {"deploy":
    ensure => present,
    superuser => "true",
  }

  file {"/var/cache/deploy":
    ensure => directory,
    owner  => "deploy",
    group  => "sigdev",
    mode   => 2755,
    require => [Package["deploy"], User["deploy"]],
  }

  postgresql::user {"www-data":
    ensure => present,
    password => "www-data",
  }
}
