class mw-xapian-client {
  file {"/root/.ssh":
    ensure => directory,
    mode   => 0600,
    owner  => root,
    group  => root,
  }

  file {"/root/.ssh/id_rsa_xapian_collector":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0600,
    require => File["/root/.ssh"],
    content => "-----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEA3KrdwV/GPF1uPdVPG9Vp358g+cuYZJk9ng/PmNVj1bj+znUd
NSYjblLGoLBFfQBp0x0OB3DgmzzHqbghPvydPmo1wEEHrI6AhO8VsGWssUHAFPMZ
m4rkIug1VhQf/uHbDV8k2tRxST5RBKGMiVJfekbMuVSrx7aHXF2GSMnSgJN/pe6q
11wihijYK/GkkAqVQ4T1LxugmuVrYcKN+0j6LVfmXnADabAtQ/c0G9DrqOsbXTEf
0uh1OP3IGZB2ptOAMQN6N9i7l6ZmicCvJl9RJYnhi/BzEVo/Lu9pEo4Db5anB7J3
lbBbMz/sl8BBwPSCOyW0n3jw6MoCWz8a9zb6YQIBIwKCAQB3ynhhqQU2tmBqtZ/5
KrXRKn+di8fBlQQxO8h3ich7Vcwm7x578CHczdmKblGboSOBO6iHsk4LIP6slyf9
nxOISEkQmFSfgI7pFBMWnZhC986sSXRNH4Mo5HS5sydP2bFtqK2bXWIR0V8uZlOb
ANS+uLhHWdmYTSTo/5IKQazJc6JFzeAlcSmaVNmaUf4wiA8arVJjqOuApzpiQyVh
PqL2/sO3SZD+wVE4RoLOc5qwSdHiKWUw/0VTywRcvHioh2BAwO9iiV8NwK8YhDpM
2Y6pCfikAWROKODEFOTwRuOL1a7YEUbees6Zwq8Jq6eWHCcg2RL0uexCKNE/9Xvi
mCLfAoGBAPK9PSGkEw0nPo40IernKbYT8k3q6jxWREk9TFrTGWmA0zzcFa+ohfmS
NAkCOXJ2tJ7ZGT0Fkz+AsundWVRaPaBOMqn+IvNAb9fVXk/Ml+bdW8V7BygLqJzl
lI3utryRii/523fL+kQmk/lwpEt2moxmu6L59uCcn6oM/BqcMHzbAoGBAOi48uxM
oQwaMwn2fA3WNxQ0U2BWttreX5ulWNNaGn9sQ5HSZwVKMeFyhKXuINWBroCgHHk9
LiHNGEH9LMrFS6fXUnWRq0GpqzE2YVJFegUrvWz9vk7hgUecyJO6EVLcdV1k35gv
4VcZ2YhLMJkoW/6X56tb9a3tPXiHmb3Uj+xzAoGBAIPF0Lp9o/Eyj6xIL6tni6v8
MxRa9C9iB8/8tGvRrrWdtIAftABFio7LtdkBNSDhWryhvT5iHLwSqkRw2LjDRgaQ
2ay9KOpzb+ox//9vEKHl4VyTPmYyNvYWOrNy9XxPAd+HowaErG4jkihTF1wqcSel
e82AYXKeKsoHDIN5XCaFAoGBAOISwBi/d9/e78CJCsuc5QxQFnrX5NSdgXKgn246
RaBaisgregUjgOmicjrKEURvWQ88c2518ky4mzjKDkFR8bj9DkZS/iKHkFuxK1c8
LWQb3JXDSygOQxJdyikbJsWFs9cRiL+5e9D0iiyg0B/AzmUIl+hKtCVM3KD4wTwQ
UUwXAoGAYfMgmMov+w1k/zEo8QE2DVIca9l62EO330vwUI9rjuaVqk7nKMrgc8MQ
uIgLUeQ1NojzLHhKK8pQJb7C8gGvBWgPtd4vfwAf7bw+L2kdSy6rfq4cKXpT879D
HY9HnI5b0I/EF00fKdMMn6FlHspS5xAs5b1hOY/pUyAU1reNsdk=
-----END RSA PRIVATE KEY-----
"
  }
}

