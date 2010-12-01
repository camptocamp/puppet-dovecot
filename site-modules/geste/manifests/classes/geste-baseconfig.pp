class geste::baseconfig {
  augeas {"disable password for ssh":
    context => "/files/etc/ssh/sshd_config",
    changes => [
      "set ChallengeResponseAuthentication no",
      "set PasswordAuthentication no"],
    notify => Service["ssh"],
  }
}
