class c2c::sysadmin-in-charge-new {
  ssh_authorized_key{"mathieu.bornoz@camptocamp.com on root":
    ensure => present,
    type   => "ssh-rsa",
    key    => "AAAAB3NzaC1yc2EAAAABIwAAAgEA1H8WSRhPAv3T6YIKdYH7bJpAiDslwRkzi4W3FDuVugdkpRnqMFv/DFmzuIBH4PNZgZ4JL5o/RvCuypGGWQQQaKJHA4mlWL0AwW83dDJp17RH+4VL8YR17Y02sqdKb1qK7efaG5nUIFUB6jTISNQ9wSzRylFexj7W3nRZoNY2viDrvH3IN/JO4MIrWPOvv/JVAijgcPR6E9PlaJn8KkspiICfPUsRoY0/RZqY6KLLXdwCvz2aG1bwinboev9bQr8VyABYF5D8Vkj2SJ/sf325aihXWjB4p2j0l9oynhQ9va4vefURYkE+7fb3moibsNcAg9qUZ0w4nUva9CVqB70a8orxiK+H3Pur7tafCgRLKIBZxU59izXuc+JNg5uxaH5fL0lUsP0TSFGJSgCT5O433hnBwuPEOICoUfGw2fBDGmw3lzE6bzccHh0AR1NYCvEIypsTaXSQFOTwzTfwqiClj7HVldb2ArxOzlSK/37gDobnsjBBdWCW8AYwIsWeifIlZbp+gKFjyjoJpH4Mx8yBAEH0ol9QHPwypJlLXHGClWywLryy/kuBjKQCsM8oB276X5p+gU8FQaxpUBp16C9auAONO+rZD50/tj/gNoD71DOSQNfQt4Gul4vzdGlaW4FVLo5zdHg8Q++T9YdPOWVeRIm1XfTkJAjUP0NbLZvf44k=",
    user      => "root",
  }

  ssh_authorized_key{"marc.fournier@camptocamp.com on root":
    ensure    => present,
    type      => "ssh-rsa",
    key       => "AAAAB3NzaC1yc2EAAAABIwAAAQEAuzVRsZMCL1CHqcB5tBVATgRucCaMVpQz5qKO8RAlSwpRod8DYBBMxWpolclxyX+9qHXLiwIWv/Ourld/HrLdbHOpiQ/QAZzZoEOrIQ+hT/iRnlA4Pdub7Ep2Y2AO3eGH8kJn8vl8tkAiey577dfmhYo9LTJQD6csyLEmmnoef/Rn9qWXrUTLF5/1sobtuQ1jkB1qUSG0yjrRTuyLh9/pv6xJgTpQNP5x9ok7MsRrPaZZ5Oyzt0JRNsKY5LpgNForXCm5gsGk+qfoET8zUZ8YUEue8h7zE5WShZNhAnN43EaxxGoBkqQDcnSygJVetfRlwt9JHt4xPrdFJDulvCun+w==",
    user      => "root",
  }

  ssh_authorized_key{"francois.deppierraz@camptocamp.com on root":
    ensure    => present,
    type      => "ssh-rsa",
    key       => "AAAAB3NzaC1yc2EAAAABIwAAAgEA1H8WSRhPAv3T6YIKdYH7bJpAiDslwRkzi4W3FDuVugdkpRnqMFv/DFmzuIBH4PNZgZ4JL5o/RvCuypGGWQQQaKJHA4mlWL0AwW83dDJp17RH+4VL8YR17Y02sqdKb1qK7efaG5nUIFUB6jTISNQ9wSzRylFexj7W3nRZoNY2viDrvH3IN/JO4MIrWPOvv/JVAijgcPR6E9PlaJn8KkspiICfPUsRoY0/RZqY6KLLXdwCvz2aG1bwinboev9bQr8VyABYF5D8Vkj2SJ/sf325aihXWjB4p2j0l9oynhQ9va4vefURYkE+7fb3moibsNcAg9qUZ0w4nUva9CVqB70a8orxiK+H3Pur7tafCgRLKIBZxU59izXuc+JNg5uxaH5fL0lUsP0TSFGJSgCT5O433hnBwuPEOICoUfGw2fBDGmw3lzE6bzccHh0AR1NYCvEIypsTaXSQFOTwzTfwqiClj7HVldb2ArxOzlSK/37gDobnsjBBdWCW8AYwIsWeifIlZbp+gKFjyjoJpH4Mx8yBAEH0ol9QHPwypJlLXHGClWywLryy/kuBjKQCsM8oB276X5p+gU8FQaxpUBp16C9auAONO+rZD50/tj/gNoD71DOSQNfQt4Gul4vzdGlaW4FVLo5zdHg8Q++T9YdPOWVeRIm1XfTkJAjUP0NbLZvf44k=",
    user      => "root",
  }

  ssh_authorized_key{"cedric.jeanneret@camptocamp.com on root":
    ensure    => present,
    type      => "ssh-rsa",
    key       => "AAAAB3NzaC1yc2EAAAABIwAAAQEA9GrmN66bCc+kPRPONvVOVKgbzouLRt5G6lrW+8nyiYcgY5QNR+L0iG0JTANK2MFDuwtQmqoKmr7NBwsCaxmflE3K4kN3+88kgiIY9fZzLE9PnhvN9lXuYrxJsi9x1o4cdaJV1iUHKaRYdVP75H+PZKJoefqeUmdnwXWTZVGxKNxhX4218QUdP1VTj64H/JInrL9SWl8s4w3K47CiYW64Tpjs80e7+bLLJ3PszP/fK3ArM6SVd4uK4/g+5/gZ+L11kp2JbB3wI74UorhXD6n/Pr4cms9pASlHxsK3yyT2MX1zFGhuXFOqsy2s+5jiCLLTaSj/XYMEK2dJNa9Dm4ftoQ==",
    user      => "root",
  }

  ssh_authorized_key{"jean-baptiste.aubort@camptocamp.com on root":
    ensure    => present,
    type      => "ssh-rsa",
    key       => "AAAAB3NzaC1yc2EAAAABIwAAAQEA969YbG4AU9P17rXfo2izn2vNB/DoLnLHEbU/NraxZTVFKkCq/+f3DF91Apgck/UJtDEZMwvjtUOjG8gXjcSufzFAN0BhmBSF1jhUUhFy373hazN8g4YKOj3E65XsqFB1Dte6M5yffAe3L3hXNMnbF4mc4jDI0e/dynfCME1T6hUQoFHFGjdgbjc6HYlTtbjwCq+m8CGzgdKM0tLf+rnRm6zBeYzz8Ao6GnHcLWbZ6HpuIyd+/rL9Th/tLXRAO4u1KiyS4jUK5dfwBduYeWh3AGBtBSw66RXvCexjdpykC5Cjn4rM2TiLltehmjxaVGOCNGIRBOJnrf7NQrFrUJ5gZw==",
    user      => "root",
  }

  file {"/root/.bash_logout":
    ensure => present,
    mode   => 600,
    source => "puppet:///c2c/etc/skel/.bash_logout",
  } 
  
  file {"/root/.bash_profile":
    ensure => present,
    mode   => 600,
    source => "puppet:///c2c/etc/skel/.bash_profile",
  }

  file {"/root/.bashrc":
    ensure => present,
    mode   => 600,
    source => "puppet:///c2c/etc/skel/.bashrc",
  }
  
  file {"/root/.screenrc":
    ensure => present,
    mode   => 600,
    source => "puppet:///c2c/etc/skel/.screenrc",
  }
}
